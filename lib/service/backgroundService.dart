// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:rooster_empployee/service/flutterSecureData.dart';
// import 'package:rooster_empployee/service/locationService.dart';
// import 'package:workmanager/workmanager.dart';

// const String locationTaskName = "locationValidationTask";

// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) async {
// //     if (task == locationTaskName) {
     
// //       final isCheckedIn = toBoolean(await FlutterSecureData.getisCheckdIn()??"false");
      
// //       if (isCheckedIn) {
// //         await _checkLocationValidity();
// //         print('the location checking is done');
// //       }
// //     }
// //     return Future.value(true);
// //   });
// // }

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print('Background task started'); 
//      WidgetsFlutterBinding.ensureInitialized(); 

//     if (task == locationTaskName) {
//       final isCheckedIn = toBoolean(await FlutterSecureData.getisCheckdIn() ?? "false");
//       print('the user is checkde in ${await FlutterSecureData.getisCheckdIn()}');

//       if (isCheckedIn) {
//         print('User is checked in'); 
//         await _checkLocationValidity();
//         print('Location checking completed');
//       } else {
//         print('User is not checked in');
//       }
//     } else {
//       print('Task name did not match');
//     }
//     return Future.value(true);
//   });
// }


//   Future<void> _checkLocationValidity() async {
//     final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//     if (position != null) {
//       final distance =  Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       position.latitude,
//       position.longitude,
//     );
//           print('the work latitide is ${position!.latitude} and the longitide is ${position!.longitude} and mine latitude is ${position.latitude} and the longitide is ${position.longitude} and the distance is $distance');


//     if(distance <= 10){
//       print('location withinn 10 m');

//     }else{
//       print('location is out of 10m radius');

//     }
//     }else{
//       print('the location is null');
//     }
//   }

// class BackgroundService {
//   static void initialize() {
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//   }

//   static void scheduleLocationValidation() {
//     Workmanager().registerPeriodicTask(
//       locationTaskName,
//       locationTaskName,
//       // initialDelay: const Duration(minutes: 1)
//       frequency: const Duration(minutes: 15),
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//         requiresBatteryNotLow: true,
//       ),
//     );
//   }

//   static void cancelLocationValidation() {
//     Workmanager().cancelByTag(locationTaskName);
//   }
// }
//   // Convert a string to a boolean value
//   bool toBoolean(String string) {
//     if (string == 'true') {
//       return true;
//     } else {
//       return false;
//     }
//   }