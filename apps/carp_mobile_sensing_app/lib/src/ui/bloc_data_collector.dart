part of mobile_sensing_app;

class BlocDataCollector {

  //#region SINGLETON

  BlocDataCollector._internal();

  static final BlocDataCollector _instance = BlocDataCollector._internal();

  factory BlocDataCollector() {
    return _instance;
  }

  //#endregion SINGLETON

  //#region VALUE_NOTIFIERS

  static ValueNotifier<double> _speed = ValueNotifier<double>(0.0);
  static ValueNotifier<Duration> _time = ValueNotifier<Duration>(Duration(hours:0,minutes:0,seconds:0));
  static ValueNotifier<double> _gyro = ValueNotifier<double>(0.0);
  static ValueNotifier<int> _heartRate = ValueNotifier<int>(0);
  //static ValueNotifier<double> _heartRate = ValueNotifier<double>(0.0);

  static ValueNotifier<String> _weather = ValueNotifier<String>("-");
  static ValueNotifier<double> _windSpeed = ValueNotifier<double>(0.0);

  static ValueNotifier<double> _latitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.latitude);
  static ValueNotifier<double> _longitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.longitude);

  //#endregion VALUE_NOTIFIERS

  //#region BLOC CONTROLS

  void toggle() {
    bloc.isRunning ? pause() : resume() ;
  }

  void pause() {
    bloc.pause();
    //_time.value = Duration(seconds: 0);
    isTimerOn = false;
  }

  void resume() {
    bloc.resume();
    isTimerOn = true;

    DateTime startTime = DateTime.now();
    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (!isTimerOn) {
        timer.cancel();
      }
      else {
        _time.value = _onTimerUpdated(startTime);
      }
    });

    Sensing().controller?.data
    //.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
        .listen((dataPoint) => _onMoveAcquired(dataPoint));

    Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == PolarSamplingPackage.POLAR_HR)
        .listen((dataPoint) => _onHeartRateAcquired(dataPoint));

    Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.WEATHER)
        .listen((dataPoint) => _onWeatherAcquired(dataPoint));
  }

  //#endregion BLOC CONTROLS

  bool get isBlocRunning => bloc.isRunning;

  //#region ON DATA COLLECTED CALLBACKS

  bool isTimerOn = false;

  void _onMoveAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _speed.value = dataDict!["speed"]*3.6 as double;

    //_time.value = dataDict!["distance_travelled"] as double;

  }

  void _onWeatherAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _weather.value = dataDict!["weather_main"] as String;
    _windSpeed.value = dataDict!["wind_speed"] as double;
  }

  void _onHeartRateAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _heartRate.value = dataDict!["hr"] as int;


  }

  Duration _onTimerUpdated(DateTime startTime) {
    return DateTime.now().difference(startTime);
  }

  //#endregion ON DATA COLLECTED CALLBACKS

}