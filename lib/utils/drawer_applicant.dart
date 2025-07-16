import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages/models/userModel.dart';
import 'package:rooster_empployee/screens/leave/presentation/leavePage.dart';
import 'package:rooster_empployee/screens/notes/presentation/notePage.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';

class DrawerWidgetApplicant extends StatefulWidget {
  const DrawerWidgetApplicant({super.key});

  @override
  State<DrawerWidgetApplicant> createState() => _DrawerWidgetApplicantState();
}

class _DrawerWidgetApplicantState extends State<DrawerWidgetApplicant> {
  String name = "name";
  String email = "email";
  String? image;
  File? imageFile;

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  void getUserData() async {
    final stringUserData = await FlutterSecureData.getUserData();

    if (stringUserData != null && stringUserData.isNotEmpty) {
      try {
        final decoded = jsonDecode(stringUserData);

        // Extract first object inside `data` array
        // final userJson = (decoded['data']['candidate'] as List).first;

        final userData = CandidateResponse.fromJson(decoded);

        setState(() {
          email = userData.data.candidate.email;
          name = userData.data.candidate.firstName;
          // image = userData['profileImage'];
          // imageFile = File(user['profileImage'] ?? '');
        });
      } catch (e) {
        print('Invalid user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 37.r,
                  backgroundImage: (image == null || image!.isEmpty)
                      ? const AssetImage('assets/defaultprofileimage.png')
                      : FileImage(imageFile!),
                ),

                // const AssetImage('assets/annapurna_trek.jpg'),

                // SizedBox(height: 5.h),
                Text(name, // Replace with the user's name
                    style:
                        AppTextStyles.headline2.copyWith(color: Colors.white)),
                //  SizedBox(height: 5.h),
                Text(email, // Replace with the user's name
                    style:
                        AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              ],
            ),
          ),

          // ListTile(
          //   leading: const Icon(Icons.manage_accounts),
          //   title: Text(
          //     'EDIT PROFILE',
          //     style: Styles.textBlack18,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => ProfileUpdatePage()));
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.car_crash_outlined),
          //   title: Text(
          //     'MY LISTINGS',
          //     style: Styles.textBlack18,
          //   ),
          //   onTap: () {
          //     // Navigate to the dashboard page (same page)
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => UserListingsPage(),
          //     ));
          //   },
          // ),

          ListTile(
            leading: Icon(
              Icons.document_scanner_outlined,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
            title: Text(
              'DOCUMENTS',
              style: AppTextStyles.bodySmall,
            ),
            onTap: () {
              Navigator.of(context).push(
                RouteGenerator().generateRoute(
                  const RouteSettings(name: Routes.uploadDocuments),
                ),
              );
            },
          ),

          // ListTile(
          //   leading: Icon(
          //     Icons.api_outlined,
          //     color: AppColors.textPrimary,
          //     size: 20.sp,
          //   ),
          //   title: Text(
          //     'APPLICANT DETAILS',
          //     style: AppTextStyles.bodySmall,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       RouteGenerator().generateRoute(
          //         const RouteSettings(name: Routes.candidateDashbaord),
          //       ),
          //     );
          //   },
          // ),

          ListTile(
            leading: Icon(
              Icons.logout,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
            title: Text(
              'LOGOUT',
              style: AppTextStyles.bodySmall,
            ),
            onTap: () async {
              // FlutterSecureData.deleteWholeSecureData();
              FlutterSecureData.setIsLoggedIn('false');
              FlutterSecureData.deleteIsHired();
              Navigator.of(context).pushReplacement(
                RouteGenerator().generateRoute(
                  const RouteSettings(name: Routes.login),
                ),
              );
              ToastMessage.showMessage("LogOut Sucessfully");

              // try {
              //   final value = await ApiService(Dio()).logout();
              //   if (value) {
              //     FlutterSecureData.setIsLoggedIn('false');
              //     FlutterSecureData.deleteIsHired();
              //     Navigator.of(context).pushReplacement(
              //       RouteGenerator().generateRoute(
              //         const RouteSettings(name: Routes.login),
              //       ),
              //     );
              //     ToastMessage.showMessage("LogOut Sucessfully");
              //   } else {
              //     ToastMessage.showMessage("LogOut Failed");
              //   }
              // } catch (e) {
              //   ToastMessage.showMessage("LogOut Failed");
              // }
            },
          ),
        ],
      ),
    );
  }
}
