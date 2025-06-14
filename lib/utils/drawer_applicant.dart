import 'dart:convert';
import 'dart:io';
import 'package:rooster_empployee/constants/appColors.dart';
import 'package:rooster_empployee/constants/appTextStyles.dart';
import 'package:rooster_empployee/routes/route_generator.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/screens/leave/presentation/leavePage.dart';
import 'package:rooster_empployee/screens/notes/presentation/notePage.dart';
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
    var data = await FlutterSecureData.getUserName() ?? 'name';

    var userData = await FlutterSecureData.getUserData();
    var user = jsonDecode(userData ?? '');
    print('the user data is $user');
    print('the image is ${user['profileImage']}');

    setState(() {
      email = user['email'];
      name = user['firstName'];
      image = user['profileImage'];
      imageFile = File(user['profileImage'] ?? '');
    });
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
            onTap: () {
              // FlutterSecureData.deleteWholeSecureData();
              FlutterSecureData.setIsLoggedIn('false');
              FlutterSecureData.deleteIsHired();
              Navigator.of(context).pushReplacement(
                RouteGenerator().generateRoute(
                  const RouteSettings(name: Routes.login),
                ),
              );
              ToastMessage.showMessage("LogOut Sucessfully");
            },
          ),
        ],
      ),
    );
  }
}
