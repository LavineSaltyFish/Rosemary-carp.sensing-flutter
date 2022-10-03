part of mobile_sensing_app;

class App_IOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: LoadingPage_IOS(),
    );
  }
}

class LoadingPage_IOS extends StatelessWidget {
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

      // check if there is a local deployed id
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
          : CarpMobileSensingApp_IOS(key: key),
    );
  }
}

class CarpMobileSensingApp_IOS extends StatefulWidget {
  CarpMobileSensingApp_IOS({Key? key}) : super(key: key);
  @override
  CarpMobileSensingAppState_IOS createState() =>
      CarpMobileSensingAppState_IOS();
}

class CarpMobileSensingAppState_IOS extends State<CarpMobileSensingApp_IOS> {
  int _selectedIndex = 0;

  final _pages = [
    StudyDeploymentPage(),
    ProbesList(),
    // DataVisualization(),
    DevicesList(),
  ];

  @override
  void dispose() {
    bloc.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      // body: _pages[_selectedIndex],
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.adb), label: 'Probes'),
          // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Devices'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _pages[index];
            // return CupertinoPageScaffold(
            //   navigationBar: CupertinoNavigationBar(
            //     middle: Text('Page 1 of tab $index'),
            //   ),
            //   child: Center(
            //     child: CupertinoButton(
            //       child: const Text('Next page'),
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           CupertinoPageRoute<void>(
            //             builder: (BuildContext context) {
            //               return CupertinoPageScaffold(
            //                 navigationBar: CupertinoNavigationBar(
            //                   middle: Text('Page 2 of tab $index'),
            //                 ),
            //                 child: Center(
            //                   child: CupertinoButton(
            //                     child: const Text('Back'),
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     },
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // );
          },
        );
      },
    );
    // floatingActionButton: FloatingActionButton(
    //   onPressed: restart,
    //   tooltip: 'Restart study & probes',
    //   child: bloc.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
    // ),
  }

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
      }
    });
  }
}
