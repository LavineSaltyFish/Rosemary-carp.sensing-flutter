part of mobile_sensing_app;

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    Sensing().controller?.data
        .where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
        .listen((event) => _onLocationAcquired(event));
  }

  void _onLocationAcquired(DataPoint data) {
    print("MAN Location information acquired!");

    var locationDataDict = data.carpBody;
    final latitude = locationDataDict!["latitude"] as double;

    print(latitude);
  }
}
