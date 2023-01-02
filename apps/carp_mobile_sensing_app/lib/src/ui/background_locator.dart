part of mobile_sensing_app;

class LocationManager {
  LocationManager._internal();

  static final LocationManager _instance = LocationManager._internal();

  factory LocationManager() {
    return _instance;
  }

  // LatLng get curLocation => _curLocation.value;
  ValueNotifier<LatLng> _curLocationNotify = ValueNotifier<LatLng> (new LatLng(0.0, 0.0));
  ValueNotifier<double> _slopeNotify = ValueNotifier<double>(0.0);

  Map<String, dynamic>? _prevLocationInfo = null;

  void onUpdate(DataPoint data) {
    var dataDict = data.carpBody;
    _curLocationNotify.value = LatLng(
        dataDict!["latitude"]as double, dataDict!["longitude"] as double);

    calcSlope(data);
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

  LatLng getValue() {
    return _curLocationNotify.value;
  }

  //#region UTILITIES

  double degToRad(num deg) => deg * (pi / 180.0);
  double radToDeg(num rad) => rad * (180.0 / pi);

  LatLng getLatLngFromJsonMap(Map<String, dynamic> map) {
    return LatLng(map!["latitude"]as double, map!["longitude"]as double);
  }
  //
  // U getFromJsonMap<U, T>(Map<String, dynamic> map, String propertyName) {
  //
  // }

  //#endregion


  //#region SLOPE
  double updateDistance(LatLng startLoc, LatLng endLoc) {
    final sDLat = sin((degToRad(endLoc.latitude) - degToRad(startLoc.latitude)) / 2);
    final sDLng = sin((degToRad(endLoc.longitude) - degToRad(startLoc.longitude)) / 2);
    final a = sDLat * sDLat +
        sDLng *
            sDLng *
            cos(degToRad(startLoc.latitude)) *
            cos(degToRad(endLoc.latitude));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return 6371000.0 * c;
  }

  double updateElevation(double startAltitude, double endAltitude) {
    return (endAltitude - startAltitude);
  }

  double updateSlope(double distance, double elevation) {
    return radToDeg(atan2(elevation, distance));
  }

  void calcSlope(DataPoint data) { // Map<String, dynamic> prevLocationInfo, Map<String, dynamic> curLocationInfo) {
    if (_prevLocationInfo == null) {
      _prevLocationInfo = data.carpBody;
      return ;
    }

    var curLocationInfo = data.carpBody;
    // var d = updateDistance(getLatLngFromJsonMap(_prevLocationInfo!), getLatLngFromJsonMap(curLocationInfo!));
    // var e = updateElevation(_prevLocationInfo!["altitude"] as double, curLocationInfo!["altitude"] as double);

    _slopeNotify.value = updateSlope(
        updateDistance(getLatLngFromJsonMap(_prevLocationInfo!), getLatLngFromJsonMap(curLocationInfo!)),
        updateElevation(_prevLocationInfo!["altitude"] as double, curLocationInfo!["altitude"] as double)
    );

    _prevLocationInfo = curLocationInfo;

  }
  //#endregion
}