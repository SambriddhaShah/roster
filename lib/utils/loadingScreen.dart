import 'package:flutter/material.dart';
import 'package:rooster_empployee/constants/appColors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return 
        Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.primary.withOpacity(0.55),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("  Loading...", style: TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
        );
  }
}