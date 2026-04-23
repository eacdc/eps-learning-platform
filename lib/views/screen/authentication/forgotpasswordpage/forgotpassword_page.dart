import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/controllers/forgotpassword_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final forgotPasswordController = Get.put(ForgotPasswordController());

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  // Google sign-in state
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleSubscription;
  bool _handlingGoogleEvent = false;
  bool _googleInitialized = false;
  final List<String> _scopes = ['email', 'profile', 'openid'];

  // Verification state
  bool _googleVerified = false;
  String _verifiedEmail = '';
  String _selectedUsername = '';
  List<String> _availableUsernames = [];
  String _resetAuthToken = '';
  int _tokenSecondsLeft = 0;
  Timer? _countdownTimer;

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
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── Google sign-in ──────────────────────────────────────────────────────────

  void _startGoogleVerification() {
    _googleSubscription?.cancel();
    _handlingGoogleEvent = false;

    _googleSubscription = GoogleSignIn.instance.authenticationEvents
        .listen(_handleAuthenticationEvent)
          ..onError(_handleAuthenticationError);

    GoogleSignIn.instance.authenticate(scopeHint: _scopes);
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
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

    final GoogleSignInClientAuthorization? authorization =
        await user.authorizationClient.authorizationForScopes(_scopes);

    if (!mounted) return;

    if (authorization == null) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Unable to fetch Google account details. Please try again.",
      );
      return;
    }

    final idToken = user.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Unable to verify Google sign-in token. Please try again.",
      );
      return;
    }

    // Call secure Step 1 endpoint
    final result = await forgotPasswordController.googleVerifyForgotPassword(
      idToken,
      context,
    );

    if (!mounted) return;
    _handlingGoogleEvent = false;

    if (result == null) return; // error already shown by controller

    if (result.usernames.isEmpty) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "No account found linked to this Google email (${result.email}).",
      );
      return;
    }

    _resetAuthToken = result.resetAuthToken;
    _verifiedEmail = result.email;
    _availableUsernames = result.usernames;

    if (result.usernames.length == 1) {
      _applyVerifiedAccount(result.usernames.first, result.expiresIn);
    } else {
      await _showUsernamePicker(result.usernames, result.email, result.expiresIn);
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    _handlingGoogleEvent = false;
    if (!mounted) return;
    SnackBarHelper.showFailureSnackBar(
      context,
      "Google sign-in failed. Please try again.",
    );
  }

  void _applyVerifiedAccount(String username, int expiresIn) {
    setState(() {
      _googleVerified = true;
      _selectedUsername = username;
      _tokenSecondsLeft = expiresIn;
    });
    _startCountdown();
  }

  // ── Token expiry countdown ──────────────────────────────────────────────────

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_tokenSecondsLeft > 0) {
          _tokenSecondsLeft--;
        } else {
          t.cancel();
          _resetVerification();
          SnackBarHelper.showFailureSnackBar(
            context,
            "Reset session expired. Please verify with Google again.",
          );
        }
      });
    });
  }

  String get _countdownLabel {
    final m = _tokenSecondsLeft ~/ 60;
    final s = _tokenSecondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── Username picker (multiple accounts) ────────────────────────────────────

  Future<void> _showUsernamePicker(
    List<String> usernames,
    String email,
    int expiresIn,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select account to reset",
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Multiple accounts found for $email. "
                "Choose the one you want to reset the password for.",
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              ...usernames.map(
                (u) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: primarycolor.withAlpha(30),
                    child: Icon(
                      Icons.person_outline,
                      color: primarycolor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    u,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _applyVerifiedAccount(u, expiresIn);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reset verification state ────────────────────────────────────────────────

  void _resetVerification() {
    _countdownTimer?.cancel();
    setState(() {
      _googleVerified = false;
      _verifiedEmail = '';
      _selectedUsername = '';
      _availableUsernames = [];
      _resetAuthToken = '';
      _tokenSecondsLeft = 0;
      passwordController.clear();
      conPasswordController.clear();
    });
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void togglePassword() {
    forgotPasswordController.hidePassword.value =
        !forgotPasswordController.hidePassword.value;
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircularBackButton(onPressed: () => Get.back()),
                  ),
                  const SizedBox(height: 48),

                  // Title
                  Text(
                    "Reset password",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _googleVerified
                        ? "Google verified. Enter and confirm your new password."
                        : "First verify your identity with Google to continue.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Step 1: Verify with Google ──
                  if (!_googleVerified)
                    Material(
                      borderRadius: BorderRadius.circular(32),
                      elevation: 0,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: InkWell(
                          onTap: forgotPasswordController.isLoading.value
                              ? null
                              : _startGoogleVerification,
                          borderRadius: BorderRadius.circular(32),
                          child: forgotPasswordController.isLoading.value
                              ? const Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/icon_google.png",
                                        height: 22,
                                        width: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Verify with Google",
                                        style: heading6.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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

                  // ── Step 2: Password form (only after verification) ──
                  if (_googleVerified) ...[

                    // Verified badge + countdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _verifiedEmail,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Session expires in $_countdownLabel",
                                  style: TextStyle(
                                    color: _tokenSecondsLeft < 60
                                        ? Colors.red
                                        : Colors.green.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _resetVerification,
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Username (locked, from Google verification)
                    InputField(
                      title: "Username",
                      hintText: _selectedUsername,
                      readOnly: true,
                      suffixIcon: const Icon(
                        Icons.lock_rounded,
                        size: 16,
                        color: Colors.green,
                      ),
                      controller:
                          TextEditingController(text: _selectedUsername),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: graytext,
                        size: 16,
                      ),
                    ),

                    // Show "switch account" if multiple usernames are linked
                    if (_availableUsernames.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showUsernamePicker(
                            _availableUsernames,
                            _verifiedEmail,
                            _tokenSecondsLeft,
                          ),
                          child: Text(
                            "Switch account",
                            style: TextStyle(
                              color: primarycolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 16),

                    InputField(
                      title: "New Password",
                      hintText: "Create a new password (min 8 characters)",
                      controller: passwordController,
                      obscureText: forgotPasswordController.hidePassword.value,
                      suffixIcon: IconButton(
                        color: textGrey,
                        splashRadius: 1,
                        icon: Icon(
                          forgotPasswordController.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: togglePassword,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: graytext,
                        size: 16,
                      ),
                    ),

                    const SizedBox(height: 16),

                    InputField(
                      title: "Confirm Password",
                      hintText: "Confirm your new password",
                      controller: conPasswordController,
                      obscureText: forgotPasswordController.hidePassword.value,
                      suffixIcon: IconButton(
                        color: textGrey,
                        splashRadius: 1,
                        icon: Icon(
                          forgotPasswordController.hidePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: togglePassword,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: graytext,
                        size: 16,
                      ),
                    ),

                    const SizedBox(height: 28),

                    CustomGradiantButton(
                      buttonColor: primarycolor,
                      textValue: "Reset Password",
                      textColor: onprimary,
                      loading: forgotPasswordController.isLoading.value,
                      onPressed: () {
                        final password = passwordController.text;
                        final confirmPassword = conPasswordController.text;

                        if (_tokenSecondsLeft <= 0) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Reset session expired. Please verify with Google again.",
                          );
                          _resetVerification();
                          return;
                        }
                        if (password.length < 8) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Password must be at least 8 characters",
                          );
                          return;
                        }
                        if (password != confirmPassword) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Password and Confirm Password do not match",
                          );
                          return;
                        }

                        forgotPasswordController.completeForgotPasswordReset(
                          _resetAuthToken,
                          _selectedUsername,
                          password,
                          context,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
