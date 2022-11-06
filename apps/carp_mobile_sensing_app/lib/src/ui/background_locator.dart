part of mobile_sensing_app;

class LocationManager {
  LocationManager._internal();

  static final LocationManager _instance = LocationManager._internal();

  factory LocationManager() {
    return _instance;
  }

  // LatLng get curLocation => _curLocation.value;
  ValueNotifier<LatLng> _curLocationNotify = ValueNotifier<LatLng> (new LatLng(0.0, 0.0));

  void onUpdate(DataPoint data) {
    var dataDict = data.carpBody;
    _curLocationNotify.value = LatLng(
        dataDict!["latitude"] as double, dataDict!["longitude"] as double);
  }

  void initialize() {
    try {
      Sensing().controller?.data.where((dataPoint) =>
      dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
          .listen((dataPoint) => onUpdate(dataPoint));
    } catch (e) {
      print('No Sensing instance found!');
    }
  }

  void registerListener(VoidCallback onData) {
    _curLocationNotify.addListener(onData);
  }
}