import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/utils/app_colors.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';
import 'package:test_your_learing/views/custom_widgets/secondary_button.dart';

import 'login.dart';

class GateStatrtedScreen extends StatelessWidget {
  const GateStatrtedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  const Text(
                    Constants.getstarted_title,
                    textAlign: TextAlign.start,

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Description
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      Constants.getstarted_desc,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: graytext),
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
                                "assets/icons/icon_google.png",
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Continue with Google",
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
                  const SizedBox(height: 16),
                  Material(
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

                  const SizedBox(height: 24),

                  // const Spacer(),

                  // Footer Text


                    InkWell(
                      onTap: () {
                       // showCustomerOnboardBottomsheet(context);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'New to EPS?  ',
                              style: TextStyle(
                                  color: gray,
                                  fontFamily: Constants.fontFamily,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              // style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                /* TextSpan(
                          text: 'bold',
                          style: TextStyle(fontWeight: FontWeight.bold)), */
                                TextSpan(
                                    text: 'Create Account',
                                    style: TextStyle(
                                        color: primarycolor,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
