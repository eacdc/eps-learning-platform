import 'package:flutter/material.dart';
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


}

