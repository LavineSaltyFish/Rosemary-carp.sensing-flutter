/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [StudyDeploymentController] controls the execution of a [CAMSMasterDeviceDeployment].
class StudyDeploymentController {
  int _samplingSize = 0;
  Stream<DataPoint> _events;
  StreamController<StudyDeploymentControllerState> _stateEventsController =
      StreamController();
  StudyDeploymentControllerState _state =
      StudyDeploymentControllerState.unknown;

  int debugLevel = DebugLevel.WARNING;
  CAMSMasterDeviceDeployment deployment;
  StudyDeploymentExecutor executor;
  DataManager dataManager;
  SamplingSchema samplingSchema;
  String privacySchemaName;
  DataPointStreamTransformer transformer;

  /// The permissions granted to this study from the OS.
  Map<Permission, PermissionStatus> permissions;

  /// The stream of all sampled data points.
  ///
  /// Data points in the [events] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [deployment]
  ///   3. any custom [transformer] provided
  ///
  /// This is a broadcast stream and supports multiple subscribers.
  Stream<DataPoint> get events {
    _events ??= transformer(executor.events
        .map((dataPoint) => DataPointTransformerSchemaRegistry()
            .lookup(privacySchemaName)
            .transform(dataPoint))
        .map((dataPoint) => DataPointTransformerSchemaRegistry()
            .lookup(deployment.dataFormat)
            .transform(dataPoint))).asBroadcastStream();

    return _events;
  }

  /// The stream of state events for this controller.
  Stream<StudyDeploymentControllerState> get stateEvents =>
      _stateEventsController.stream;

  /// The current runtime state of this controller.
  StudyDeploymentControllerState get state => _state;

  /// Set the state of this controller.
  void set state(StudyDeploymentControllerState newState) {
    _state = newState;
    _stateEventsController.add(newState);
  }

  PowerAwarenessState powerAwarenessState = NormalSamplingState.instance;

  /// The sampling size of this [deployment] in terms of number of [Datum] object
  /// that has been collected.
  int get samplingSize => _samplingSize;

  /// Create a new [StudyDeploymentController] to control the [deployment].
  ///
  /// A number of optional parameters can be specified:
  ///    * A custom study [executor] can be specified.
  ///      If null, the default [StudyExecutor] is used.
  ///    * A specific [samplingSchema] can be used.
  ///      If null, [SamplingSchema.normal] with power-awareness is used.
  ///    * A specific [dataManager] can be provided.
  ///      If null, a [DataManager] will be looked up in the
  ///      [DataManagerRegistry] based on the type of the study's [DataEndPoint].
  ///      If no data manager is found in the registry, then no data management
  ///      is done, but sensing can still be initiated. This is useful for apps
  ///      which wants to use the framework for in-app consumption of sensing
  ///      events without saving the data.
  ///    * The name of a [PrivacySchema] can be provided in [privacySchemaName].
  ///      Use [PrivacySchema.DEFAULT] for the default, built-in schema.
  ///      If null, no privacy schema is used.
  ///    * A generic [transformer] can be provided which transform each collected data.
  ///      If null, a 1:1 mapping is done, i.e. no transformation.
  ///
  /// Datum in the [events] stream are transformed in the following order:
  ///   1. privacy schema as specified in the [privacySchemaName]
  ///   2. preferred data format as specified by [dataFormat] in the [deployment]
  ///   3. any custom [transformer] provided
  StudyDeploymentController(
    this.deployment, {
    this.executor,
    this.samplingSchema,
    this.dataManager,
    this.privacySchemaName,
    this.transformer,
    this.debugLevel = DebugLevel.WARNING,
  }) : super() {
    assert(deployment != null);
    // set global debug level
    globalDebugLevel = debugLevel;

    // initialize settings
    settings.init();

    // create and register the two built-in data managers
    DataManagerRegistry().register(ConsoleDataManager());
    DataManagerRegistry().register(FileDataManager());

    // if a data manager is provided, register this
    if (dataManager != null) DataManagerRegistry().register(dataManager);

    // now initialize optional parameters
    executor ??= StudyDeploymentExecutor(deployment);
    samplingSchema ??= SamplingSchema.normal(powerAware: true);
    dataManager ??= (deployment.dataEndPoint != null)
        ? DataManagerRegistry().lookup(deployment.dataEndPoint.type)
        : null;
    privacySchemaName ??= NameSpace.CARP;
    transformer ??= ((events) => events);

    state = StudyDeploymentControllerState.created;
  }

