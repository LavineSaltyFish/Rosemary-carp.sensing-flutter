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

  static List<LatLng> polylineCoordinates = [];

  static const markerDuration = Duration(seconds: 1);
  static const markerkLocations = [
    kStartPosition,
    LatLng(18.488101, -69.957995),
    LatLng(18.489210, -69.952459),
    LatLng(18.487307, -69.952759),
    LatLng(18.487308, -69.952759),
  ];
  //final ValueNotifier<double> _speed = CarpMobileSensingAppState._speed


  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  // @override
  // void initState() {
  //   super.initState();
  //
  // }
  // void _onMapInit(DataPoint data) async {
  //   var dataDict = data.carpBody;
  //   CameraPosition _kGooglePlex = CameraPosition(
  //     target: LatLng(dataDict!["latitude"] as double, dataDict!["longitude"] as double),
  //     zoom: 14.4746,
  //   );
  //
  // }

   static final CameraPosition _kGooglePlex = CameraPosition(
           target: //LatLng(37.773972, -122.431297),
              LocationManager()._curLocationNotify.value,
           zoom: 14.4746,
         );
  static LatLng sourceLocation = _kGooglePlex.target;
  static LatLng destinationLocation = _kGooglePlex.target;


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
      bottomNavigationBar: null,
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
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId("source"),
                      position: sourceLocation),
                    Marker(
                        markerId: MarkerId("destination"),
                        position: destinationLocation)
                  },
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

              // Timer line
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Container(
                              //width:MediaQuery.of(context).size.width * 0.25,
                              //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                              height: MediaQuery.of(context).size.height * 0.08,
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
                                      valueListenable: CarpMobileSensingAppState._time,
                                      builder: (context, Duration value, child) {
                                        return Text(
                                            value.toString().split('.').first.padLeft(8, "0"),
                                            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center);}
                                  )
                              )
                          )),



              // Row 1: _speed, _heartRate, _gradient
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
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(
                                    color: Color(0x353938).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                    //                         border: Border.all(
                                    //                           color: Color(353938).withOpacity(0.5),
                                    //                           width: 5,
                                    //                         ),
                                  ),
                                  //child: Text('0.0')
                                  child: Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: CarpMobileSensingAppState._speed,
                                          builder: (context, double value, child) {
                                            return Text(
                                                value.toStringAsFixed(2) +" km/h",
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
                                  height: MediaQuery.of(context).size.height * 0.08,
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
                                          valueListenable: CarpMobileSensingAppState._heartRate,
                                          builder: (context, int value, child) {
                                            return Text(
                                                value.toString() + " BPM",
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
                                  height: MediaQuery.of(context).size.height * 0.08,
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
                                          valueListenable: LocationManager()._slopeNotify,
                                          builder: (context, double value, child) {
                                            return Text(
                                                value.toStringAsFixed(2),
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
                ),

              // Row 2: _weather, _windSpeed
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                            child:Container(
                                //width:MediaQuery.of(context).size.width * 0.25,
                                //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                height: MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  color: Color(0x353938).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                  //                         border: Border.all(
                                  //                           color: Color(353938).withOpacity(0.5),
                                  //                           width: 5,
                                  //                         ),
                                ),
                                //child: Text('0.0')
                                child: Center(
                                    child: ValueListenableBuilder(
                                        valueListenable: CarpMobileSensingAppState._weather,
                                        builder: (context, String value, child) {
                                          return Text(
                                              value,
                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center);}
                                    )
                                )
                            ))
                    ),

                    Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child:Container(
                                //width:MediaQuery.of(context).size.width * 0.25,
                                //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                height: MediaQuery.of(context).size.height * 0.08,
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
                                        valueListenable: CarpMobileSensingAppState._windSpeed,
                                        builder: (context, double value, child) {
                                          return Text(
                                              value.toStringAsFixed(2)+" km/h",
                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center);}
                                    )
                                )
                            ))
                    ),
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



