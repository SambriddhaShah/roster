// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationServicee {
//   static Future<Position?> getCurrentLocation() async {
//     try {
//       final status = await Permission.locationWhenInUse.request();

//       if (status.isGranted) {
//         return await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//       } else {
//         print("Location permission denied");
//         // Optionally, you can handle the case when permission is denied
//         // For example, you can show a dialog to the user or redirect them to settings
//       }
//       return null;
//     } catch (e) {
//       print("Error getting current location: $e");
//       return null;
//     }
//   }

//   static double calculateDistance(
//     double startLatitude,
//     double startLongitude,
//     double endLatitude,
//     double endLongitude,
//   ) {
//     return Geolocator.distanceBetween(
//       startLatitude,
//       startLongitude,
//       endLatitude,
//       endLongitude,
//     );
//   }
// }

import 'package:geolocator/geolocator.dart';

class LocationServicee {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Step 1: Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    // Step 2: Check current permission status
    permission = await Geolocator.checkPermission();

    // Step 3: Request permission if not already granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return null;
      }
    }

    // Step 4: Handle permanent denial
    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      await Geolocator.openAppSettings();
      return null;
    }

    // Step 5: Success – get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
