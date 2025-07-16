import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var showPrefix = false.obs;
  var showProgressbar = false.obs;
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

  AuthController() {}

  @override
  onInit() async {
    super.onInit();
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
      showProgressbar.value = false;
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


  @override
  void dispose() {
    super.dispose();
  }

  String cleanPhoneNumber(String phoneNumber) {
    // Remove the +91 prefix and any spaces
    return phoneNumber.replaceAll(RegExp(r'^\+91|\s+'), '');
  }
}
