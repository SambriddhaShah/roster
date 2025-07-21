

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/presentation/interview_stages.dart';
import 'package:rooster_empployee/screens/dashboard/presentaion/dashboard_page.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;
  bool isHired = false;

  @override
  void initState() {
    getIsLoggedIn();
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (isLoggedIn) {
        if (isHired) {
          Navigator.of(context).pushReplacement(RouteGenerator()
              .generateRoute(const RouteSettings(name: Routes.botomNav)));
        } else {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => InterviewDashboardPage()),
          // );
          Navigator.of(context).pushReplacement(RouteGenerator().generateRoute(
              const RouteSettings(name: Routes.applicantMainPage)));
        }
      } else {
        Navigator.of(context).pushReplacement(RouteGenerator()
            .generateRoute(const RouteSettings(name: Routes.login)));
      }
    });
  }

  void getIsLoggedIn() async {
    var data = await FlutterSecureData.getIsLoggedIn() ?? '';
    var hired = await FlutterSecureData.getIsHired() ?? '';
    print('the isHired value is $hired');
    setState(() {
      isLoggedIn = toBoolean(data);
      isHired = toBoolean(hired);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),

            // App Name
            Text(
              "Roster",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),

            // Loading Indicator
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// Convert a string to a boolean value
bool toBoolean(String string) {
  if (string == 'true') {
    return true;
  } else {
    return false;
  }
}
