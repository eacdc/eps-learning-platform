import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/controllers/auth_controller.dart';
import 'package:test_your_learing/controllers/resetpassword_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';


class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final resetPasswordController = Get.put(ResetPasswordController());

  final _formKey2 = GlobalKey<FormState>();

  final TextEditingController newPasswordController =
      TextEditingController(text: '');
  final TextEditingController confirmPasswordController =
      TextEditingController(text: '');
  dynamic argumentData = Get.arguments;
  String email = "";

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = argumentData[0]["EMAIL"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(children: [
        // _buildEmailForm(context)
        Obx(() => resetPasswordController.passwordReset.value
            ? _buildVerifyOtpForm(context)
            : _buildEmailForm(context))
      ]),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: graylight.withOpacity(0.8),
                              width: 1,
                            )),
                        child: SvgPicture.asset(
                          "assets/icons/svg_back_arrow.svg",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 100,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Reset password",
                      style: TextStyle(
                          color: blackcolor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 8,
                ),
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
                  child: Text("Please type something you’ll remember",
                      style: TextStyle(
                          color: textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      InputField(
                        title: "New password",
                        hintText: 'Password must be 4 characters',
                        controller: newPasswordController,
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
                          color: gray,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InputField(
                        title: "Confirm new password",
                        hintText: 'repeat password',
                        controller: confirmPasswordController,
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
                          color: gray,
                          size: 16,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomGradiantButton(
                          buttonColor: primarycolor,
                          textValue: 'Reset password',
                          textColor: onprimary,
                          loading: resetPasswordController.isLoading.value,
                          onPressed: () {
                            if (email.isEmpty) {
                              SnackBarHelper.showFailureSnackBar(
                                  context, "Email can't be empty");
                            } else if (newPasswordController.text
                                    .trim()
                                    .length <
                                4) {
                              SnackBarHelper.showFailureSnackBar(
                                  context, "Password must be 4 characters");
                            } else if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              SnackBarHelper.showFailureSnackBar(context,
                                  "Confirm password should match new password");
                            } else {
                              resetPasswordController.resetPassword(
                                  email, newPasswordController.text, context);

FocusManager.instance.primaryFocus?.unfocus();
                            }
                          }),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
              ),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    //color: graylight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
                child: SvgPicture.asset(
                  "assets/icons/svg_sucess_green.svg",
                  height: 90,
                  width: 90,
                  // color: primarycolor,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text("Password changed",
                  style: TextStyle(
                      color: blackcolor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 16,
              ),
              Text("Your password has been",
                  style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 1,
              ),
              Text("changed succesfully",
                  style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 32,
              ),
              CustomGradiantButton(
                  loading: false,
                  buttonColor: primarycolor,
                  textValue: 'Back to login',
                  textColor: onprimary,
                  onPressed: () {
                   // Get.offAll(LoginPage());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
