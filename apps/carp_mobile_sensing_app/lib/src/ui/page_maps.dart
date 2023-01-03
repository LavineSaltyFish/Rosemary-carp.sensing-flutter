part of mobile_sensing_app;

class PageMaps extends StatefulWidget {
  @override
  _PageMapsState createState() => _PageMapsState();
}

class _PageMapsState extends State<PageMaps> {
  // set init cam pos to København
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(55.67594, 12.56553),
    zoom: 12,
  );

  DirectionService _directionService = DirectionService();
  Completer<GoogleMapController> _mapsController = Completer();
  DirectionModel? _info;

  FindPlaceService _findPlaceService = FindPlaceService();
  FindPlaceModel? _place;

  TextEditingController originTextController = TextEditingController();
  TextEditingController destTextController = TextEditingController();
  String displayText = "";

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;

  // static late ValueNotifier<LatLng> curLocationNotifier;
  Marker? _curLocationMarker;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    // tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    // tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Column(
        // alignment: Alignment.center,
        children: [
          findPlaceOriginBox(),
          findPlaceDestinationBox(),
          showRouteButton(),
          Expanded(
            child: _buildGoogleMap(),
          ),
          startDirectionButton(),
        ],
      ),
    );
  }

  //#region GOOGLE_MAP WIDGET

  Widget _buildGoogleMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onMapCreated,
      markers: {
        if (_origin != null) _origin!,
        if (_destination != null) _destination!,
        if (_curLocationMarker != null) _curLocationMarker!
      },
      polylines: {
        if (_info != null)
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.deepOrange,
            width: 5,
            points: _info!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
      }
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;

    LocationManager().registerListener(() {
      setCurLocation(LocationManager().getValue());
    });
  }

  //#endregion GOOGLE_MAP WIDGET

  //#region FIND_PLACE WRAPPER

  Future<FindPlaceModel?> findPlace(String text) async {
    _findPlaceService.locationInput = text;
    return await _findPlaceService.run();
  }

  Widget findPlaceOriginBox() {
    return Row(
        children: [
          Expanded(
            child: TextField(
              controller: originTextController,
              maxLines: null,
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () async {
                  FindPlaceModel? model = await findPlace(originTextController.text);
                  setState(() {
                    _origin = setMapMarker(model!.location, "origin");
                    setMapCamera(model!.location, 12);
                  });
                },
                child: Text("Find Origin")
            ),
          )
        ]
    );
  }

  Widget findPlaceDestinationBox() {
    return Row(
        children: [
          Expanded(
            child: TextField(
              controller: destTextController,
              maxLines: null,
            ),
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () async {
                  FindPlaceModel? model = await findPlace(destTextController.text);
                  setState(() {
                    _destination = setMapMarker(model!.location, "destination");
                    setMapCamera(model!.location, 12);
                  });
                },
                child: Text("Find Destination")
            ),
          )
        ]
    );
  }

  //#endregion FIND_PLACE WRAPPER

  //#region DIRECTION WRAPPER

  Future<DirectionModel?> direction(Marker origin, Marker destination) async {
    _directionService.origin = origin!.position;
    _directionService.destination = destination!.position;

    return await _directionService.run();
  }

  Widget showRouteButton() {
    return ElevatedButton(
        onPressed: () async {
          final directions = await direction(_origin!, _destination!);
          setState(() => _info = directions);
        },
        child: Text("Show Route!")
    );
  }

  Widget startDirectionButton() {
    return ElevatedButton(
        onPressed: () {
          if (_info == null) {
            return;
          }

          BlocDataCollector().resume();

          /* In the Flutter SDK the .of methods are a kind of service locator function
          that take the framework BuildContext as an argument and return an internal API
          related to the named class but created by widgets higher up the widget tree.
          These APIs can then be used by child widgets to access state
          set on a parent widget and in some cases (such as Navigator) to manipulate them.
          The pattern encourages componentization and decouples the production of information related to the build tree with its consumption. */
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NavigatePage()),
          );
        },
        child: Text("Start Direction!")
    );
  }

  //#endregion

  //#region UTILITIES

  Marker setMapMarker(LatLng pos, String id) {
    return Marker(
      markerId: MarkerId(id),
      infoWindow: InfoWindow(title: id),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pos,
    );
  }

  void setMapCamera(LatLng pos, double zoom) {
    _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              target: pos,
              zoom: zoom,
              // tilt: 50.0,
            )
        )
    );
  }

  void setCurLocation(LatLng pos) {
    setState(() {
      _curLocationMarker = Marker(
        markerId: MarkerId("curLocation"),
        infoWindow: InfoWindow(title: "curLocation"),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        position: pos,
      );
    });

    setMapCamera(pos, 12);
  }

  //#endregion UTILITIES

}

