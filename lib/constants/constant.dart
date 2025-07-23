import 'package:flutter/material.dart';

class Constants {
  static const String appname = "Test Your Learning";
  static const String appdesc = "INDIA's Most Loved Learning App Platform";
  static const String copyright =
      "Test Your Learning 2025. All rights reserved.";
  static const String getstarted_title =
      "Let’s explore smart learning with our professional Platform!";
  static const String getstarted_desc =
      "With our smart lessons & quizzes, you will be able to learn from real-world experience";
  //static const String fontFamily = "Gabarito";
  static const String fontFamily = "Manrope";
  // static const String mapAPIKey = "AIzaSyBoqdlyurkVu1bFZPsAklGAGm-gpwsknPo";
  static const String mapAPIKey =
      "AIzaSyCDUsPWYlkZnTH285LoKyFn7SRjwFHvLjo"; // Techo Key

  static const String proxyURL = "https://cors-anywhere.herokuapp.com/";

  // MediaQuery Helpers
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Optionally, you can define % based methods
  static double screenHeightPercentage(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent;

  static double screenWidthPercentage(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent;
}
/* final width = Constants.screenWidth(context);
final height = Constants.screenHeight(context);

final halfWidth = Constants.screenWidthPercentage(context, 0.5);
final eightyPercentHeight = Constants.screenHeightPercentage(context, 0.8); */
