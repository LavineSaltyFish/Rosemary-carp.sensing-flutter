part of mobile_sensing_app;


const kStartPosition = LatLng(18.488213, -69.959186);
const kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
const kMarkerId = MarkerId('MarkerId1');
const kDuration = Duration(seconds: 2);
const kLocations = [
  kStartPosition,
  LatLng(18.488101, -69.957995),
  LatLng(18.489210, -69.952459),
  LatLng(18.487307, -69.952759),
  LatLng(18.487308, -69.952759),
];

class SimpleMarkerAnimationExample extends StatefulWidget {
  @override
  SimpleMarkerAnimationExampleState createState() =>
      SimpleMarkerAnimationExampleState();
}

class SimpleMarkerAnimationExampleState
    extends State<SimpleMarkerAnimationExample> {
  final markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  final stream = Stream.periodic(kDuration, (count) => kLocations[count])
      .take(kLocations.length);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Markers Animation Example',
      home: Animarker(
        curve: Curves.bounceOut,
        rippleRadius: 0.2,
        useRotation: false,
        duration: Duration(milliseconds: 2300),
        mapId: controller.future
            .then<int>((value) => value.mapId), //Grab Google Map Id
        markers: markers.values.toSet(),
        child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kSantoDomingo,
            onMapCreated: (gController) {
              stream.forEach((value) => newLocationUpdate(value));
              controller.complete(gController);
              //Complete the future GoogleMapController
            }),
      ),
    );
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
        markerId: kMarkerId,
        position: latLng,
        ripple: true,
        onTap: () {
          print('Tapped! $latLng');
        });
    setState(() => markers[kMarkerId] = marker);
  }
}

//class MapsDemo extends StatefulWidget {
//   const MapsDemo({super.key});
//
//   @override
//   State<MapsDemo> createState() => MapsDemoState();
// }

// class MapsDemoState extends State<MapsDemo> {
//   //Setting dummies values
//
//
//   Completer<GoogleMapController> _controller = Completer();
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: Text('To the lake!'),
//         icon: Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//
//     Sensing().controller?.data
//         .where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
//         .listen((event) => _onLocationAcquired(event));
//   }
//
//   void _onLocationAcquired(DataPoint data) {
//     //print("MAN Location information acquired!");
//
//     var locationDataDict = data.carpBody;
//     final latitude = locationDataDict!["latitude"] as double;
//
//     print(latitude);
//   }
// }
