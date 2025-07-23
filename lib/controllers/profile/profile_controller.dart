import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/profile_model/profile_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userProfile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    //fetchProfile(); // Example function
  }

  void getUserProfile({
    required String token,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.userProfile,
      method: "GET",

      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            SnackBarHelper.showFailureSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            userProfile.value = UserProfile.fromJson(response.data);
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

  void updateUserProfile({
    required String token,
    required BuildContext context,
    required String fullname,
    required String email,
    required String phoneNumber,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.updateProfile,
      method: "PUT",
      body: {"fullname": fullname, "email": email, "phone": phoneNumber},

      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
          //nothing to do here
        } else if (response.data is Map) {
          if (response.data.containsKey('message')) {
            SnackBarHelper.showSuccessSnackBarGetx(response.data['message']);
          }
          // update user profile in controller
          if (response.data.containsKey('user')) {
            userProfile.value = UserProfile.fromJson(response.data['user']);
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
       // Close BottomSheet only if it's still open
      if (context != null && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }


}
