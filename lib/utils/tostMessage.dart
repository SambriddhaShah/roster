
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rooster_empployee/constants/appColors.dart';

// Define a class for displaying toast messages
class ToastMessage {
  // Static method to show a toast message
  static showMessage(String message) {
    Fluttertoast.showToast(
        backgroundColor: AppColors.primary,
        msg: message,
        textColor: AppColors.textPrimary,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 15);
  }

  
}