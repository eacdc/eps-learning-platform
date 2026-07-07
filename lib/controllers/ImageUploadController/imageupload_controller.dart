import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:test_your_learing/controllers/profile/profile_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/profile_model/profile_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class ImageuploadController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void updateUserProfilePicture({
    required String token,
    required BuildContext context,
    required ProfileController profile_controller,
    required File file,
    //  required String? fileExtension,
  }) async {
    isLoading.value = true;

    final uri = Uri.parse(ApiManager.baseUrl + ApiManager.updateProfilePic);

    final request = http.MultipartRequest("POST", uri);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['X-Publisher'] = Constants.publisher;

    // Add form fields
    //request.fields['fullname'] = fullname;

    // Add image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'profilePicture', // <-- field name used in backend
        file.path,
        filename: basename(file.path),
        contentType: MediaType(
          'image',
          'jpeg',
        ), // Optional if required by backend
      ),
    );

    // Send request
    final response = await request.send();

    try {
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> data = json.decode(responseData.body);

        if (data is Map) {
          if (data.containsKey('message')) {
            SnackBarHelper.showSuccessSnackBarGetx(data['message']);
          }
          // update user profile in controller
          if (data.containsKey('user')) {
            profile_controller.userProfile.value = UserProfile.fromJson(
              data['user'],
            );
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        SnackBarHelper.showFailureSnackBarGetx(
          "Something went wrong: ${response.statusCode}",
        );
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
