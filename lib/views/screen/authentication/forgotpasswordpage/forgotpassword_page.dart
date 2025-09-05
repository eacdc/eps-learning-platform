import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/forgotpassword_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';

import '../../../custom_widgets/circular_back_button.dart';
import '../../../custom_widgets/dotted_line.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final forgotPasswordController = Get.put(ForgotPasswordController());

  final _formKey3 = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController(text: '');

  final TextEditingController passwordController = TextEditingController(
    text: '',
  );
  final TextEditingController conPasswordController = TextEditingController(
    text: '',
  );

  List<TextEditingController> otpFieldsControler = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void togglePassword() {
    forgotPasswordController.hidePassword.value =
        !forgotPasswordController.hidePassword.value;
  }

  /*   void setOtpToControllers(String otpValue) {
    for (int i = 0; i < otpFieldsControler.length; i++) {
      otpFieldsControler[i].text = otpValue.length > i ? otpValue[i] : "";
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // _buildEmailForm(context)
          Obx(
            () =>
                forgotPasswordController.isOtpSent.value
                    ? _buildVerifyOtpForm(context)
                    : _buildEmailForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey3,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircularBackButton(
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(height: 100),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                /*  Text("Welcome back to ${Constants.appname}",
                      style: Typo.Medium.copyWith(
                          color: graylight,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 32,
                  ), */
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Don’t worry! It happens. Please enter the email associated with your account.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      InputField(
                        title: "Email address",
                        hintText: 'Enter your email address',
                        suffixIcon: _buildSuffixIcon(),
                        controller: emailController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: gray,
                          size: 16,
                        ),
                        onChanged: (val) {
                          forgotPasswordController.emailid.value = val;
                        },
                        onSaved:
                            (val) =>
                                forgotPasswordController.emailid.value = val!,
                        validator:
                            (val) =>
                                (val!.isEmpty || val!.length < 10)
                                    ? "Enter valid number"
                                    : null,
                      ),
                      SizedBox(height: 24),
                      CustomGradiantButton(
                        buttonColor: primarycolor,
                        textValue: 'Send code',
                        textColor: onprimary,
                        loading: forgotPasswordController.isLoading.value,
                        onPressed: () {
                          final RegExp emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (forgotPasswordController.emailid.value.isEmpty ||
                              !emailRegex.hasMatch(
                                forgotPasswordController.emailid.value,
                              )) {
                            SnackBarHelper.showFailureSnackBar(
                              context,
                              "Please enter a valid email address",
                            );
                          } else {
                            forgotPasswordController.sendFPOTP(
                              forgotPasswordController.emailid.value,
                              context,
                            );

                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyOtpForm(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: CircularBackButton(
                  onPressed: () {
                    forgotPasswordController.isOtpSent.value = false;
                    Get.back();
                  },
                ),
              ),

              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Verification Code",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sent To ${emailController.text}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    /*   Text(
                      forgotPasswordController.statusMessage.value,
                      style: TextStyle(
                          color:
                              forgotPasswordController.statusMessageColor.value,
                          fontWeight: FontWeight.bold),
                    ), */
                    SizedBox(height: 24),
                    Divider(color: Theme.of(context).dividerColor, height: 1),
                    SizedBox(height: 24),

                    /*   CustomPaint(
                      painter: DottedLinePainter(),
                      child: Container(
                        height:
                            1.0, // Or whatever height is appropriate for your line
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 32), */
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create New Password",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    InputField(
                      title: "Password",
                      hintText: 'Create a strong password',
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
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: graytext,
                        size: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "At least 8 characters with a combination of letters and numbers",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    InputField(
                      title: "Confirm Password",
                      hintText: 'Confirm your password',
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
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: graytext,
                        size: 16,
                      ),
                    ),

                    SizedBox(height: 32),

                    CustomGradiantButton(
                      loading: forgotPasswordController.isLoading.value,
                      buttonColor: primarycolor,
                      textValue: 'Verify OTP & Reset Password',
                      textColor: onprimary,
                      onPressed: () {
                        /*     final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                authController.getOtp(context);
                                authController.showProgressbar.value = true;
                              } */

                        forgotPasswordController.otp.value = "";
                        otpFieldsControler.forEach((controller) {
                          forgotPasswordController.otp.value += controller.text;
                        });

                        final String _password = passwordController.text;
                        final String _confirmPassword =
                            conPasswordController.text;

                        if (forgotPasswordController.otp.value.length != 6) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Please Enter 6 Digit OTP Sent To Your Email",
                          );
                        } else if (_password.isEmpty ||
                            !_isValidPassword(_password)) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Please enter a valid Password ",
                          );
                        } else if (_confirmPassword.isEmpty ||
                            _password != _confirmPassword) {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Password and Confirm Password do not match",
                          );
                        } else {
                          forgotPasswordController.verifyOTPResetPassword(
                            emailController.text,
                            forgotPasswordController.otp.value,
                            passwordController.text,
                            context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              /* SizedBox(
                height: 18,
              ),
              Text(
                "Didn't receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ), */
              SizedBox(height: 16),
              Obx(
                () => TextButton(
                  onPressed:
                      () =>
                          forgotPasswordController.resendOTP.value
                              ? forgotPasswordController.resendOtp(
                                emailController.text,
                                context,
                              )
                              // ? null
                              : null,
                  child: Text(
                    forgotPasswordController.resendOTP.value
                        ? "Resend new code"
                        : "Send Code again in ${forgotPasswordController.resendAfter} seconds",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      opacity:
          _isValidEmail(forgotPasswordController.emailid.value) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Icon(Icons.check_circle, color: primarycolor, size: 22),
    );
  }

  /// Function to check if email is valid
  bool _isValidEmail(String email) {
    // return email.length > 3;
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool _isValidPassword(String password) {
    /*  // special charecer compulsory
   return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=<>?/\\[\]{}|~`]).{8,}$',
    ).hasMatch(password); */
    // special charecer optional
    return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$',
    ).hasMatch(password);

    // return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password); // no special charecer

    //   ^(?=.*[A-Za-z])       # must contain at least one letter
    // (?=.*\d)              # must contain at least one digit
    // [A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$   # allowed characters, min length 8
  }

  Widget _textFieldOTP({bool first = true, last, controller}) {
    var height = (Get.width - 82) / 6;
    //  var height = (Get.width - 82) / 5.5;
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
          // style: TextStyle(fontSize: height / 2, fontWeight: FontWeight.w500),
          style: TextStyle(
            fontSize: height / 2.5,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 14,
              top: 5,
              bottom: 16,
            ),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.2, color: primarycolor),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
    );
  }
}
