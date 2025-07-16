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

class LoginController extends GetxController {
  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>(); // Holds LoginResponse object

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
       SharedPreferencesService.setAccessToken(loginResponse.value?.token ?? "");
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


}
