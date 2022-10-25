part of mobile_sensing_app;

//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/percent_indicator.dart';

class NavigatePage  extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  // LatLng? googleMapsCenter;
  // final googleMapsController = Completer<GoogleMapController>();
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static LatLng sourceLocation = _kGooglePlex.target;
  static LatLng destinationLocation = _kGooglePlex.target;

  static List<LatLng> polylineCoordinates = [];

  //final ValueNotifier<double> _speed = CarpMobileSensingAppState._speed


  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);


  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        BuildSettings.mapsKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destinationLocation.latitude, destinationLocation.longitude)
    );
    if (result.points.isNotEmpty){
      result.points.forEach(
          (PointLatLng point)=>polylineCoordinates.add(LatLng(point.latitude, point.longitude))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // MAP
              Center(
                child: Container(
                //width: MediaQuery.of(context).size.width *0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                //padding: EdgeInsets.only(bottom: 16.0),
                  child :  GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  // markers: {
                  //   Marker(
                  //     markerId: MarkerId("source"),
                  //     position: sourceLocation),
                  //   Marker(
                  //       markerId: MarkerId("destination"),
                  //       position: destinationLocation)
                  // },
                  // polylines: {
                  //   Polyline(
                  //       polylineId: PolylineId("route"),
                  //       points:polylineCoordinates,
                  //       width:6,
                  //       color:Color(0x334621)
                  //   )
                  // },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);}
                  ),
                ),
              ),
              // PROGRESS  BAR
              // LinearPercentIndicator(
              //   percent: 0.5,
              //   width: MediaQuery.of(context).size.width,
              //   lineHeight: 16,
              //   animation: true,
              //   progressColor: Color(0xFF8C3838),
              //   backgroundColor: Color(0xFFDFB7B7),
              //   center: Text(
              //     '50%',
              //     style: FlutterFlowTheme.of(context).bodyText1.override(
              //       fontFamily: 'Poppins',
              //       color: Color(0xFF090202),
              //     ),
              //   ),
              //   padding: EdgeInsets.zero,
              // ),
              //
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: Color(0x353938).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    //                         border: Border.all(
                    //                           color: Color(353938).withOpacity(0.5),
                    //                           width: 5,
                    //                         ),
                  ),
                  child: Center(
                    child: Text(
                      'speed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFFBFAF8),
                          fontSize: 40
                      ),
                    ),
                  )
              ),
              ),
              Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child:Container(
                                  width:MediaQuery.of(context).size.width * 0.25,
                                  //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                  height: MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                    color: Color(0x353938).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                    //                         border: Border.all(
                                    //                           color: Color(353938).withOpacity(0.5),
                                    //                           width: 5,
                                    //                         ),
                                  ),
                                  child: Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: CarpMobileSensingAppState._speed,
                                          builder: (context, double value, child) {
                                            return Text(
                                                value.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.center);}
                                      )
                                  )
                              ))
                      ),

                      Flexible(
                              fit: FlexFit.tight,
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                  child:Container(
                                  width:MediaQuery.of(context).size.width * 0.25,
                                  //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                  height: MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                    color: Color(0x353938).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                    //                         border: Border.all(
                                    //                           color: Color(353938).withOpacity(0.5),
                                    //                           width: 5,
                                    //                         ),
                                  ),
                                  child: Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: CarpMobileSensingAppState._speed,
                                          builder: (context, double value, child) {
                                            return Text(
                                                value.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.center);}
                                      )
                                  )
                              ))
                      ),

                      Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child:Container(
                                  width:MediaQuery.of(context).size.width * 0.25 - 10,
                                  //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                  height: MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                    color: Color(0x353938).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                    //                         border: Border.all(
                                    //                           color: Color(353938).withOpacity(0.5),
                                    //                           width: 5,
                                    //                         ),
                                  ),
                                  child: Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: CarpMobileSensingAppState._speed,
                                          builder: (context, double value, child) {
                                            return Text(
                                                value.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.center);}
                                      )
                                  )
                              ))
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.2,
                      //   height: MediaQuery.of(context).size.height * 0.10,
                      //   decoration: BoxDecoration(
                      //     color: Color(0x353938).withOpacity(0.5),
                      //     borderRadius: BorderRadius.circular(15),
                      //     //                         border: Border.all(
                      //     //                           color: Color(353938).withOpacity(0.5),
                      //     //                           width: 5,
                      //     //                         ),
                      //   ),
                      //   child: ValueListenableBuilder(
                      //       valueListenable: _notify,
                      //       builder: (context, double value, child) {
                      //         return Text(
                      //             value.toString(),
                      //             style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                      //             textAlign: TextAlign.center);
                      //       }
                      //   ),
                      // )
                    ]
                )


            ]
          )
        )
      )
    );
  }


    //final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    // Sensing().controller?.data
    //     .where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
    //     .listen((event) => _onHeartRateAcquired(event));


}



