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
    LocationManager().initialize();

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
    PersonalInfoPage(),
    DataReviewPage()
    //PersonalInfoSurvey()
    //SimpleMarkerAnimationExample()
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
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.adb), label: 'Probes'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Data'),
          //BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Devices'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: bloc.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }
  static ValueNotifier<double> _speed = ValueNotifier<double>(0.0);
  static ValueNotifier<Duration> _time = ValueNotifier<Duration>(Duration(hours:0,minutes:0,seconds:0));
  static ValueNotifier<double> _gyro = ValueNotifier<double>(0.0);
  static ValueNotifier<int> _heartRate = ValueNotifier<int>(0);
  //static ValueNotifier<double> _heartRate = ValueNotifier<double>(0.0);

  static ValueNotifier<String> _weather = ValueNotifier<String>("-");
  static ValueNotifier<double> _windSpeed = ValueNotifier<double>(0.0);

  static ValueNotifier<double> _latitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.latitude);
  static ValueNotifier<double> _longitude = ValueNotifier<double>(_NavigatePageState._kGooglePlex.target.longitude);

  bool isTimerOn = false;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //Sensing().controller?.data.listen((dataPoint) => _onMapRebuild(dataPoint));
    });
  }


  

  void restart() {
    setState(() {
      if (bloc.isRunning) {
        bloc.pause();
        //_time.value = Duration(seconds: 0);
        isTimerOn = false;

      } else {

        bloc.resume();
        isTimerOn = true;

        DateTime startTime = DateTime.now();
        Timer.periodic(new Duration(seconds: 1), (timer) {
            if (!isTimerOn){
              timer.cancel();
            }
            else{
              _time.value = _onTimerUpdated(startTime);
            }
        });

        //Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == SensorSamplingPackage.ACCELEROMETER).
        Sensing().controller?.data
        //.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
        .listen((dataPoint) => _onMoveAcquired(dataPoint));

        Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == PolarSamplingPackage.POLAR_HR)
            .listen((dataPoint) => _onHeartRateAcquired(dataPoint));

        Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.WEATHER)
            .listen((dataPoint) => _onWeatherAcquired(dataPoint));





        // Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == SensorSamplingPackage.GYROSCOPE)
        //     .listen((dataPoint) => _onGyroAcquired(dataPoint));
        // Sensing().controller?.data.where((dataPoint) => dataPoint.data!.format.toString() == ContextSamplingPackage.LOCATION)
        //     .listen((dataPoint) => _onLocationUpdated(dataPoint));


      }
    });
  }

  // void onData(DataPoint dataPoint) {
  //   _onSpeedAcquired(dataPoint);
  // }

  //
  // Future<CameraPosition> _onMapRebuild(DataPoint data) async {
  //   var dataDict = data.carpBody;
  //   CameraPosition _kGooglePlex = CameraPosition(
  //          target: LatLng(dataDict!["latitude"] as double, dataDict!["longitude"] as double),
  //          zoom: 14.4746,
  //          );
  //   return _kGooglePlex;
  // }
  //

  void _onMoveAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _speed.value = dataDict!["speed"]*3.6 as double;

    //_time.value = dataDict!["distance_travelled"] as double;

  }

  void _onWeatherAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _weather.value = dataDict!["weather_main"] as String;
    _windSpeed.value = dataDict!["wind_speed"] as double;
  }

  void _onHeartRateAcquired(DataPoint data) async {
    var dataDict = data.carpBody;
    _heartRate.value = dataDict!["hr"] as int;


  }

  Duration _onTimerUpdated(DateTime startTime) {
    return DateTime.now().difference(startTime);
  }

}
