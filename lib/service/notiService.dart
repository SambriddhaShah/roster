import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// for scheduled notifications
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

 

  /// Initialize the notification plugin
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    // Prepare Android initialization settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Prepare iOS initialization settings
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // Initialize the plugin
    await notificationsPlugin.initialize(initSettings);
    notificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();

    // Request iOS-specific permissions
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    _isInitialized = true;
  }

  /// Configure notification details
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', // Unique channel ID
        'Daily Notification', // Channel name
        channelDescription: 'Daily Notification Channel', // Optional description
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Show a notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isInitialized) {
      await initNotifications(); // Ensure initialization
    }

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // Use configured notification details
    );
  }

   /// Show a perodic notification
   /// doesnot work good for durations less than 15 mins so use workmanager for less durations
  Future<void> showPerodicNotification({
    int id = 1,
    String? title,
    String? body,
  }) async {
    print('the perodic notification is called');
    if (!_isInitialized) {
      await initNotifications(); // Ensure initialization
    }
    try{
      return notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails(), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle , 
    );
    }catch(e){
      print('some errors in the perodic notification ${e}');
    }

    
  }

  /// show a scheduled notification for which we need timezone package from pub.dev
   Future<void> showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    int? minute,
  }) async {
    print('the scheduled notification is called ${minute}');
    if (!_isInitialized) {
      await initNotifications(); // Ensure initialization
    }
    tz.initializeTimeZones();
    var localTime= tz.local;
    try{
      return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(localTime).add( Duration(minutes: minute??1)),
      notificationDetails(), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime , 
    );
    }catch(e){
      print('some errors in the scheduled notification ${e}');
    }

    
  }

    // close a specific channel notification
   Future<void> cancel(int id) async {
    await notificationsPlugin.cancel(id);
  }

  // close all the notifications available
   Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
  }

}
