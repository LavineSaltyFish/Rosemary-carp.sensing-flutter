part of mobile_sensing_app;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  /// This methods is used to set up the entire app, including:
  ///  * initialize the bloc
  ///  * authenticate the user
  ///  * get the invitation
  ///  * get the study
  ///  * initialize sensing
  ///  * start sensing
  Future<bool> init(BuildContext context) async {
    // only initialize the CARP backend bloc, if needed
    if (bloc.deploymentMode != DeploymentMode.LOCAL) {
      await CarpBackend().initialize();
      await CarpBackend().authenticate(context, username: 'jakob@bardram.net');

      // check if there is a local deploymed id
      // if not, get a deployment id based on an invitation
      if (bloc.studyDeploymentId == null) {
        await CarpBackend().getStudyInvitation(context);
      }
    }
    await Sensing().initialize();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (context, snapshot) => (!snapshot.hasData)
          ? Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator()],
              )))
          : CarpMobileSensingApp(key: key),
    );
  }
}

class CarpMobileSensingApp extends StatefulWidget {
  CarpMobileSensingApp({Key? key}) : super(key: key);
  @override
  CarpMobileSensingAppState createState() => CarpMobileSensingAppState();
}

class CarpMobileSensingAppState extends State<CarpMobileSensingApp> {
  int _selectedIndex = 0;

  final _pages = [
    NavigatePage(),
    //StudyDeploymentPage(),
    //ProbesList(),
    // DataVisualization(),
    // DevicesList(),
    //TestPage(),
  ];

  @override
  void dispose() {
    bloc.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
      //     BottomNavigationBarItem(icon: Icon(Icons.adb), label: 'Probes'),
      //     // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Data'),
      //     BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Devices'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: bloc.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }
  static ValueNotifier<double> _speed = ValueNotifier<double>(0.0);
  static ValueNotifier<double> _latitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.latitude);
  static ValueNotifier<double> _longitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.longitude);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void restart() {
    setState(() {
      if (bloc.isRunning) {
        bloc.pause();
      } else {
        bloc.resume();
        Sensing().controller?.data.listen((dataPoint) => _onHeartRateAcquired(dataPoint));
        // Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
        //     .listen((dataPoint) => _onLocationUpdated(dataPoint));
      }
    });
  }
  void _onLocationUpdated(DataPoint data) async {
    var dataDict = data.carpBody;
    _latitude.value = dataDict!["location"] as double;
    _longitude.value = dataDict!["location"] as double;
  }

  void _onHeartRateAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _speed.value = dataDict!["speed"] as double;
    //return dataDict!["speed"] as double;

    //print(_notify.value);
    // !["POLAR_HR"] as double;
    // _notify.value = text;
  }


}
