import 'package:flutter/material.dart';

class Constants {
  static const String appname = "JD Editions Digital Learning";
  static const String appdesc = "La plateforme d’apprentissage la plus appréciée en Inde";
  static const String copyright =
      "JD Editions Digital Learning 2026. Tous droits réservés.";
  static const String getstarted_title =
      "Explorons l’apprentissage intelligent avec notre plateforme professionnelle !";
  static const String getstarted_desc =
      "Avec nos leçons et quiz intelligents, vous pourrez apprendre grâce à des expériences du monde réel";
  //static const String fontFamily = "Gabarito";
  static const String fontFamily = "Manrope";

  /// Publisher code for this build. Sent as the X-Publisher header on every
  /// API request so the backend scopes content/accounts to this publisher.
  /// French build = "JD", English build = "EPS".
  static const String publisher = "JD";


  static const String proxyURL = "https://cors-anywhere.herokuapp.com/";

  /// Fallback Play Store link (used if the backend doesn't return a store URL).
  static const String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.jd.digitallearning";

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
