import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/ImageUploadController/imageupload_controller.dart';
import 'package:test_your_learing/controllers/profile/profile_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/profile_model/profile_model.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';

class UpdateProfilePicSheet extends StatefulWidget {
  final String? title;

  final UserProfile? userProfile;
  final ProfileController profileController;

  const UpdateProfilePicSheet({
    Key? key,
    required this.userProfile,
    required this.profileController,
    this.title,
  }) : super(key: key);

  @override
  State<UpdateProfilePicSheet> createState() => _UpdateProfilePicSheetState();
}

class _UpdateProfilePicSheetState extends State<UpdateProfilePicSheet> {
  late String token;

  File? selectedImageFile;
  Uint8List? imagePreviewBytes;

  ImageuploadController imageuploadController = Get.put( ImageuploadController());

  Future<void> pickImageFile() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Reduce image size if needed
      );

      if (image != null) {
        selectedImageFile = File(image.path);
        imagePreviewBytes =
            await selectedImageFile!.readAsBytes(); // for preview
      } else {
        selectedImageFile = null;
        imagePreviewBytes = null;
      }

      setState(() {});
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());
      print(e.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      token = SharedPreferencesService.getAccessToken() ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          // top: 12,  // ⬅️ Top padding for status bar safety
          bottom:
              MediaQuery.of(
                context,
              ).viewInsets.bottom, // Pushes content up when keyboard appears
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔵 Fixed Header Section (non-scrollable)
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                      bottom: 1,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: lightbluetext,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            "Profile Picture",
                            style: TextStyle(
                              fontSize: 18,
                              color: blacktext,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(thickness: 1, color: lightbluetext),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Material(
                      color: lightbluetext,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(32),
                        splashColor: primarycolor.withAlpha(50),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            // color: lightbluetext, // insted added it in material color for ripple effect
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 🔵 Scrollable Content Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        color: bordercolor,
                        strokeWidth: 1,
                        dashPattern: [6, 3],
                        radius: Radius.circular(10),
                        child: Container(
                          height: 200,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: pickImageFile,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  imagePreviewBytes != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          imagePreviewBytes!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : Image.asset(
                                        "assets/images/add_image.png",
                                        width: 40,
                                        height: 40,
                                        color: bordercolor,
                                      ),
                                  SizedBox(height: 16),
                                  Text(
                                    selectedImageFile != null
                                        /// ? selectedImageFile!.name
                                        ? basename(selectedImageFile!.path)
                                        : 'Select Profile Image',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: primarycolor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: primarycolor.withOpacity(
                                        0.5,
                                      ),
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32),
                      selectedImageFile != null
                          ? Obx(
                            () => CustomGradiantButton(
                              loading: imageuploadController.isLoading.value,
                              buttonColor: primarycolor,
                              textValue: 'Update',
                              textColor: onprimary,
                              onPressed: () {
                                if (selectedImageFile != null) {
                                  imageuploadController.updateUserProfilePicture(
                                    file: selectedImageFile!,
                                    token: token,
                                    //fileExtension: widget.userProfile!.fullname,
                                    context: context,
                                    profile_controller:
                                        widget.profileController,
                                  );
                                }
                              },
                            ),
                          )
                          : SizedBox.shrink(),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*     Widget _buildSuffixIcon() {
    return AnimatedOpacity(
      opacity: _isValidEmail(signupController.emailid.value) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Icon(Icons.check_circle, color: primarycolor, size: 18),
    );
  } */

  bool _isValidEmail(String email) {
    // return email.length > 3;
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  bool validateCredentials(
    String _fullname,
    String _email,
    String _phonenumber,
    BuildContext context,
  ) {
    if (_fullname.isEmpty || _fullname.trim().length < 4) {
      SnackBarHelper.showFailureSnackBarGetx("Please enter your valid name");
      return false;
    }

    if (_email.isEmpty || !_isValidEmail(_email)) {
      SnackBarHelper.showFailureSnackBarGetx("Please enter a valid Emailid");
      return false;
    }

    if (_phonenumber.isEmpty || !_isValidMobile(_phonenumber)) {
      SnackBarHelper.showFailureSnackBarGetx(
        "Please enter a valid Mobile number",
      );
      return false;
    }

    return true;
  }
}
