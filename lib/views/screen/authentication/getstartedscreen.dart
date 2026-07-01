import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/login_model/google_accounts_response.dart';
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
    'email',
    'profile',
    'openid',
  ];

  final loginController = findOrPut(() => LoginController());
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleSubscription;
  bool _googleInitialized = false;
  bool _handlingGoogleEvent = false;

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
  }

  void _initGoogleSignIn() {
    if (_googleInitialized) return;
    _googleInitialized = true;
    GoogleSignIn.instance
        .initialize(
          clientId: Constants.googleLoginClientId,
          serverClientId: Constants.googleLoginServerClientId,
        )
        .catchError((_) {});
  }

  @override
  void dispose() {
    _googleSubscription?.cancel();
    super.dispose();
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
                                        "Continuer avec Google",
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
                          Text(
                            "Inscrivez-vous ou connectez-vous avec Google pour continuer",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                              fontFamily: Constants.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
    // Cancel any previous subscription before attaching a new one.
    _googleSubscription?.cancel();
    _handlingGoogleEvent = false;

    _googleSubscription = GoogleSignIn.instance.authenticationEvents
        .listen(_handleAuthenticationEvent)
          ..onError(_handleAuthenticationError);

    GoogleSignIn.instance.authenticate(scopeHint: scopes);
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // Guard: set immediately to block any duplicate events firing in parallel.
    if (_handlingGoogleEvent) return;
    _handlingGoogleEvent = true;
    _googleSubscription?.cancel();
    _googleSubscription = null;

    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user == null) {
      _handlingGoogleEvent = false;
      return;
    }

    final GoogleSignInClientAuthorization? authorization = await user
        .authorizationClient
        .authorizationForScopes(scopes);

    if (!mounted) return;

    if (authorization == null) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Impossible de récupérer les détails du compte Google. Veuillez réessayer.",
      );
      return;
    }

    final googleToken = user.authentication.idToken;
    if (googleToken == null || googleToken.isEmpty) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Impossible de vérifier le jeton Google. Veuillez réessayer.",
      );
      return;
    }

    final response = await loginController.fetchAccountsByGoogleToken(
      googleToken,
      context,
    );

    if (!mounted) return;
    _handlingGoogleEvent = false;

    if (response.statusCode != 200) {
      SnackBarHelper.showFailureSnackBar(
        context,
        response.data["message"] ?? "Impossible de continuer avec Google",
      );
      return;
    }

    final accounts = GoogleAccountsResponse.fromJson(response.data);
    if (accounts.users.isEmpty) {
      Get.to(
        () => SignupPage(),
        arguments: {"googleToken": googleToken, "googleEmail": accounts.email},
      );
    } else {
      Get.to(() => LoginPage());
      SnackBarHelper.showSuccessSnackBar(
        context,
        "Compte Google trouvé. Sélectionnez votre nom d'utilisateur et entrez le mot de passe pour vous connecter.",
      );
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    _handlingGoogleEvent = false;
    SnackBarHelper.showFailureSnackBar(
      context,
      "La connexion Google a échoué. Veuillez réessayer.",
    );
  }
}
