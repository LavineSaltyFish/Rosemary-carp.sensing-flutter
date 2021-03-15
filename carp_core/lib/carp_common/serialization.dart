/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// This is the base class for all JSON serializable objects.
///
/// Using this class allow for implementing both serialization and
/// deserialization to/from JSON.
/// This is done using the [json_serializable](https://pub.dev/packages/json_serializable)
/// package.
///
/// To support serialization, each subclass should implement the [toJson] method.
/// For example:
///
///     Map<String, dynamic> toJson() => _$StudyToJson(this);
///
/// To support deserialization, each JSON object should inlude its [format]
/// (i.e., class name) information. In JSON this is identified by the
/// [CLASS_IDENTIFIER] static property.
/// In order to support de-serialization for a specific Flutter class,
/// the [fromJsonFunction] getter and a class factory must be implemented.
/// For example:
///
///    Function get fromJsonFunction => _$StudyFromJson;
///    factory Study.fromJson(Map<String, dynamic> json) =>
///      FromJsonFactory()
///          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
///
/// Finally, the [fromJsonFunction] must be registered on app startup (before
/// use of de-serialization) in the [FromJsonFactory] singleton, like this:
///
///        FromJsonFactory().register(Study._());
///
/// Note that any constructur will work, since only the `fromJsonFunction`
/// function is used. Hence, a private constructure like `Study._()` is fine.
abstract class Serializable {
  /// The identifier of the class type in JSON serialization.
  static const String CLASS_IDENTIFIER = '\$type';

  /// The runtime class name (type) of this object.
  /// Used for deserialization from JSON objects.
  String $type;

  /// Create an object that can be serialized to JSON.
  Serializable() {
    $type = jsonType;
  }

  /// The function which can convert a JSON string to an object of this type.
  Function get fromJsonFunction;

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson();

  /// Return the [$type] to be used for JSON serialization of this class.
  /// Default is [runtimeType]. Only specify this if you need another type.
  String get jsonType => this.runtimeType.toString();
}

/// A factory that holds [fromJson] functions to be used in JSON
/// deserialization.
class FromJsonFactory {
  static final FromJsonFactory _instance = FromJsonFactory._();
  factory FromJsonFactory() => _instance;

  final Map<String, Function> _registry = {};

  // When initializing this factory, register all CAMS classes which should
  // support deserialization from JSON.
  //
  // TODO: Remember to add any new classes here.
  // TODO: This could be auto-generated using a builder....
  FromJsonFactory._() {
    // DEPLOYMENT
    register(DeviceRegistration());
    register(DeviceRegistration(),
        type:
            'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration');

    register(DeviceDeploymentStatus());
    register(
      DeviceDeploymentStatus(),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered',
    );
    register(
      DeviceDeploymentStatus(),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered',
    );
    register(
      DeviceDeploymentStatus(),
      type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed',
    );
    register(DeviceDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment');

    register(StudyDeploymentStatus());
    register(StudyDeploymentStatus(),
        type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited');
    register(StudyDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices');
    register(StudyDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady');
    register(StudyDeploymentStatus(),
        type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped');

    // PROTOCOL
    register(StudyProtocol());
    register(Trigger());
    register(ElapsedTimeTrigger());
    register(ManualTrigger());
    register(ScheduledTrigger());

    register(TaskDescriptor());
    register(ConcurrentTask());
    register(CustomProtocolTask());
    register(Measure(type: 'ignored'));
    register(DataTypeMeasure(type: 'ignored'));
    register(PhoneSensorMeasure(type: 'ignored'));
    register(SamplingConfiguration());

    register(DeviceDescriptor());
    register(MasterDeviceDescriptor());
    register(Smartphone());
    register(DeviceDescriptor(),
        type:
            'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
    register(DeviceDescriptor(),
        type:
            'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');
  }

  /// Register a [Serializable] class which can be deserialized from JSON.
  ///
  /// If [type] is specified, then this is used as the type indentifier as
  /// specified in [CLASS_IDENTIFIER].
  /// Othervise the [Serializable] class [jsonType] is used.
  ///
  /// A type needs to be registered **before** a class can be deserialized from
  /// JSON to a Flutter class.
  void register(Serializable serializable, {String type}) {
    assert(serializable is Serializable);
    type ??= serializable.jsonType;
    _registry['$type'] = serializable.fromJsonFunction;
  }

  /// Deserialize [json] of the specified class [type].
  Serializable fromJson(String type, Map<String, dynamic> json) =>
      Function.apply(_registry[type], [json]);
}
