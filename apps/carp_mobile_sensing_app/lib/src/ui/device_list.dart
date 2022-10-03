part of mobile_sensing_app;

class DevicesList extends StatefulWidget {
  const DevicesList({Key? key}) : super(key: key);
  static const String routeName = '/deviceslist';

  @override
  DevicesListState createState() => DevicesListState();
}

class DevicesListState extends State<DevicesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<DeviceModel> devices = bloc.availableDevices.toList();

    return BuildSettings.buildIOS
        ? _buildIOSView(devices)
        : _buildAndroidView(devices);
  }

  Widget _buildTaskCard(BuildContext context, DeviceModel device) {
    return Center(
      child: BuildSettings.buildIOS ? _buildAndroidCard(device) : _buildIOSCard(device)
    );
  }

  Widget _buildAndroidView(List<DeviceModel> devices) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: StreamBuilder<UserTask>(
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
      ),
    );
  }

  Widget _buildIOSView(List<DeviceModel> devices) {
    return CupertinoPageScaffold(
      key: scaffoldKey,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Devices'),
      ),
      child: StreamBuilder<UserTask>(
        stream: AppTaskController().userTaskEvents,
        builder: (context, AsyncSnapshot<UserTask> snapshot) {
          return CupertinoScrollbar(
            child: ListView.builder(
              itemCount: devices.length,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) =>
                  _buildTaskCard(context, devices[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAndroidCard(DeviceModel device) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
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
    );
  }

  Widget _buildIOSCard(DeviceModel device) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: StreamBuilder<DeviceStatus>(
        stream: device.deviceEvents,
        initialData: DeviceStatus.unknown,
        builder: (context, AsyncSnapshot<DeviceStatus> snapshot) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoListTile(
              leading: device.icon,
              title: Text(device.id),
              subtitle: Text(device.description),
              trailing: device.stateIcon,
            ),
            // const Divider(),
            CupertinoButton(
                child: const Text('How to use this device?'),
                onPressed: () => print('Use the $device')),
            (device.status != DeviceStatus.connected)
                ? Column(children: [
              // const Divider(),
              CupertinoButton(
                child: const Text('Connect to this device'),
                onPressed: () => bloc.connectToDevice(device),
              ),
            ])
                : Text(""),
          ],
        ),
      ),
    );
  }
}
