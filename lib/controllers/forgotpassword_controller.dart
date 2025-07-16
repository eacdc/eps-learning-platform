import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/networks/api_manager.dart';
import 'package:test_your_learing/views/screen/authentication/forgotpasswordpage/resetpassword_page.dart';


class ForgotPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var showPrefix = false.obs;
  var isLoading = false.obs;
  var isLogin = true;
  var phoneNo = "".obs;
  var emailid = "".obs;
  var otp = "".obs;
  var isOtpSent = false.obs;
  var resendAfter = 30.obs;
  var resendOTP = false.obs;
  var firebaseVerificationId = "";
  var statusMessage = "".obs;
  var statusMessageColor = Colors.black.obs;

  var superAdminLogin = false.obs;

  var timer;

  ForgotPasswordController() {}

  @override
  onInit() async {
    super.onInit();
  }

void sendOTP(String email, BuildContext context) async {
  isLoading.value = true;

  try {
    final ApiResponse response = await ApiManager.request(
      endpoint: ApiManager.sendOTP,
      method: "POST",
      body: {"email": email},
    );

    if (response.statusCode == 200) {
      isOtpSent.value = true;

      SnackBarHelper.showSuccessSnackBar(
        context,
        response.data["message"] ?? "OTP sent successfully",
      );

      startResendOtpTimer();
    } else {
      SnackBarHelper.showFailureSnackBar(
        context,
        response.data["message"] ?? "Failed to send OTP",
      );
    }
  } catch (e) {
    SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
  } finally {
    isLoading.value = false;
  }
}

void verifyOTP(String email, String otp, BuildContext context) async {
  isLoading.value = true;

  try {
    final ApiResponse response = await ApiManager.request(
      endpoint: ApiManager.verifyOTP,
      method: "POST",
      body: {"email": email, "otp": otp},
    );

    if (response.statusCode == 200) {
      SnackBarHelper.showSuccessSnackBar(
        context,
        response.data["message"] ?? "OTP verified successfully",
      );

      // Navigate to reset password screen with email as argument
      Get.off(() => ResetPasswordPage(), arguments: [
        {"EMAIL": email},
      ]);
    } else {
      SnackBarHelper.showFailureSnackBar(
        context,
        response.data["message"] ?? "Failed to verify OTP",
      );
    }
  } catch (e) {
    SnackBarHelper.showFailureSnackBar(
      context,
      "Unexpected error: $e",
    );
  } finally {
    isLoading.value = false;
  }
}

  resendOtp(String email, BuildContext context) async {
    resendOTP.value = false;
    sendOTP(email, context);
  }

/*   getOtp() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNo.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
        isOtpSent.value = true;
        showProgressbar.value = false;
        statusMessage.value = "OTP sent to +91" + phoneNo.value;
        startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

 */

  Future<void> getOtp(BuildContext context) async {
    String phoneNumber = '+91' + phoneNo.value;
    String phoneNumberWithoutCountrycode = phoneNo.value;

    // Step 1: Verify if the phone number exists in Firestore
    bool phoneExists =
        await checkPhoneNumberExists(phoneNumberWithoutCountrycode, context);

    if (phoneExists) {
      // Step 2: Send OTP if the phone number exists
    } else {
      // Step 3: Show error if phone number does not exist
      SnackBarHelper.showFailureSnackBar(
          context, "Phone number does not exist,please contact your admin.");

      statusMessage.value =
          "Phone number does not exist in the agent database.";
      isLoading.value = false;
    }
  }

// Helper method to check if phone number exists in Firestore
  Future<bool> checkPhoneNumberExists(
      String phoneNumber, BuildContext context) async {
    return false;
    /*    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirebaseDB.agents)
          .where(FirebaseDB.agentmobile, isEqualTo: phoneNumber)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(
          context, "Error checking phone number: $e");
      statusMessage.value = "Error checking phone number: $e";
      return false;
    } */
  }

  startResendOtpTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendAfter.value != 0) {
        resendAfter.value--;
      } else {
        resendAfter.value = 30;
        resendOTP.value = true;
        timer.cancel();
      }
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String cleanPhoneNumber(String phoneNumber) {
    // Remove the +91 prefix and any spaces
    return phoneNumber.replaceAll(RegExp(r'^\+91|\s+'), '');
  }
}
