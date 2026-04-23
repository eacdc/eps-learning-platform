import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/login_model/login_response.dart';
import 'package:test_your_learing/networks/api_manager.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var getStartLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>();

  Future<ApiResponse> loginUser(
    String username,
    String password,
    BuildContext context,
  ) async {
    isLoading.value = true;

    try {
      ApiResponse response = await ApiManager.request(
        endpoint: ApiManager.login,
        method: "POST",
        body: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        loginResponse.value = LoginResponse.fromJson(response.data);
        await _persistSession(loginResponse.value!);
        SnackBarHelper.showSuccessSnackBar(context, "Login Successful");
        Get.offAll(() => DashboardPage());
      } else {
        SnackBarHelper.showFailureSnackBar(
          context,
          response.data["message"] ?? "Login failed",
        );
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

  Future<ApiResponse> discoverAccountsByEmail(
    String email,
    BuildContext context,
  ) async {
    isLoading.value = true;

    try {
      ApiResponse response = await ApiManager.request(
        endpoint: ApiManager.login,
        method: "POST",
        body: {"email": email},
      );
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

  Future<ApiResponse> fetchAccountsByGoogleToken(
    String idToken,
    BuildContext context,
  ) async {
    getStartLoading.value = true;
    try {
      // Debug: confirm token is present before sending
      assert(
        idToken.isNotEmpty,
        'fetchAccountsByGoogleToken: idToken is empty',
      );
      final response = await ApiManager.request(
        endpoint: ApiManager.accountsByGoogleIdToken,
        method: "POST",
        body: {"idToken": idToken},
      );
      if (response.statusCode != 200) {
        // Print full backend message to Flutter console for debugging
        print('[Google Auth] accounts-by-google-idtoken error '
            '${response.statusCode}: ${response.data}');
      }
      return response;
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Unexpected error: $e");
      return ApiResponse(
        statusCode: 500,
        data: {"message": "Unexpected error: $e"},
      );
    } finally {
      getStartLoading.value = false;
    }
  }

  Future<void> _persistSession(LoginResponse response) async {
    await FlutterSecureStorage().write(key: "auth_token", value: response.token);
    SharedPreferencesService.setUserId(response.userId);
    SharedPreferencesService.setGrade(response.grade);
    SharedPreferencesService.setAccessToken(response.token);
    SharedPreferencesService.setLoginStatus(true);
  }
}
