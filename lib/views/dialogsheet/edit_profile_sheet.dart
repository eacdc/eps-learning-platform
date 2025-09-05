import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/profile/profile_controller.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/profile_model/profile_model.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';

class EditProfileSheet extends StatefulWidget {
  final String? title;
  final Widget? content;
  final VoidCallback? onReadMore;
  final UserProfile? userProfile;
  final ProfileController profileController;

  const EditProfileSheet({
    Key? key,
    required this.userProfile,
    required this.profileController,
    this.title,
    this.content,
    this.onReadMore,
  }) : super(key: key);

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late String token;
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    final userProfile = widget.userProfile;
    final fullname = userProfile?.fullname ?? '';
    final email = userProfile?.email ?? '';
    final _phone = userProfile?.phone ?? '';
    final phone = _phone.replaceAll('+91', '').replaceAll(' ', '');

    fullnameController.text = fullname;
    emailController.text = email;
    phonenoController.text = phone;

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
          decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
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
                      InputField(
                        title: "Full name",
                        hintText: 'Enter your full name',
                        suffixIcon: SizedBox.shrink(),
                        controller: fullnameController,
                      ),
                      SizedBox(height: 16),

                      InputField(
                        title: "Email Address",
                        hintText: 'Enter your Email Address',
                        suffixIcon: SizedBox.shrink(),
                        // mandatory: true,
                        controller: emailController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: graytext,
                          size: 16,
                        ),
                        onChanged: (val) {
                          //signupController.emailid.value = val;
                        },
                        onSaved: (val) => null,
                        validator:
                            (val) =>
                                (val!.isEmpty || val!.length < 10)
                                    ? "Enter valid Email Address"
                                    : null,
                      ),
                      SizedBox(height: 16),

                      InputField(
                        title: "Phone number",
                        hintText: 'Enter your phone number',
                        suffixIcon: SizedBox.shrink(),
                        controller: phonenoController,
                      ),
                      SizedBox(height: 20),
                      CustomGradiantButton(
                        loading: widget.profileController.isLoading.value,
                        buttonColor: primarycolor,
                        textValue: 'Save Changes',
                        textColor: onprimary,
                        onPressed: () {
                          final _fullname = fullnameController.text;
                          final _email = emailController.text;
                          final _phonenumber = phonenoController.text;

                          if (validateCredentials(
                            _fullname,
                            _email,
                            _phonenumber,

                            context,
                          )) {
                            /*  loginController.loginUser(
                                    _email, _password, context); */
                            // update email to controller
                            widget.profileController.updateUserProfile(
                              token: token,
                              context: context,
                              fullname: _fullname,
                              email: _email,
                              phoneNumber: _phonenumber,
                            );

                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                      ),

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
