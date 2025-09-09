import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart'
    show
        GoogleSignIn,
        GoogleSignInClientAuthorization,
        GoogleSignInAuthenticationEvent,
        GoogleSignInAccount,
        GoogleSignInAuthenticationEventSignIn,
        GoogleSignInAuthenticationEventSignOut;
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';

import 'package:test_your_learing/controllers/auth_controller.dart';
import 'package:test_your_learing/controllers/login_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';
import 'package:test_your_learing/views/screen/authentication/signup_page.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';
import 'package:test_your_learing/views/screen/authentication/forgotpasswordpage/forgotpassword_page.dart';

import '../../custom_widgets/progressbar_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authController = Get.put(AuthController());
  final loginController = findOrPut(() => LoginController());

  final _formKey5 = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(
    text: '',
  );

  bool passwordVisible = false;
  bool isRememberMe = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  List<String> scopes = <String>[
    //'https://www.googleapis.com/auth/contacts.readonly',
    'email',
    'profile',
    'openid',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          _buildGetOtpForm(context),
          // Obx(() => authController.superAdminLogin.value
          //     ? _buildVerifyOtpForm(context)
          //     : _buildGetOtpForm(context))
        ],
      ),
    );
  }

  Widget _buildGetOtpForm(BuildContext context) {
    return SafeArea(
      child: Obx(()=>Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    InkWell(
                      onTap: () {
                        // Get.to(() => DashboardPage());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          //  color: lightGray.withAlpha(40)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 90,
                          width: 90,
                        ),
                      ),
                    ),
          
                    SizedBox(height: 24),
                    /*  Text("Welcome back to ${Constants.appname}",
                        style: Typo.Medium.copyWith(
                            color: graylight,
                            fontSize: 18,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 32,
                    ), */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Welcome Back!",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
          
                    Text(
                      "Please login first to start your journey!!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          /*  InputField(
                            title: "Email address",
                            hintText: 'Enter your email',
                            suffixIcon: _buildSuffixIcon(),
                            controller: emailController,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: gray,
                              size: 16,
                            ),
                            onChanged: (val) {
                              authController.emailid.value = val;
                            },
                            onSaved: (val) => authController.emailid.value = val!,
                            validator: (val) => (val!.isEmpty || val!.length < 10)
                                ? "Enter valid number"
                                : null,
                          ),
                           */
                          InputField(
                            title: "User Name",
                            hintText: 'Enter your User Name',
                            suffixIcon: _buildSuffixIcon(),
                            controller: emailController,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: graytext,
                              size: 16,
                            ),
                            onChanged: (val) {
                              authController.emailid.value = val;
                            },
                            onSaved: (val) => authController.emailid.value = val!,
                            validator:
                                (val) =>
                                    (val!.isEmpty || val!.length < 10)
                                        ? "Enter valid User Name"
                                        : null,
                          ),
                          SizedBox(height: 16),
                          InputField(
                            title: "Password",
                            hintText: 'Enter your password',
                            controller: passwordController,
                            obscureText: !passwordVisible,
                            suffixIcon: IconButton(
                              color: textGrey,
                              splashRadius: 1,
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: togglePassword,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: graytext,
                              size: 16,
                            ),
                          ),
                          SizedBox(height: 12),
          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isRememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        isRememberMe = value!;
                                      });
                                    },
                                    activeColor: primarycolor,
          
                                    side: BorderSide(),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
          
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: gray),
                                    ),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.onSurface,
                                    ),
                                    //
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => ForgotPasswordPage());
          
                                  //  Get.to(() => SignupPage());
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Forgot Password? ",
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
          
                          SizedBox(height: 16),
                          CustomGradiantButton(
                            loading: loginController.isLoading.value,
                            buttonColor: primarycolor,
                            textValue: 'Sign In',
                            textColor: onprimary,
                            onPressed: () {
                              /*     final form = _formKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  authController.getOtp(context);
                                  authController.showProgressbar.value = true;
                                } */
          
                              final _email = emailController.text;
                              final _password = passwordController.text;
          
                              if (validateCredentials(_email, _password, context)) {
                                /* loginController.loginUser(
                                      _email, _password, context); */
                                loginController.loginUser(
                                  _email,
                                  _password,
                                  context,
                                );
          
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
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
                                        "Login with Google",
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
          
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ),
           ProgressBarWidget(
                  visible:loginController.getStartLoading.value,
                ),
        ],
      ),
    ));
  }

  Widget _buildVerifyOtpForm(BuildContext context) {
    List<TextEditingController> otpFieldsControler = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    authController.isOtpSent.value = false;
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(
                          first: true,
                          last: false,
                          controller: otpFieldsControler[0],
                        ),
                        _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[1],
                        ),
                        _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[2],
                        ),
                        _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[3],
                        ),
                        _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[4],
                        ),
                        _textFieldOTP(
                          first: false,
                          last: true,
                          controller: otpFieldsControler[5],
                        ),
                      ],
                    ),
                    Text(
                      authController.statusMessage.value,
                      style: TextStyle(
                        color: authController.statusMessageColor.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          authController.otp.value = "";
                          otpFieldsControler.forEach((controller) {
                            authController.otp.value += controller.text;
                          });

                          /// authController.verifyOTP(context);
                          authController.showProgressbar.value = true;
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(primarycolor),
                          foregroundColor: WidgetStatePropertyAll<Color>(
                            Colors.white,
                          ),
                          // backgroundColor:
                          //     MaterialStateProperty.all<Color>(kPrimaryColor),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child:
                            authController.showProgressbar.value
                                ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                : Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Text(
                                    'Verify',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Text(
                "Didn't receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18),
              Obx(
                () => TextButton(
                  onPressed:
                      () =>
                          authController.resendOTP.value
                              // ? authController.resendOtp()
                              ? null
                              : null,
                  child: Text(
                    authController.resendOTP.value
                        ? "Resend New Code"
                        : "Wait ${authController.resendAfter} seconds",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primarycolor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return AnimatedOpacity(
      opacity: _isValidEmail(authController.emailid.value) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Icon(Icons.check_circle, color: primarycolor, size: 18),
    );
  }

  /// Function to check if email is valid
  bool _isValidEmail(String email) {
    // return email.length > 3;
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool validateCredentials(
    String email,
    String password,
    BuildContext context,
  ) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    /*   if (email.isEmpty || !emailRegex.hasMatch(email)) {
      SnackBarHelper.showFailureSnackBar(
          context, "Please enter a valid email address");
      return false;
    } */

    if (email.isEmpty || email.trim().length < 2) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter a valid User Name",
      );
      return false;
    }

    if (password.isEmpty || password.length < 2) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter a valid password",
      );

      return false;
    }

    return true;
  }

  Widget _textFieldOTP({bool first = true, last, controller}) {
    var height = (Get.width - 82) / 6;
    return Container(
      height: height,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              Get.focusScope?.nextFocus();
            }
            if (value.length == 0 && first == false) {
              Get.focusScope?.previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: height / 2, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: primarycolor),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