  /// Initialize this controller. Must be called only once,
  /// and before [resume] is called.
  Future initialize() async {
    assert(executor.validNextState(ProbeState.initialized),
        'The study executor cannot be initialized - it is in state ${executor.state}');

    // initialize settings
    await settings.init();

    // initialize access to basic device info
    await DeviceInfo().init();

    // if no user is specified for this study, look up the local user id
    deployment.userId ??= await settings.userId;

    // setting up permissions
    permissions = await PermissionHandlerPlatform.instance
        .requestPermissions(SamplingPackageRegistry().permissions);
    SamplingPackageRegistry().permissions.forEach((permission) {
      PermissionStatus status = permissions[permission];
      if (status != PermissionStatus.granted) {
        warning(
            'Permissions not granted for $permission, permission is $status');
      }
    });

    info('CARP Mobile Sensing (CAMS) - Initializing Study Controller: ');
    info('      study id : ${deployment.studyId}');
    info(' deployment id : ${deployment.studyDeploymentId}');
    info('    study name : ${deployment.name}');
    info('          user : ${deployment.userId}');
    info('      endpoint : ${deployment.dataEndPoint}');
    info('   data format : ${deployment.dataFormat}');
    info('      platform : ${DeviceInfo().platform.toString()}');
    info('     device ID : ${DeviceInfo().deviceID.toString()}');
    info('  data manager : ${dataManager?.toString()}');
    info('   permissions : ${permissions?.toString()}');

    if (samplingSchema != null) {
      // doing two adaptation is a bit of a hack; used to ensure that
      // restoration values are set to the specified sampling schema
      deployment.adapt(samplingSchema, restore: false);
      deployment.adapt(samplingSchema, restore: false);
    }

    // initialize the data manager, device registry, and study executor
    await dataManager?.initialize(deployment, events);
    await DeviceRegistry().initialize(deployment, events);
    executor.initialize(Measure(
        type: DataType(NameSpace.CARP, CAMSDataType.EXECUTOR).toString()));
    await enablePowerAwareness();
    events.listen((datum) => _samplingSize++);

    state = StudyDeploymentControllerState.initialized;
  }

  final BatteryProbe _battery = BatteryProbe();

  /// Enable power-aware sensing in this study. See [PowerAwarenessState].
  Future enablePowerAwareness() async {
    if (samplingSchema.powerAware) {
      info('Enabling power awareness ...');
      _battery.events.listen((dataPoint) {
        BatteryDatum batteryState = (dataPoint.carpBody as BatteryDatum);
        if (batteryState.batteryStatus == BatteryDatum.STATE_DISCHARGING) {
          // only apply power-awareness if not charging.
          PowerAwarenessState newState =
              powerAwarenessState.adapt(batteryState.batteryLevel);
          if (newState != powerAwarenessState) {
            powerAwarenessState = newState;
            info(
                'PowerAware: Going to $powerAwarenessState, level ${batteryState.batteryLevel}%');
            deployment.adapt(powerAwarenessState.schema);
          }
        }
      });
      _battery.initialize(Measure(
          type: DataType(NameSpace.CARP, DeviceSamplingPackage.BATTERY)
              .toString()));
      _battery.resume();
    }
  }

  /// Disable power-aware sensing.
  void disablePowerAwareness() {
    _battery.stop();
  }

  /// Resume this controller, i.e. resume data collection according to the
  /// specified [deployment] and [samplingSchema].
  @Deprecated('Use the resume() method instead')
  void start() {
    resume();
  }

  /// Resume this controller, i.e. resume data collection according to the
  /// specified [deployment] and [samplingSchema].
  void resume() {
    info('Resuming data sampling ...');
    executor.resume();
    state = StudyDeploymentControllerState.resumed;
  }

  /// Pause this controller, which will pause data collection and close the
  /// data manager.
  void pause() {
    info('Pausing data sampling ...');
    executor.pause();
    state = StudyDeploymentControllerState.paused;
    dataManager?.close();
  }

  /// Stop the sampling.
  ///
  /// Once a controller is stopped it **cannot** be (re)started.
  /// If a controller should be restarted, use the [pause] and [resume] methods.
  void stop() {
    info('Stopping data sampling ...');
    disablePowerAwareness();
    dataManager?.close();
    executor.stop();
    state = StudyDeploymentControllerState.stopped;
  }
}

/// Enumerates the stat a [StudyDeploymentController] can be in.
enum StudyDeploymentControllerState {
  unknown,
  created,
  initialized,
  resumed,
  paused,
  stopped,
}

/// This default power-awareness schema operates with four power states:
///
///
///       0%   10%        30%        50%                         100%
///       +-----+----------+----------+----------------------------+
///        none   minimum     light              normal
///
abstract class PowerAwarenessState {
  static const int LIGHT_SAMPLING_LEVEL = 50;
  static const int MINIMUM_SAMPLING_LEVEL = 30;
  static const int NO_SAMPLING_LEVEL = 10;

  static PowerAwarenessState instance;

  PowerAwarenessState adapt(int level);
  SamplingSchema get schema;
}

class NoSamplingState implements PowerAwarenessState {
  static NoSamplingState instance = NoSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level > PowerAwarenessState.NO_SAMPLING_LEVEL) {
      return MinimumSamplingState.instance;
    } else {
      return NoSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().none();

  String toString() => 'Disabled Sampling Mode';
}

class MinimumSamplingState implements PowerAwarenessState {
  static MinimumSamplingState instance = MinimumSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.NO_SAMPLING_LEVEL) {
      return NoSamplingState.instance;
    } else if (level > PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
      return LightSamplingState.instance;
    } else {
      return MinimumSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().minimum();

  String toString() => 'Minimun Sampling Mode';
}

class LightSamplingState implements PowerAwarenessState {
  static LightSamplingState instance = LightSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.MINIMUM_SAMPLING_LEVEL) {
      return MinimumSamplingState.instance;
    } else if (level > PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
      return NormalSamplingState.instance;
    } else {
      return LightSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingPackageRegistry().light();

  String toString() => 'Light Sampling Mode';
}

class NormalSamplingState implements PowerAwarenessState {
  static NormalSamplingState instance = NormalSamplingState();

  PowerAwarenessState adapt(int level) {
    if (level < PowerAwarenessState.LIGHT_SAMPLING_LEVEL) {
      return LightSamplingState.instance;
    } else {
      return NormalSamplingState.instance;
    }
  }

  SamplingSchema get schema => SamplingSchema.normal();

  String toString() => 'Normal Sampling Mode';
}
