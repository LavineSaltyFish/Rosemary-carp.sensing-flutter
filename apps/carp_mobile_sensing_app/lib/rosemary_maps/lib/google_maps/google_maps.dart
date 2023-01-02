part of rosemary_maps;

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({ super.key });
  static String googleAPIKey = "AIzaSyA4SIAugHtIM3438XC9lZIgiBVxUTi2cMg";

  @override
  _GoogleMapsState createState() => new _GoogleMapsState();

  // Singleton instance
  // GoogleMaps._();
  // static final GoogleMaps _instance = GoogleMaps._();
  // factory GoogleMaps() => _instance;

  // DirectionService directionService = DirectionService();
  //
  // Future<DirectionModel?> getDirection() async {
  //   return await directionService.run();
  // }

  //#endregion

}

class _GoogleMapsState extends State<GoogleMaps> {
  // static String googleAPIKey = "AIzaSyA4SIAugHtIM3438XC9lZIgiBVxUTi2cMg";
  late GoogleMapController controller;

  //#region WIDGET BUILD

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
        CameraPosition(
          target: new LatLng(0, 0),
          zoom: 12,
          // tilt: 50.0,
        ),
      onMapCreated: _onMapCreated,
      markers: markers,
      polylines: polylines,
    );
  }

  //#endregion WIDGET BUILD

  //#region MARKER

  Set<Marker> markers = new Set();
  bool currentLocationMarkerEnabled = false;
  Marker? curLocationMarker;

  void enableCurrentLocationMarker(bool enable) {
    setState(() {
      currentLocationMarkerEnabled = enable;
    });
  }

  void addMarker(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  void addMarkerUsingId(LatLng latLng, String markerId) {
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: markerId),
      position: latLng,
    );

    addMarker(marker);
  }

  void removeMarker(Marker marker) {
    setState(() {
      markers.remove(marker);
    });
  }

  void removeMarkerUsingId(String markerId) {
    setState(() {
      markers.removeWhere((element) => element.markerId == markerId);
    });
  }

  //#endregion MARKER

  //# region POLYLINE

  Set<Polyline> polylines = new Set();

  void addPolyline(Polyline polyline) {
    setState(() {
      polylines.add(polyline);
    });
  }

  void addPolylineUsingId(List<LatLng> points, String polylineId) {
    Polyline polyline = new Polyline(
      polylineId: PolylineId(polylineId),
      width: 5,
      points: points,
    );

    addPolyline(polyline);
  }

  void removePolyline(Polyline polyline) {
    setState(() {
      polylines.remove(polyline);
    });
  }

  void removePolylineUsingId(String polylineId) {
    setState(() {
      polylines.removeWhere((element) => element.polylineId == polylineId);
    });
  }

  //#endregion POLYLINE

  //#region DIRECTION SERVICE

  DirectionService _directionService = DirectionService();

  void setOrigin(LatLng latLng) {
    _directionService.origin = latLng;
  }

  void setDestination(LatLng latLng) {
    _directionService.destination = latLng;
  }

  Future<DirectionModel?> getDirection() async {
    return await _directionService.run();
  }

  Future<DirectionModel?> getDirectionFromLatLng(LatLng origin, LatLng dest) async {
    setOrigin(origin);
    setDestination(dest);

    return await _directionService.run();
  }

  //#endregion DIRECTION SERVICE

  //#region FIND_PLACE SERVICE

  FindPlaceService _findPlaceService = FindPlaceService();

  void setFindPlaceInputText(String text) {
    _findPlaceService.locationInput = text;
  }

  Future<FindPlaceModel?> getPlace() async {
    return await _findPlaceService.run();
  }

  Future<FindPlaceModel?> getPlaceFromText(String place) async {
    setFindPlaceInputText(place);

    return await _findPlaceService.run();
  }

  //#endregion FIND_PLACE SERVICE

  //#region ON_MAP_CREATED

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  //#endregion ON_MAP_CREATED

}