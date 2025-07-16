import 'dart:math';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/material.dart';

class LocationService {
  static const double officeLatitude =
      37.785834; // Replace with your office latitude
  static const double officeLongitude =
      -122.406417; // Replace with your office longitude
  static const double checkRadius = 10.0; // 10 meters radius for check-in

  static Future<void> startLocationTracking() async {
    await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 50.0, // Minimum movement before triggering an event
      stopOnTerminate: false,
      startOnBoot: true,
      debug: false, // Set to true for debugging
      logLevel: bg.Config.LOG_LEVEL_OFF,
      enableHeadless: true, // Ensures tracking even after termination
      foregroundService: true, // Ensures long-running background execution
      heartbeatInterval: 60, // 1 minutes in seconds (60s)
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      checkAttendance(location.coords.latitude, location.coords.longitude);
    });

    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) async {
      bg.Location? location =
          await bg.BackgroundGeolocation.getCurrentPosition();
      if (location != null) {
        checkAttendance(location.coords.latitude, location.coords.longitude);
      }
    });

    print("Location tracking started");
  }

  static Future<void> stopLocationTracking() async {
    await bg.BackgroundGeolocation.stop();
    print("Location tracking stopped");
  }

  static void checkAttendance(double lat, double lon) {
    double distance =
        _calculateDistance(lat, lon, officeLatitude, officeLongitude);

    if (distance <= checkRadius) {
      print("✅ User is inside the office zone.");
    } else {
      print(
          'the office latitude is $officeLatitude and the office longitude is $officeLongitude and the current latitude is $lat and the current longitude is $lon');
      print("❌ User is outside the office zone.");
    }
  }

  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth's radius in meters
    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (3.141592653589793 / 180)) *
            cos(lat2 * (3.141592653589793 / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in meters
  }
}
