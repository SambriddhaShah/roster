
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rooster_empployee/constants/appColors.dart';


class HeaderWidget extends StatelessWidget {
 

  // Constructor to pass in the title or other custom widgets if necessary
  const HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(top: 5.h),
      height: 15.h,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 15.h,
            color: AppColors.primary,
          ),
          Container(
            height: 15.h,
            width: MediaQuery.of(context).size.width,
            decoration:  BoxDecoration(borderRadius: BorderRadius.only(topLeft:Radius.circular(10.r),topRight:Radius.circular(10.r) ), color: Colors.white),
          )
        ],
      
        ),
       
      );
    
  }
}
