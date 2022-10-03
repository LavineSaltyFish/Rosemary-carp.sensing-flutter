part of mobile_sensing_app;

class ProbesList extends StatefulWidget {
  const ProbesList({Key? key}) : super(key: key);
  static const String routeName = '/probelist';

  @override
  ProbeListState createState() => ProbeListState();
}

class ProbeListState extends State<ProbesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> probes = ListTile.divideTiles(
        context: context,
        tiles: bloc.runningProbes
            .map<Widget>((probe) => _buildProbeListTile(context, probe)));

    return BuildSettings.buildIOS ? _buildIOSView(probes) : _buildAndroidView(probes);
  }

  Widget _buildAndroidView(Iterable<Widget> probes) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Probes'),
        //TODO - move actions/settings icon to the app level.
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Icons.more_horiz
                  : Icons.more_vert,
            ),
            tooltip: 'Settings',
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: probes.toList(),
        ),
      ),
    );
  }

  Widget _buildIOSView(Iterable<Widget> probes) {
    return CupertinoPageScaffold(
      key: scaffoldKey,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Probes'),
      ),
      child: CupertinoScrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: probes.toList(),
        ),
      ),
    );
  }

  Widget _buildProbeListTile(BuildContext context, ProbeModel probe) {
    return StreamBuilder<ExecutorState>(
      stream: probe.stateEvents,
      initialData: ExecutorState.created,
      builder: (context, AsyncSnapshot<ExecutorState> snapshot) {
        if (snapshot.hasData) {
          return BuildSettings.buildIOS ? _buildIOSTile(probe) : _buildAndroidTile(probe);
        } else if (snapshot.hasError) {
          return Text('Error in probe state - ${snapshot.error}');
        }
        return Text('Unknown');
      },
    );
  }

  Widget _buildAndroidTile(ProbeModel probe) {
    return ListTile(
      isThreeLine: true,
      leading: probe.icon,
      title: Text(probe.name),
      subtitle: Text(probe.description),
//            subtitle: Text(probe.measure.toString()),
      trailing: probe.stateIcon,
    );
  }

  Widget _buildIOSTile(ProbeModel probe) {
    return CupertinoListTile(
      isThreeLine: true,
      leading: probe.icon,
      title: Text(probe.name),
      subtitle: Text(probe.description),
//            subtitle: Text(probe.measure.toString()),
      trailing: probe.stateIcon,
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings not implemented yet...')));
  }
}
