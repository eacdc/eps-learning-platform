import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/utils/app_colors.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';
import 'package:test_your_learing/views/custom_widgets/secondary_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_your_learing/views/screen/authentication/signup_page.dart'
    show SignupPage;

import '../../../controllers/login_controller.dart';
import '../../../helper/getx_helper.dart';
import '../../custom_widgets/progressbar_widget.dart';
import 'login.dart';

class GateStatrtedScreen extends StatefulWidget {
  const GateStatrtedScreen({Key? key}) : super(key: key);

  @override
  State<GateStatrtedScreen> createState() => _GateStatrtedScreenState();
}

class _GateStatrtedScreenState extends State<GateStatrtedScreen> {
  List<String> scopes = <String>[
    //'https://www.googleapis.com/auth/contacts.readonly',
    'email',
    'profile',
    'openid',
  ];
  //  GoogleSignInAccount? _currentUser;
  //  bool _isAuthorized = false; // has granted permissions?

  final loginController = findOrPut(() => LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor:
            Theme.of(
              context,
            ).colorScheme.surface, // Your desired status bar color
        //statusBarIconBrightness: Brightness.dark, // Icons: light or dark
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
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
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Top Image
                          Container(
                            height: 180,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/signup_cover.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Title
                          Text(
                            Constants.getstarted_title,
                            textAlign: TextAlign.start,

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              Constants.getstarted_desc,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          PrimaryButton(
                            buttonColor: primarycolor,
                            textValue: "Continue With Email",
                            textColor: Colors.white,
                            onPressed: () {
                              Get.to(LoginPage());
                            },
                          ),

                          const SizedBox(height: 16),

                          Material(
                            borderRadius: BorderRadius.circular(32.0),
                            elevation: 0,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                                /*  gradient: LinearGradient(
                      colors: [
                        primarycolor,
                        primarycolor
                      ], // Replace with your gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ), */
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  googleAccountLogin();
                                },
                                borderRadius: BorderRadius.circular(10.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/icon_google.png",
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Continue with Google",
                                        style: heading6.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          /*  Material(
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 0,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black),
                                /*  gradient: LinearGradient(
                      colors: [
                        primarycolor,
                        primarycolor
                      ], // Replace with your gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ), */
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(10.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/icon_facebook.png",
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Continue with Facebook",
                                        style: heading6.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
      
                          const SizedBox(height: 24), */

                          // const Spacer(),

                          // Footer Text
                          InkWell(
                            onTap: () {
                              // showCustomerOnboardBottomsheet(context);
                              Get.to(() => SignupPage());
                            },
                            child: Align(
                              alignment: AlignmentDirectional.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'New to EPS?  ',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                      fontFamily: Constants.fontFamily,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    // style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      /* TextSpan(
                                text: 'bold',
                                style: TextStyle(fontWeight: FontWeight.bold)), */
                                      TextSpan(
                                        text: 'Create Account',
                                        style: TextStyle(
                                          color: primarycolor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ProgressBarWidget(
                  visible: loginController.getStartLoading.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void googleAccountLogin() {
    // _handleSignOut();
    final GoogleSignIn signIn = GoogleSignIn.instance;

    unawaited(
      signIn
          .initialize(
            clientId: Constants.googleLoginClientId,
            serverClientId: Constants.googleLoginServerClientId,
          )
          .then((_) {
            signIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);

            /// This example always uses the stream-based approach to determining
            /// which UI state to show, rather than using the future returned here,
            /// if any, to conditionally skip directly to the signed-in state.
            // signIn.attemptLightweightAuthentication();

            signIn.authenticate(scopeHint: scopes);
          }),
    );
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
    // #enddocregion CheckAuthorization
    switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    print("ggl\n " + (authorization?.accessToken.toString() ?? "__"));
    print("ggl\n " + (user?.authentication.idToken.toString() ?? "__"));
    print("ggl name \n " + (user?.displayName.toString() ?? "__"));
    print("ggl email \n " + (user?.email.toString() ?? "__"));
    print("ggl google id\n " + (user?.id.toString() ?? "__"));

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      //unawaited(_handleGetContact(user));
      print("ggl" + "user sign in");

      final _name = user.displayName.toString() ?? "";
      final _email = user.email.toString() ?? "";
      final _google_id = user.id.toString() ?? "";

      loginController.googleLoginVerify(_name, _email, _google_id, context);
    } else {
      SnackBarHelper.showFailureSnackBar(
        context,
        "unable to fetch google account details",
      );
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    // e is GoogleSignInException ? e.toString() : 'Unknown error: $e';
    print(e.toString());
  }

  Future<void> _handleSignOut() async {
    // Disconnect instead of just signing out, to reset the example state as
    // much as possible.
    await GoogleSignIn.instance.disconnect();
  }
}
