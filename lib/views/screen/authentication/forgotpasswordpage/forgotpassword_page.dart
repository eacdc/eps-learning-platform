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

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final forgotPasswordController = Get.put(ForgotPasswordController());

  final _formKey3 = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 38,
                      width: 38,
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: graylight.withOpacity(0.8),
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/svg_back_arrow.svg",
                         colorFilter:  ColorFilter.mode(textBlack, BlendMode.srcIn),
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: blackcolor,
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
                      color: textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
               
               
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            forgotPasswordController.sendOTP(
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
    List<TextEditingController> otpFieldsControler = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      // TextEditingController(),
      //  TextEditingController()
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    forgotPasswordController.isOtpSent.value = false;
                    Get.back();
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: graylight.withOpacity(0.8),
                        width: 1,
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/svg_back_arrow.svg",
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 120),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please check your email",
                  style: TextStyle(
                    color: blackcolor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We’ve sent a code to",
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  emailController.text,
                  style: TextStyle(
                    color: blackcolor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 36),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        /*  _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[4]),
                        _textFieldOTP(
                            first: false,
                            last: true,
                            controller: otpFieldsControler[5]), */
                      ],
                    ),
                    /*   Text(
                      forgotPasswordController.statusMessage.value,
                      style: TextStyle(
                          color:
                              forgotPasswordController.statusMessageColor.value,
                          fontWeight: FontWeight.bold),
                    ), */
                    SizedBox(height: 32),
                    CustomGradiantButton(
                      loading: forgotPasswordController.isLoading.value,
                      buttonColor: primarycolor,
                      textValue: 'Verify',
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

                        if (forgotPasswordController.otp.value.length == 4) {
                          forgotPasswordController.verifyOTP(
                            emailController.text,
                            forgotPasswordController.otp.value,
                            context,
                          );
                        } else {
                          SnackBarHelper.showFailureSnackBar(
                            context,
                            "Please Enter 4 Digit OTP Sent To Your Email",
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
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: blackcolor.withOpacity(0.6),
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

  Widget _textFieldOTP({bool first = true, last, controller}) {
    //var height = (Get.width - 82) / 6;
    var height = (Get.width - 82) / 5.5;
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
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: blackcolor,
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
              borderSide: BorderSide(width: 1.2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.2, color: primarycolor),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
