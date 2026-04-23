import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_your_learing/constants/grade_list.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/response_model/error_response.dart';
import 'package:test_your_learing/networks/api_manager.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

class SignupController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var showPrefix = false.obs;
  var isLoading = false.obs;
  var isLogin = true;
  var phoneNo = "".obs;
  var emailid = "".obs;
  var otp = "".obs;
  var isOtpSent = false.obs;
  var resendAfter = 60.obs;
  var resendOTP = false.obs;
  var firebaseVerificationId = "";
  var statusMessage = "".obs;
  var statusMessageColor = Colors.black.obs;
  var googleToken = "".obs;

  var superAdminLogin = false.obs;

  var timer;

  var user_name = "".obs;
  var user_nameLoading = false.obs;
  var user_name_available = false.obs;
  var user_namemessage = "".obs;


  SignupController() {}

  @override
  onInit() async {
    super.onInit();
  }



  void checkUsernameExist(String username,
   
    BuildContext context,) async {
    user_nameLoading.value = true;

    try {
      var response = await ApiManager.request(
        endpoint: ApiManager.checkUsername,
        method: "POST",
        body: {
        "username": username,

},
      );

      if (response.statusCode == 200) {

         user_name_available.value = true;
         user_namemessage.value = response.data["message"];
        

        /* SnackBarHelper.showSuccessSnackBar(
          context,
          response.data["message"],
        ); */

        

        //Get.to(() => HomeScreen());
      } else {
        final error = ErrorResponse.fromJson(response.data);
       // SnackBarHelper.showFailureSnackBar(context, error.message);
        user_name_available.value = false;
        user_namemessage.value = error.message;
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
      user_name_available.value = false;
      user_namemessage.value = "Something Went Wrong!";
    } finally {
      user_nameLoading.value = false;
    }
  }






  Future<ApiResponse> registerUser(
    String _username,
    String _fullname,
    String _email,
    String _phonenumber,
    String _password,
    String _role,
    Grade? _grade,
    String publisher,
    BuildContext context,) async {
    isLoading.value = true;

    try {
      var response = await ApiManager.request(
        endpoint: ApiManager.register,
        method: "POST",
        body: {
          "username": _username,
          "fullname": _fullname,
          "email": _email,
          "phone": _phonenumber,
          "role": _role,
          "grade": _grade?.value,
          "password": _password,
          "publisher": publisher,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          response.data["message"] ?? "Registration completed successfully",
        );
        Get.offAll(() => LoginPage());
      } else {
        final error = ErrorResponse.fromJson(response.data);
        SnackBarHelper.showFailureSnackBar(context, error.message);
      }
      return response;
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
      return ApiResponse(
        statusCode: 500,
        data: {"message": "Unexpected error: $e"},
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiResponse> registerGoogleVerified(
    String _username,
    String _fullname,
    String _phonenumber,
    String _password,
    String _role,
    Grade? _grade,
    String publisher,
    BuildContext context,
  ) async {
    isLoading.value = true;
    try {
      final response = await ApiManager.request(
        endpoint: ApiManager.registerGoogleIdToken,
        method: "POST",
        body: {
          "idToken": googleToken.value,
          "username": _username,
          "fullname": _fullname,
          "phone": _phonenumber,
          "role": _role,
          "grade": _grade?.value,
          "password": _password,
          "publisher": publisher,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          response.data["message"] ??
              "Account created successfully! You can now sign in.",
        );
        Get.offAll(() => LoginPage());
      } else {
        final error = ErrorResponse.fromJson(response.data);
        SnackBarHelper.showFailureSnackBar(context, error.message);
      }
      return response;
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
      return ApiResponse(
        statusCode: 500,
        data: {"message": "Unexpected error: $e"},
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Kept temporarily for backward-compatible widget compilation.
  void verifySignupOTP(String email, String otp, BuildContext context) {}
  void resendSignupOtp(String email, BuildContext context) {}

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
