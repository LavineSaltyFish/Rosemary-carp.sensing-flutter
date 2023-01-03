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
          onTap: () => FocusScope.of(context).requestFocus(),
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
                      color: Color(0xFF9DCAED),
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
              ),

              // total time
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Stack(
                    alignment: AlignmentDirectional(0, 0),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Color(0x353938).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Image.asset(
                          "assets/Subtract.png",
                          // width: 100,
                          // height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Center(
                              child: Column(children: [
                                Text('Your total cycling time'),
                                ValueListenableBuilder(
                                  valueListenable:
                                    CarpMobileSensingAppState._totalTime,
                                  builder: (context, Duration value, child) {
                                    return Text(
                                      value
                                          .toString()
                                          .split('.')
                                          .first
                                          .padLeft(8, "0"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center);
                                })
                          ]))),
                    ],
                  )),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 10),
                child: Container(
                  //width: 10,
                  child: Stack(
                    alignment: AlignmentDirectional(0, 0),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Color(0x353938).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Image.asset(
                          'assets/Subtract.png',
                          // width: 100,
                          // height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Column(
                            children:[
                            Text('Your total cycling distance:'),
                            ValueListenableBuilder(
                              valueListenable:
                              CarpMobileSensingAppState._totalDistance,
                              builder: (context, double value, child) {
                                return Text(value.toString()+'km',
                                    //.split('.').first.padLeft(8, "0"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center);
                              }),
                    ],
                  ),
                ),
                    ]
                )
                )
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Text(
                  'review all data...',
                  style: TextStyle(
                      color: Color(0xFF9DCAED),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
