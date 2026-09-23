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

  /// The backend now localizes error messages (it returns French when this
  /// build sends Accept-Language: fr), so we surface the backend message
  /// directly instead of matching on English text — which would break the
  /// moment the message arrives translated. When the backend gives us no
  /// usable message we fall back on the status code alone (never on the text).
  String _localizedLoginError(int statusCode, dynamic backendMessage) {
    final msg = (backendMessage ?? "").toString().trim();

    // Prefer the backend's (already localized) message when present.
    if (msg.isNotEmpty) {
      return msg;
    }

    // No message body: derive a French fallback purely from the status code.
    switch (statusCode) {
      case 401:
      case 400:
        return "Nom d'utilisateur ou mot de passe incorrect";
      case 403:
        return "Ce compte appartient à une autre application.";
      case 404:
        return "Compte introuvable";
      default:
        return "Échec de la connexion. Veuillez réessayer.";
    }
  }

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
        SnackBarHelper.showSuccessSnackBar(context, "Connexion réussie");
        Get.offAll(() => DashboardPage());
      } else {
        SnackBarHelper.showFailureSnackBar(
          context,
          _localizedLoginError(response.statusCode, response.data["message"]),
        );
      }
      return response;
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, "Une erreur inattendue s'est produite");
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
      SnackBarHelper.showFailureSnackBar(context, "Une erreur inattendue s'est produite");
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
      SnackBarHelper.showFailureSnackBar(context, "Une erreur inattendue s'est produite");
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
    SharedPreferencesService.setName(response.name);
    SharedPreferencesService.setGrade(response.grade);
    SharedPreferencesService.setAccessToken(response.token);
    SharedPreferencesService.setLoginStatus(true);
  }
}
