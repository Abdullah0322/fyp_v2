import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotifications>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotifications>();
  NotificationPlugin._() {
    init();
  }
  var initializationSettings;
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
  }

  setListenerforlowerVersions(Function onNotificationinLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotifications) {
      onNotificationinLowerVersions(receivedNotifications);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotifications {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotifications({this.id, this.title, this.body, this.payload});
}
