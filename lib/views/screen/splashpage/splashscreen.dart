import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/screen/authentication/onboarding/onboarding_screen.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';
import 'package:test_your_learing/views/screen/authentication/getstartedscreen.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final loginstatus = true;

    Future.delayed(Duration(seconds: 2), () {
      navigateUser(context);
    });

    /* Timer(Duration(seconds: 3),
        () => loginstatus ? Get.off(HomePage()) : Get.off(LoginPage())); */
  }

  void navigateUser(BuildContext context) {
    final isFirstTime =
        SharedPreferencesService.getFirstTimeStatus(); // true by default
    final isLoggedIn =
        SharedPreferencesService.getLoginStatus(); // false by default

    if (isFirstTime) {
      //Navigator.pushReplacementNamed(context, '/onboarding');
      Get.off(OnboardingScreen());
    } else if (isLoggedIn) {
      //  Navigator.pushReplacementNamed(context, '/dashboard');
      Get.off(DashboardPage());
    } else {
      // Navigator.pushReplacementNamed(context, '/login');
      //Get.off(LoginPage());
      Get.off(GateStatrtedScreen());

    }

    /*     Get.to()	Pushes a new screen on top of the current one
Get.off()	Replaces the current screen with a new one
Get.offAll()	Clears all previous routes and pushes the new one
Get.offNamed()	Replaces using named route
Get.offAllNamed()	Clears stack and pushes named route */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 100, width: 100),
            SizedBox(height: 24),
            Text(
              Constants.appname,
              style: TextStyle(
                fontSize: 16,
                color: blackcolor,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 24),
            Text(
              Constants.appdesc,
              style: TextStyle(
                fontSize: 16,
                color: blackcolor,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 8),

            Text(
              Constants.copyright,
              style: TextStyle(
                fontSize: 12,
                color: graydark,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* Get.off(() => HomePage())
The HomePage widget is created lazily, meaning it is only instantiated when the navigation actually occurs.

Get.off(HomePage())
The HomePage widget is immediately instantiated when this line of code is executed.

In this case, HomePage is constructed first and then passed to Get.off.
If HomePage contains complex or expensive initialization logic, this might cause unnecessary computation or delays.

Get.off() removes the current screen from the navigation stack and replaces it with the specified page. */