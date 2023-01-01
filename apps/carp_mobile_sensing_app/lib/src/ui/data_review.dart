part of mobile_sensing_app;

class DataReviewPage extends StatefulWidget {
  const DataReviewPage({Key? key}) : super(key: key);

  @override
  _DataReviewPageState createState() => _DataReviewPageState();
}

class _DataReviewPageState extends State<DataReviewPage> {
  //final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // void dispose() {
  //   _unfocusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context),//.requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Text(
                  'TRAVEL DATA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFFF0FFF3),
                      fontSize: 30,
                      fontWeight: FontWeight.w500),

                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0x80353938),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.36,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color:
                          Color(0x353938).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFF0FFF3),
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Image.network(
                                    'https://picsum.photos/seed/738/600',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  'Hello World',
                                  //style: FlutterFlowTheme.of(context).bodyText1,
                                ),
                              ],
                            ),
                            Text(
                              'YOUR AVERAGE SPEED',
                              //style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.36,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color:
                          Color(0x353938).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFF0FFF3),
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Image.network(
                                    'https://picsum.photos/seed/738/600',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  'Hello World',
                                  //style: FlutterFlowTheme.of(context).bodyText1,
                                ),
                              ],
                            ),
                            Text(
                              'YOUR TOTAL DISTANCE',
                              //style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Text(
                  'ALL TRAVELS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFFF0FFF3),
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0x80353938),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
