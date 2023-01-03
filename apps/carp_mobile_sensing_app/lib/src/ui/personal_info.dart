part of mobile_sensing_app;

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DeviceModel> devices = bloc.availableDevices.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    children: [
                      // personal info
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                color: Color(0x353938).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // personal info title
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Text(
                                        'Personal Info',
                                        style: TextStyle(
                                            color: Color(0xFF9DCAED),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // profile photo
                                        // Align(
                                        //   alignment:
                                        //       AlignmentDirectional(0, -0.2),
                                         Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 15, 20, 0),
                                            child: Image.asset(PersonalInfoSurvey._gender.value.toString() =='female'?
                                            'assets/Female.png' : 'assets/Female.png',
                                              width: 100,
                                              height: 135,
                                              fit: BoxFit.cover),

                                          // ),
                                        ),

                                        //personal info list
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                //gender
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 10),
                                                      child: Image.asset(
                                                        'assets/genderIcon.png',
                                                        // width: 40,
                                                        // height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10,
                                                                    10, 10, 10),
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                      0x353938)
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              //                         border: Border.all(
                                                              //                           color: Color(353938).withOpacity(0.5),
                                                              //                           width: 5,
                                                              //                         ),
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                        valueListenable: PersonalInfoSurvey
                                                                            ._gender,
                                                                        builder: (context,
                                                                            String value,
                                                                            child) {
                                                                          return Text(
                                                                              value,
                                                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.center);
                                                                        }))))
                                                  ],
                                                ),
                                                // age
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 10),
                                                      child: Image.asset(
                                                        'assets/ageIcon.png',
                                                        // width: 40,
                                                        // height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(10,
                                                                    10, 10, 10),
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                      0x353938)
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              //                         border: Border.all(
                                                              //                           color: Color(353938).withOpacity(0.5),
                                                              //                           width: 5,
                                                              //                         ),
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                        valueListenable: PersonalInfoSurvey
                                                                            ._age,
                                                                        builder: (context,
                                                                            String value,
                                                                            child) {
                                                                          return Text(
                                                                              value,
                                                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.center);
                                                                        }))))
                                                  ],
                                                ),

                                                //height
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 10),
                                                      child: Image.asset(
                                                        'assets/heightIcon.png',
                                                        // width: 40,
                                                        // height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 10, 10, 10),
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                      0x353938)
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              //                         border: Border.all(
                                                              //                           color: Color(353938).withOpacity(0.5),
                                                              //                           width: 5,
                                                              //                         ),
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                        valueListenable: PersonalInfoSurvey
                                                                            ._height,
                                                                        builder: (context,
                                                                            String value,
                                                                            child) {
                                                                          return Text(
                                                                              value + ' cm',
                                                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.center);
                                                                        }))
                                                        ))
                                                  ],
                                                ),
                                                //weight
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 10, 0, 10),
                                                      child: Image.asset(
                                                        'assets/weightIcon.png',
                                                        // width: 40,
                                                        // height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 10, 10, 10),
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                      0x353938)
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              //                         border: Border.all(
                                                              //                           color: Color(353938).withOpacity(0.5),
                                                              //                           width: 5,
                                                              //                         ),
                                                            ),
                                                            child: Center(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                        valueListenable: PersonalInfoSurvey
                                                                            ._weight,
                                                                        builder: (context,
                                                                            String value,
                                                                            child) {
                                                                          return Text(
                                                                              value + ' kg',
                                                                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.center);
                                                                        }))))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // edit button
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          120, 10, 120, 10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        //constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height * 0.33),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        decoration: BoxDecoration(
                                            color: Color(0xffB4D7A7),
                                            borderRadius: BorderRadius.circular(15),
                                            shape: BoxShape.rectangle),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            ///padding: const EdgeInsets.all(5.0),
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          child: Text("EDIT"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PersonalInfoSurvey()),
                                            );
                                          },
                                        )),
                                      ),
                                    // privacy title
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 10),
                                      child: Text(
                                        'Privacy',
                                        style: TextStyle(
                                            color: Color(0xFF9DCAED),
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    // consent button
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 10, 20),
                                      child: Container(
                                        width: 100,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD36657),
                                          borderRadius: BorderRadius.circular(15),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 15, 0),
                                                child: Image.asset(
                                                  'assets/ticked.png',
                                                    // width: 40,
                                                    // height: 40,
                                                    fit: BoxFit.cover)
                                              ),
                                            ),
                                            Text(
                                              'Consent to share data',
                                                style: TextStyle(
                                                    color: Color(0xFFFAEDCA),
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ]))),

                      // // privacy
                      // Padding(
                      //   padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      //   child: Container(
                      //     clipBehavior: Clip.antiAliasWithSaveLayer,
                      //     decoration: BoxDecoration(
                      //       color: Color(0x353938).withOpacity(0.5),
                      //       borderRadius: BorderRadius.circular(15),
                      //       shape: BoxShape.rectangle,
                      //     ),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.max,
                      //       crossAxisAlignment: CrossAxisAlignment.stretch,
                      //       children: [
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // devices list
                      Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                          // child: Container(
                          //   clipBehavior: Clip.antiAliasWithSaveLayer,
                          //   decoration: BoxDecoration(
                          //     color: Color(0x353938).withOpacity(0.5),
                          //     borderRadius: BorderRadius.circular(15),
                          //     shape: BoxShape.rectangle,
                          //   ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 5, 0, 5),
                                  child: Text(
                                    'Devices',
                                    style: TextStyle(
                                        color: Color(0xFF9DCAED),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                      Expanded(child: _buildAndroidView(devices))
                    ]))));
  }

  Widget _buildAndroidView(List<DeviceModel> devices) {
    // return Scaffold(
    //   key: scaffoldKey,
    //   appBar: AppBar(
    //     title: Text('Devices'),
    //   ),
    return StreamBuilder<UserTask>(
      stream: AppTaskController().userTaskEvents,
      builder: (context, AsyncSnapshot<UserTask> snapshot) {
        return Scrollbar(
          child: ListView.builder(
            itemCount: devices.length,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (context, index) =>
                _buildTaskCard(context, devices[index]),
          ),
        );
      },
    );
    // );
  }

  Widget _buildTaskCard(BuildContext context, DeviceModel device) {
    return Center(child: _buildAndroidCard(device));
  }

  Widget _buildAndroidCard(DeviceModel device) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Color(0x353938).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle,
          ),
          child: StreamBuilder<DeviceStatus>(
            stream: device.deviceEvents,
            initialData: DeviceStatus.unknown,
            builder: (context, AsyncSnapshot<DeviceStatus> snapshot) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: device.icon,
                  title: Text(device.id),
                  subtitle: Text(device.description),
                  trailing: device.stateIcon,
                ),
                const Divider(),
                TextButton(
                    child: const Text('How to use this device?'),
                    onPressed: () => print('Use the $device')),
                (device.status != DeviceStatus.connected)
                    ? Column(children: [
                        const Divider(),
                        TextButton(
                          child: const Text('Connect to this device'),
                          onPressed: () => bloc.connectToDevice(device),
                        ),
                      ])
                    : Text(""),
              ],
            ),
          ),
        ));
  }
}
