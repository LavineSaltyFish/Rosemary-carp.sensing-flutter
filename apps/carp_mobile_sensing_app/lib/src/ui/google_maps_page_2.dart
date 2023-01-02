part of mobile_sensing_app;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
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
  Marker? _originLocation;
  Marker? _destLocation;

  @override
  void dispose() {
    // _googleMapController.dispose();
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
          TextField(
            controller: originTextController,
            maxLines: null,
          ),
          ElevatedButton(
            onPressed: () async {
              _findPlaceService.locationInput = originTextController.text;
              FindPlaceModel? model = await _findPlaceService.run();
              setState(() {
                _origin = Marker(
                  markerId: const MarkerId('start'),
                  infoWindow: const InfoWindow(title: 'start'),
                  icon:
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  position: model!.location,
                );

                _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _origin!.position,
                          zoom: 14.5,
                          tilt: 50.0,
                        )
                    )
                );
              });
            },
            child: Text("Find Origin")
          ),
          TextField(
            controller: destTextController,
            maxLines: null,
          ),
          ElevatedButton(
              onPressed: () async {
                _findPlaceService.locationInput = destTextController.text;
                FindPlaceModel? model = await _findPlaceService.run();
                setState(() {
                  _destination = Marker(
                    markerId: const MarkerId('start'),
                    infoWindow: const InfoWindow(title: 'start'),
                    icon:
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    position: model!.location,
                  );

                  _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _destination!.position,
                            zoom: 14.5,
                            tilt: 50.0,
                          )
                      )
                  );
                });
              },
              child: Text("Find Destination")
          ),
          ElevatedButton(
              onPressed: () async {
                _directionService.origin = _origin!.position;
                _directionService.destination = _destination!.position;
                final directions = await _directionService.run();

                setState(() => _info = directions);
              },
              child: Text("Show Direction!")
          ),
          Expanded(
            child: _buildGoogleMap(),
          ),
          ElevatedButton(
              onPressed: () {
                if (_info == null) {
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavigatePage()),
                );
              },
              child: Text("Start Direction!")
          ),
          // if (_info != null)
          //   Positioned(
          //     top: 20.0,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         vertical: 6.0,
          //         horizontal: 12.0,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.yellowAccent,
          //         borderRadius: BorderRadius.circular(20.0),
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Colors.black26,
          //             offset: Offset(0, 2),
          //             blurRadius: 6.0,
          //           )
          //         ],
          //       ),
          //       child: Text(
          //         '${_info!.totalDistance}, ${_info!.totalDuration}',
          //         style: const TextStyle(
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  //#region Create google map widget

  Widget _buildGoogleMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: (controller) => _googleMapController = controller,
      //     (GoogleMapController controller) {
      //   _mapsController.complete(controller);
      // },
      markers: {
        if (_origin != null) _origin!,
        if (_destination != null) _destination!
      },
      polylines: {
        if (_info != null)
          Polyline(
            polylineId: const PolylineId('overview_polyline'),
            color: Colors.red,
            width: 5,
            points: _info!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
      },
      onLongPress: _addMarker,
    );
  }

  //#endregion

  //#region Google map utilities

  // void _onDirection() async {
  //   setState(() {
  //     _destination = Marker(
  //       markerId: const MarkerId('destination'),
  //       infoWindow: const InfoWindow(title: 'Destination'),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //       position: pos,
  //     );
  //   });
  //
  //   // Get directions
  //   _directionService.origin = _origin.position;
  //   _directionService.destination = _destination.position;
  //   final directions = await _directionService.run();
  //
  //   setState(() => _info = (directions ?? )!);
  // }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      print("voila voila");

      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      _directionService.origin = _origin!.position;
      _directionService.destination = _destination!.position;
      final directions = await _directionService.run();

      setState(() => _info = directions);

      print("voila done");
      print(_info == null);
    }
  }

//#endregion
}