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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 0, 0),
                                child: Text(
                                  'Personal Info',
                                  style: TextStyle(
                                      color: Color(0xFFB4D7A7),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.2),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 15, 20, 0),
                                      child: Image.network(
                                        'https://picsum.photos/seed/534/600',
                                        width: 100,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 15, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 10, 10, 10),
                                                child: Image.network(
                                                  'https://picsum.photos/seed/956/600',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'Hello World',
                                                // style: FlutterFlowTheme
                                                //     .of(context)
                                                //     .bodyText1
                                                //     .override(
                                                //   fontFamily: 'Poppins',
                                                //   fontSize: 18,
                                                // ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 10, 10),
                                                child: Image.network(
                                                  'https://picsum.photos/seed/956/600',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'Hello World',
                                                // style: FlutterFlowTheme
                                                //     .of(context)
                                                //     .bodyText1
                                                //     .override(
                                                //   fontFamily: 'Poppins',
                                                //   fontSize: 18,
                                                // ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 10, 10),
                                                child: Image.network(
                                                  'https://picsum.photos/seed/956/600',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'Hello World',
                                                // style: FlutterFlowTheme
                                                //     .of(context)
                                                //     .bodyText1
                                                //     .override(
                                                //   fontFamily: 'Poppins',
                                                //   fontSize: 18,
                                                // ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 10, 10),
                                                child: Image.network(
                                                  'https://picsum.photos/seed/956/600',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'Hello World',
                                                // style: FlutterFlowTheme
                                                //     .of(context)
                                                //     .bodyText1
                                                //     .override(
                                                //   fontFamily: 'Poppins',
                                                //   fontSize: 18,
                                                // ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 20),
                                child: TextButton(
                                  child:Text("Edit"),
                                  onPressed: () {
                                    // PersonalSurvey().onstart();
                                  },

                                  // options: FFButtonOptions(
                                  //   width: 130,
                                  //   height: 40,
                                  //   color: Color(0xFFB4D7A7),
                                  //   textStyle:
                                  //   FlutterFlowTheme
                                  //       .of(context)
                                  //       .subtitle2
                                  //       .override(
                                  //     fontFamily: 'Poppins',
                                  //     color: Colors.white,
                                  //   ),
                                  //   borderSide: BorderSide(
                                  //     color: Colors.transparent,
                                  //     width: 1,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // privacy
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: Color(0x353938).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 0, 10),
                                child: Text(
                                  'Privacy',
                                  style: TextStyle(
                                      color: Color(0xFFB4D7A7),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
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
                                                  0, 0, 5, 0),
                                          // child: FlutterFlowIconButton(
                                          //   borderColor: Colors.transparent,
                                          //   borderRadius: 30,
                                          //   borderWidth: 1,
                                          //   buttonSize: 60,
                                          //   icon: Icon(
                                          //     Icons.add,
                                          //     color: FlutterFlowTheme
                                          //         .of(context)
                                          //         .primaryText,
                                          //     size: 30,
                                          //   ),
                                          //   onPressed: () {
                                          //     print('IconButton pressed ...');
                                          //   },
                                        ),
                                      ),
                                      Text(
                                        'Consent to share data',
                                        // style: FlutterFlowTheme
                                        //     .of(context)
                                        //     .bodyText1
                                        //     .override(
                                        //   fontFamily: 'Poppins',
                                        //   fontSize: 20,
                                        // ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // devices list
                      Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Color(0x353938).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 15, 0, 10),
                                  child: Text(
                                    'Devices',
                                    style: TextStyle(
                                        color: Color(0xFFB4D7A7),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          )),
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
