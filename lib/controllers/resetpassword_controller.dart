import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class ResetPasswordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  var passwordReset = false.obs;

  ResetPasswordController() {}

  @override
  onInit() async {
    super.onInit();
  }

 void resetPassword(
    String email, String newPassword, BuildContext context) async {
  isLoading.value = true;

  try {
    final ApiResponse response = await ApiManager.request(
      endpoint: ApiManager.resetPassword,
      method: "POST",
      body: {"email": email, "new_password": newPassword},
    );

    print("Reset Password Response: ${response.data}");

    if (response.statusCode == 200) {
      SnackBarHelper.showSuccessSnackBar(
          context, response.data["message"] ?? "Password reset successfully");
      passwordReset.value = true;
    } else {
      SnackBarHelper.showFailureSnackBar(
          context, response.data["message"] ?? "Something went wrong");
    }
  } catch (e) {
    SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
  } finally {
    isLoading.value = false;
  }
}

  @override
  void dispose() {
    super.dispose();
  }
}
