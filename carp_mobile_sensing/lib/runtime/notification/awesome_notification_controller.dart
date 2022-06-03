part of runtime;

/// A [NotificationController] based on the [awesome_notifications](https://pub.dev/packages/awesome_notifications)
/// Flutter plugin.

class AwesomeNotificationController implements NotificationController {
  static final AwesomeNotificationController _instance = AwesomeNotificationController._();
  AwesomeNotificationController._() : super();

  /// The singleton [NotificationController].
  factory AwesomeNotificationController() => _instance;

  @override
  void cancelNotification(UserTask task) async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  /// Initialize and set up the notification controller.
  @override
  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      '',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: "Basic Notifications",
            importance: NotificationImportance.High,
            channelShowBadge: true,
            icon: "../android/app/src/main/res/drawable/app_icon.png"),
        NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled Notifications',
            channelDescription: "Scheduled Notifications",
            locked: true,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            icon: "../android/app/src/main/res/drawable/app_icon.png"),
      ],
    );
    info('$runtimeType initialized.');

    await requestPermision();
  }

  @override
  Future<int> get pendingNotificationRequestsCount async =>
      (await AwesomeNotifications().listScheduledNotifications()).length;

  /// Schedule a notification for a [task] at the [task.triggerTime].
  @override
  Future<void> scheduleNotification(UserTask task) async {
    if (task.notification) {
      if (task.triggerTime.isAfter(DateTime.now())) {
        final time = tz.TZDateTime.from(task.triggerTime, tz.getLocation(Settings().timezone));

        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: task.id.hashCode,
                channelKey: 'scheduled_channel',
                title: task.title,
                body: task.description,
                notificationLayout: NotificationLayout.Default),
            schedule: NotificationCalendar.fromDate(date: task.triggerTime, allowWhileIdle: true));
        info('$runtimeType - Notification scheduled for $task at $time');
      }
    } else {
      warning('$runtimeType - Can only schedule a notification in the future. '
          'task trigger time: ${task.triggerTime}.');
    }
  }

  /// Send an immediate notification for a [task].
  @override
  Future<void> sendNotification(UserTask task) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id.hashCode,
        channelKey: 'basic_channel',
        title: task.title,
        body: task.description,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  /// Request permision to send notifications
  Future<void> requestPermision() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
