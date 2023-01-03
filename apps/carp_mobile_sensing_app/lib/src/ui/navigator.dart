part of mobile_sensing_app;

//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/percent_indicator.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  // LatLng? googleMapsCenter;
  // final googleMapsController = Completer<GoogleMapController>();
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  // Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller;

   static final CameraPosition _kGooglePlex = CameraPosition(
           target: LocationManager()._curLocationNotify.value,
           zoom: 12,
         );

  @override
  Widget build(BuildContext context) {
    setState(() { });

    return Scaffold(
      // bottomNavigationBar: null,
      // key: scaffoldKey,
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
                  // myLocationEnabled: true,
                  markers: {
                    if (_curLocationMarker != null) _curLocationMarker!
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
                    _controller = controller;
                    BlocDataCollector._latitude.addListener(() {
                      _controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: new LatLng(
                                  BlocDataCollector._latitude.value,
                                  BlocDataCollector._longitude.value),
                              zoom: 14.5,
                              // tilt: 50.0,
                            )
                        )
                      );
                    }
                    );

                    BlocDataCollector._longitude.addListener(() {
                      _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: new LatLng(
                                    BlocDataCollector._latitude.value,
                                    BlocDataCollector._longitude.value),
                                zoom: 14.5,
                                // tilt: 50.0,
                              )
                          )
                      );
                    }
                    );

                    LocationManager()._curLocationNotify.addListener(() {
                      setCurLocation(LocationManager().getValue());
                    });
                  }
              ),
        )
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
                                      valueListenable: BlocDataCollector._time,
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
                                          valueListenable: BlocDataCollector._speed,
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
                                          valueListenable: BlocDataCollector._heartRate,
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
                      // ),
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
                                        valueListenable: BlocDataCollector._weather,
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
                                        valueListenable: BlocDataCollector._windSpeed,
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
              ),
              stopDirectionButton(),
            ]
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            BlocDataCollector().toggle();
          })
        },
        tooltip: 'Restart study & probes',
        child: BlocDataCollector().isBlocRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }

  Widget stopDirectionButton() {
    return ElevatedButton(
        onPressed: () {
          if (BlocDataCollector().isBlocRunning) {
            BlocDataCollector().pause();
          }

          Navigator.pop(context);
        },
        child: Text("Stop Direction!")
    );
  }

  Marker? _curLocationMarker;

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

    setMapCamera(pos, 14);
  }

  void setMapCamera(LatLng pos, double zoom) {
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              target: pos,
              zoom: zoom,
              // tilt: 50.0,
            )
        )
    );
  }
}



