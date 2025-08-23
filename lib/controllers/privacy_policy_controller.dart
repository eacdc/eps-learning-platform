import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../helper/snackbar_helper.dart';
import '../models/policy_model/privacy_policy_model.dart';
import '../networks/api_manager.dart';

class PrivacyPolicyController extends GetxController {
  var isLoading = false.obs;
  var privacyPolicy = Rxn<PrivacyPolicyResponse>();

  @override
  void onInit() {
    super.onInit();
    //fetchProfile(); // Example function
  }

  void getPrivacyPolicy({
    required String token,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.privacyPolicy,
      method: "GET",

      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is Map) {
          if (response.data.containsKey('success') && response.data['success'] == true) {
              privacyPolicy.value = PrivacyPolicyResponse.fromJson(response.data);
         
          } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Something Went Wrong",
          );
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ?? response.data['message'],
          );
        } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Request failed: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  
}
