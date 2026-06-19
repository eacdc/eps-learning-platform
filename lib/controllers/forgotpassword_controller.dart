import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/forgot_password_model/forgot_password_verify_response.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/response_model/api_response_new.dart';
import 'package:test_your_learing/networks/api_manager.dart';

import '../helper/sharedpreference_helper.dart';
import '../views/screen/authentication/login.dart';

class ForgotPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var showPrefix = false.obs;
  var hidePassword = true.obs;
  var isLoading = false.obs;
  var isLogin = true;
  var phoneNo = "".obs;
  var username = "".obs;
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

  void changePassword(
    String token,
    String currentP,
    String newP,
    String confirmP,
    BuildContext context,
  ) async {
    isLoading.value = true;

    try {
      final ApiResponseNew response = await ApiManager.requestNew(
        endpoint: ApiManager.changePassword,
        method: "POST",
        token: token,
        body: {
          "oldPassword": currentP,
          "newPassword": newP,
          "confirmPassword": confirmP,
        },
      );

      if (response.isSuccess) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          response.data["message"] ?? "Password Changed successfully",
        );

        SharedPreferencesService.clearAllPreferences();
        SharedPreferencesService.setFirstTimeStatus(
          false,
        ); // for not showing onboard screen
        SharedPreferencesService.setHasSeenDashboardWalkthrough(true);

        //logi
        Get.offAll(() => LoginPage());
      } else {
        SnackBarHelper.showFailureSnackBar(
          context,
          response.data["message"] ?? "Failed to change password",
        );
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 1 — Verify Google idToken, receive resetAuthToken + usernames.
  Future<ForgotPasswordVerifyResponse?> googleVerifyForgotPassword(
    String idToken,
    BuildContext context,
  ) async {
    isLoading.value = true;
    try {
      final ApiResponseNew response = await ApiManager.requestNew(
        endpoint: ApiManager.forgotPasswordGoogleVerify,
        method: "POST",
        body: {"idToken": idToken},
      );
      if (response.isSuccess) {
        return ForgotPasswordVerifyResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      } else {
        SnackBarHelper.showFailureSnackBar(
          context,
          response.data["message"] ?? "Google verification failed",
        );
        return null;
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2 — Complete password reset using backend-issued resetAuthToken.
  Future<void> completeForgotPasswordReset(
    String resetAuthToken,
    String username,
    String newPassword,
    BuildContext context,
  ) async {
    isLoading.value = true;
    try {
      final ApiResponseNew response = await ApiManager.requestNew(
        endpoint: ApiManager.forgotPasswordComplete,
        method: "POST",
        body: {
          "resetAuthToken": resetAuthToken,
          "username": username,
          "newPassword": newPassword,
        },
      );
      if (response.isSuccess) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          response.data["message"] ??
              "Password reset successfully. Please login again.",
        );
        Get.offAll(() => LoginPage());
      } else {
        final statusCode = response.statusCode;
        String errorMessage = response.data["message"] ?? "Failed to reset password";
        if (statusCode == 409) {
          errorMessage = "This reset link has already been used. Please verify with Google again.";
        } else if (statusCode == 422) {
          errorMessage = "Password is too weak. Use at least 8 characters with letters and numbers.";
        } else if (statusCode == 429) {
          errorMessage = "Too many attempts. Please try again later.";
        }
        SnackBarHelper.showFailureSnackBar(context, errorMessage);
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
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
    bool phoneExists = await checkPhoneNumberExists(
      phoneNumberWithoutCountrycode,
      context,
    );

    if (phoneExists) {
      // Step 2: Send OTP if the phone number exists
    } else {
      // Step 3: Show error if phone number does not exist
      SnackBarHelper.showFailureSnackBar(
        context,
        "Phone number does not exist,please contact your admin.",
      );

      statusMessage.value =
          "Phone number does not exist in the agent database.";
      isLoading.value = false;
    }
  }

  // Helper method to check if phone number exists in Firestore
  Future<bool> checkPhoneNumberExists(
    String phoneNumber,
    BuildContext context,
  ) async {
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

  @override
  void dispose() {
    super.dispose();
  }

  String cleanPhoneNumber(String phoneNumber) {
    // Remove the +91 prefix and any spaces
    return phoneNumber.replaceAll(RegExp(r'^\+91|\s+'), '');
  }
}
