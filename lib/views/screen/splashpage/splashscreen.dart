import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/homechat_test.dart';
import 'package:test_your_learing/views/screen/authentication/onboarding/onboarding_screen.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';
import 'package:test_your_learing/views/screen/authentication/getstartedscreen.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _textController;

  late Animation<double> _dropAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Color?> _textColorAnimation;

  bool _expandComplete = false;

  @override
  void initState() {
    super.initState();

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _circleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _dropAnimation = Tween<double>(begin: -250, end: 0).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 11.0).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Interval(0.5, 1.0, curve: Curves.easeOutCirc),
      ),
    );

    _textScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    /*   _textColorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.onSurface,
      end: Theme.of(context).colorScheme.onSurface,
    ).animate(_textController); */

    //Future.delayed(Duration(milliseconds: 2000), () => _textController.forward());

    _circleController.forward().then((_) {
      setState(() => _expandComplete = true);
      // _textController.forward();
      Future.delayed(Duration(seconds: 1), () => navigateUser(context));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _textColorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.surface,
      end: Theme.of(context).colorScheme.surface,
    ).animate(_textController);

    /*   Theme.of(context) (and similar things like MediaQuery.of(context)) depends on the widget tree.
At the time initState() runs, your widget is not yet fully inserted into the tree, so the inherited widget (Theme) can’t be accessed.
That’s why Flutter tells you to use build() or didChangeDependencies() instead.*/
  }

  @override
  void dispose() {
    _circleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void navigateUser(BuildContext context) {
    final isFirstTime =
        SharedPreferencesService.getFirstTimeStatus(); // true by default
    final isLoggedIn =
        SharedPreferencesService.getLoginStatus(); // false by default

    if (isFirstTime) {
      Get.offNamed('/onboard');
    } else if (isLoggedIn) {
      Get.offNamed('/dashboard');
    } else {
      Get.offNamed('/getStarted');
    }
  }

  Widget _buildAnimatedText(String text, TextStyle style) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.scale(
          scale: _textScaleAnimation.value,
          child: Text(
            text,
            style: style.copyWith(color: _textColorAnimation.value),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor:
            false
                ? whitecolor
                : Color(0xff6DC2C6), // Your desired status bar color
        statusBarIconBrightness: Brightness.dark, // Icons: light or dark
        statusBarBrightness: Brightness.light, // iOS
        // Bottom navigation bar
        systemNavigationBarColor:
            Theme.of(context).colorScheme.surface, // Background
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark, // Icons
        systemNavigationBarDividerColor:
            Theme.of(
              context,
            ).colorScheme.surface, // Optional, removes divider line
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AnimatedBuilder(
                    animation: _circleController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _dropAnimation.value),
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.blueAccent,
                                gradient: homeGradient,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 95,
                      width: 95,
                    ),
                  ),
                ],
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8),

                    /* // Image.asset('assets/images/logo.png', height: 95, width: 95),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _textScaleAnimation.value,
                          child: Text(
                            'Your App Name',
                            style: TextStyle(
                              fontSize: 20,
                              color: _textColorAnimation.value,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
          
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
                    ), */
                    _buildAnimatedText(
                      Constants.appname,
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedText(
                      Constants.appdesc,
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAnimatedText(
                      Constants.copyright,
                      const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 
 
 
 
 
 
/*  You can lower the target radius from 2000 to maybe 1200–1500 depending on the screen size.

If needed, you can make it responsive using MediaQuery.of(context).size.longestSide * 1.5. */
 
 
 /*     Get.to()	Pushes a new screen on top of the current one
Get.off()	Replaces the current screen with a new one
Get.offAll()	Clears all previous routes and pushes the new one
Get.offNamed()	Replaces using named route
Get.offAllNamed()	Clears stack and pushes named route */


/* Get.off(() => HomePage())
The HomePage widget is created lazily, meaning it is only instantiated when the navigation actually occurs.

Get.off(HomePage())
The HomePage widget is immediately instantiated when this line of code is executed.

In this case, HomePage is constructed first and then passed to Get.off.
If HomePage contains complex or expensive initialization logic, this might cause unnecessary computation or delays.

Get.off() removes the current screen from the navigation stack and replaces it with the specified page. */



/* 
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final loginstatus = true;

    /* Future.delayed(Duration(seconds: 2000), () {
      navigateUser(context);
    }); */

    /* Timer(Duration(seconds: 3),
        () => loginstatus ? Get.off(HomePage()) : Get.off(LoginPage())); */

   /*  _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut)); */

    _controller = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  _controller.forward().then((_) {
    navigateUser(context);
  });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      //Get.off(DashboardPage());
      // Get.off(HomeChatPage());
      Get.off(VoiceChatPage());
    } else {
      // Navigator.pushReplacementNamed(context, '/login');
      //Get.off(LoginPage());
      Get.off(GateStatrtedScreen());
    }

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.maxFinite,
        child: FadeTransition(
                  opacity: _animation,

          child: ScaleTransition(
                      scale: _animation,

            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* AnimatedBuilder(
                  animation: _animation,
                  builder:
                      (context, child) => Container(
                        height: 100,
                        width: 100,
                        transform: Matrix4.translationValues(
                          0,
                          -_animation.value * 100,
                          0,
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                ), */
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
        ),
      ),
    );
  }
} */
