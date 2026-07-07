import 'package:flutter/material.dart';

class Constants {
  static const String appname = "EPS Digital Learning";
  static const String appdesc = "INDIA's Most Loved Learning App Platform";
  static const String copyright =
      "EPS Digital Learning 2026. All rights reserved.";
  static const String getstarted_title =
      "Let’s explore smart learning with our professional Platform!";
  static const String getstarted_desc =
      "With our smart lessons & quizzes, you will be able to learn from real-world experience";
  //static const String fontFamily = "Gabarito";
  static const String fontFamily = "Manrope";

  /// Publisher code for this build. Sent as the X-Publisher header on every
  /// API request so the backend scopes content/accounts to this publisher.
  /// English build = "EPS", French build = "JD".
  static const String publisher = "EPS";


  static const String proxyURL = "https://cors-anywhere.herokuapp.com/";

  static const String googleLoginClientId = "43576243758-jgmscr24u9849k36ur0s9984s9t8hi80.apps.googleusercontent.com";
  static const String googleLoginServerClientId = "43576243758-mv4cqlgbnjkgpjhthgjand7p71aaea1q.apps.googleusercontent.com";

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
