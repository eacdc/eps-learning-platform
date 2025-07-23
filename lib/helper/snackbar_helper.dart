import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';

class SnackBarHelper {
  /// Show success SnackBar
  static void showSuccessSnackBar(BuildContext context, String content) {
    _showSnackBar(context, content, Colors.green);
  }

  /// Show failure SnackBar
  static void showFailureSnackBar(BuildContext context, String content) {
    _showSnackBar(context, content, Colors.redAccent);
  }

   /// Show failure SnackBar
  static void showNormalSnackBar(BuildContext context, String content) {
    _showSnackBar(context, content, primarycolor);
  }

  /// Private method to display SnackBar
  static void _showSnackBar(
      BuildContext context, String content, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        margin: EdgeInsets.only(left: 12,right: 12,bottom: 50 ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        closeIconColor: Colors.white,
        content: Text(
          content,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.normal,fontSize: 15),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }







   /// Show success SnackBar using GetX
  static void showSuccessSnackBarGetx(String message) {
    _showSnackBarGetx(message, Colors.green, "Success");
  }

  /// Show failure SnackBar using GetX
  static void showFailureSnackBarGetx(String message) {
    _showSnackBarGetx(message, Colors.redAccent, "Error");
  }
  


  /// Private method to display GetX SnackBar
  static void _showSnackBarGetx(String message, Color color, String title) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      icon: Icon(
        title == "Success" ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }



}

