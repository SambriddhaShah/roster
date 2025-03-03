import 'dart:io';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/screens/dashboard/presentaion/dashboard_page.dart';
import 'package:rooster_empployee/screens/history/presentation/history.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
   DashboardPage(),
   HistoryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      canPop: false,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: CircleNavBar(
      
          activeIcons: [
          //  Image.asset('assets/conatcticon.png',color:AppColors.iconColor, scale: 14.sp,),
           Image.asset('assets/homeicon.png',color:AppColors.surface,scale: 14.sp,),
           Image.asset('assets/history.png',color:AppColors.surface,scale: 14.sp,)
          ],
          inactiveIcons: [
          //  Image.asset('assets/conatcticon.png',color:AppColors.iconDisabledColor,scale: 17.sp,),
           Image.asset('assets/homeicon.png',color:AppColors.textPrimary,scale: 17.sp,),
           Image.asset('assets/history.png',color:AppColors.textPrimary,scale: 17.sp,)
          ],
          color: AppColors.primary,
          circleColor: AppColors.primary,
          height: 60.w,
          circleWidth: 60.w,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
         
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          shadowColor: Colors.black.withOpacity(0.5),
          elevation: 8,
          tabCurve: Curves.easeInOut, 
          activeIndex: _currentIndex,
        ),
      ),
    );
  }
}
