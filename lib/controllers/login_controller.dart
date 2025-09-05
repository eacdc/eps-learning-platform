import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/response_model/error_response.dart';
import 'package:test_your_learing/models/login_model/login_response.dart';
import 'package:test_your_learing/networks/api_manager.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';

import '../models/login_model/google_login_response.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var getStartLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>(); // Holds LoginResponse object
  var googleLoginResponse =
      Rxn<GoogleLoginResponse>(); // Holds LoginResponse object

  void loginUser(String username, String password, BuildContext context) async {
    isLoading.value = true;

    try {
      ApiResponse response = await ApiManager.request(
        endpoint: ApiManager.login,
        method: "POST",
        body: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        loginResponse.value = LoginResponse.fromJson(response.data);

        await FlutterSecureStorage().write(
          key: "auth_token",
          value: loginResponse.value?.token ?? "",
        );

        SharedPreferencesService.setUserId(loginResponse.value?.userId ?? "");
        SharedPreferencesService.setGrade(loginResponse.value?.grade ?? "");
        SharedPreferencesService.setAccessToken(
          loginResponse.value?.token ?? "",
        );
        SharedPreferencesService.setLoginStatus(true);

        SnackBarHelper.showSuccessSnackBar(context, "Login Successful");

        Get.offAll(() => DashboardPage());
      } else {
        final error = ErrorResponse.fromJson(response.data);
        SnackBarHelper.showFailureSnackBar(context, error.message);
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void googleLoginVerify(
    String name,
    String email,
    String google_id,
    BuildContext context,
  ) async {
   getStartLoading .value = true;

    try {
      ApiResponse response = await ApiManager.request(
        endpoint: ApiManager.verifyGoogleLogin,
        method: "POST",
        body: {"email": email, "fullname": name, "googleId": google_id},
      );

      if (response.statusCode == 200) {
        googleLoginResponse.value = GoogleLoginResponse.fromJson(response.data);

        /*  await FlutterSecureStorage().write(
        key: "auth_token",
        value: loginResponse.value?.token ?? "",
      ); */

        if (googleLoginResponse.value?.success ?? false) {
          SharedPreferencesService.setUserId(
            googleLoginResponse.value?.user?.id ?? "",
          );
          SharedPreferencesService.setGrade(
            googleLoginResponse.value?.user?.grade ?? "",
          );
          SharedPreferencesService.setAccessToken(
            googleLoginResponse.value?.token ?? "",
          );
          SharedPreferencesService.setLoginStatus(true);

          SnackBarHelper.showSuccessSnackBar(context, "Login Successful");

          Get.offAll(() => DashboardPage());
        }else{
          SnackBarHelper.showFailureSnackBar(context, googleLoginResponse.value?.message ?? "Google login failed");
        }
      } else {
        final error = ErrorResponse.fromJson(response.data);
        SnackBarHelper.showFailureSnackBar(context, error.message);
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
    } finally {
      getStartLoading.value = false;
    }
  }
}
