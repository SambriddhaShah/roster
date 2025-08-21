import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:rooster_empployee/constants/appTheme.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/splashScreen/splashScreen.dart';
// import 'package:rooster_empployee/service/backgroundService.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:rooster_empployee/service/geoLocation_service.dart' as service;
import 'package:rooster_empployee/service/notiService.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:rooster_empployee/service/flutterSecureData.dart';
// import 'package:rooster_empployee/service/locationService.dart';
// import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent event) async {
  if (event.name == bg.Event.HEARTBEAT) {
    bg.Location? location = await bg.BackgroundGeolocation.getCurrentPosition();
    if (location != null) {
      service.LocationService.checkAttendance(
          location.coords.latitude, location.coords.longitude);
    }
  }
}

Future<void> _initializeGeolocation() async {
  await bg.BackgroundGeolocation.ready(bg.Config(
    desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    distanceFilter: 50.0,
    stopOnTerminate: false,
    startOnBoot: true,
    debug: true, // Set to false in production
    logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    locationAuthorizationRequest: 'Always', // Important for iOS
    showsBackgroundLocationIndicator: true, // Optional, for iOS
  ));

  // Start background tracking — this is what triggers "Always" prompt on iOS
  bg.BackgroundGeolocation.start();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   NotiService().initNotifications();
//   await Permission.notification.isDenied.then((value) {
//     if (value) {
//       Permission.notification.request();
//     }
//   });
//   bg.BackgroundGeolocation.registerHeadlessTask(
//       backgroundGeolocationHeadlessTask);
//   // Workmanager().initialize(callbackDispatcher);
//   // BackgroundService.initialize();
//   _requestLocationPermission();
//   // Initialize WorkManager
//   Workmanager().initialize(callbackDispatcher);

//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotiService().initNotifications();
  await _requestLocationPermission(); // First request permissions
  await _initializeGeolocation(); // Then start background tracking

  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);

  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('the task came in the workmanager');

    if (task == 'delayedNotification') {
      // NotiService().showNotification(title: 'Offline notification', body: 'Offline notification sent');
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
      await flutterLocalNotificationsPlugin.initialize(initSettings);

      // Request iOS-specific permissions
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      /// Configure notification details
      NotificationDetails notificationDetails() {
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id', // Unique channel ID
            'Daily Notification', // Channel name
            channelDescription:
                'Daily Notification Channel', // Optional description
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        );
      }

      flutterLocalNotificationsPlugin.show(
        1,
        'Checkout Please!',
        'Your work is completed for today.',
        notificationDetails(), // Use configured notification details
      );
    }
    return Future.value(true);
  });
}

// Future<void> _requestLocationPermission() async {
//   // Check if permission is already granted
//   var status = await Permission.location.status;
//   if (!status.isGranted) {
//     // Request permission if not granted
//     await Permission.location.request();
//   }

//   // Check if permission is still denied
//   if (await Permission.location.isDenied) {
//     // Handle the case when the user denies permission
//     print("Location permission denied");
//   } else if (await Permission.location.isPermanentlyDenied) {
//     // If the user has permanently denied the permission
//     openAppSettings; // Optionally, open app settings to allow the user to change the permission
//   }
// }

// Future<void> _requestLocationPermission() async {
//   // Check if location permission is granted
//   var status = await Permission.location.status;

//   if (!status.isGranted) {
//     // Request 'while using the app' location permission
//     await Permission.location.request();
//   }

//   // Check if the permission is denied
//   if (await Permission.location.isDenied) {
//     print("Location permission denied");
//   }
//   // Check if the permission is permanently denied
//   else if (await Permission.location.isPermanentlyDenied) {
//     // If the user has permanently denied the permission, open app settings
//     openAppSettings();
//   }

//   // Request always location permission (important for background usage)
//   if (await Permission.locationAlways.status.isDenied) {
//     // If always permission is denied, request it
//     await Permission.locationAlways.request();
//   }

//   // Handle the case if the user denies the 'always' permission
//   if (await Permission.locationAlways.isDenied) {
//     print("Always location permission denied");
//   } else if (await Permission.locationAlways.isPermanentlyDenied) {
//     openAppSettings(); // Open settings to let user enable always location
//   }

//   // Once granted, you can proceed with your location-related logic
// }

Future<void> _requestLocationPermission() async {
  // Step 1: Request foreground location permission
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }

  // Step 2: Handle permanently denied permission
  if (await Permission.location.isPermanentlyDenied) {
    await openAppSettings();
    return; // No need to proceed
  }

  // Step 3: For Android only, request background permission
  if (Platform.isAndroid) {
    if (await Permission.locationAlways.isDenied) {
      await Permission.locationAlways.request();
    }

    if (await Permission.locationAlways.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Step 4: For iOS — DO NOT request locationAlways here.
  // It will be triggered automatically by `flutter_background_geolocation.start()`
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Appointment Scheduler',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          
          initialRoute: Routes.SplashScreen,
          onGenerateRoute: RouteGenerator().generateRoute,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
      child: const SplashScreen(),
    );
  }
}
