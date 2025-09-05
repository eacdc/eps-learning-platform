import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';

import '../../../../../controllers/forgotpassword_controller.dart';
import '../../../../../helper/getx_helper.dart';
import '../../../../../helper/sharedpreference_helper.dart';
import '../../../../../helper/snackbar_helper.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {

  late ForgotPasswordController forgotPasswordController;
  late String token;


  final TextEditingController passwordController = TextEditingController(
    text: '',
  );
  final TextEditingController conPasswordController = TextEditingController(
    text: '',
  );
  final TextEditingController currentPasswordController = TextEditingController(
    text: '',
  );

  bool passwordVisible = false;
  bool isRememberMe = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  bool _isValidPassword(String password) {
    /*  // special charecer compulsory
   return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=<>?/\\[\]{}|~`]).{8,}$',
    ).hasMatch(password); */
    // special charecer optional
    return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$',
    ).hasMatch(password);

    // return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password); // no special charecer

    //   ^(?=.*[A-Za-z])       # must contain at least one letter
    // (?=.*\d)              # must contain at least one digit
    // [A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$   # allowed characters, min length 8
  }


   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    forgotPasswordController = findOrPut(() => ForgotPasswordController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
       token = SharedPreferencesService.getAccessToken() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Container(
                  // color: Colors.yellow,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircularBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        'Account Security',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
              Divider(color: Theme.of(context).dividerColor, height: 1),
            ],
          ),
        ),
        body: Obx((){return    Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        title: "Curent Password",
                        hintText: 'Enter current password',
                        controller: currentPasswordController,
                        obscureText: !passwordVisible,
                        suffixIcon: IconButton(
                          color: textGrey,
                          splashRadius: 1,
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: togglePassword,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: graytext,
                          size: 16,
                        ),
                      ),

                      SizedBox(height: 16),

                      InputField(
                        title: "New Password",
                        hintText: 'Create a strong password',
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        suffixIcon: IconButton(
                          color: textGrey,
                          splashRadius: 1,
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: togglePassword,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: graytext,
                          size: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "At least 8 characters with a combination of letters and numbers",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      InputField(
                        title: "Confirm Password",
                        hintText: 'Confirm your password',
                        controller: conPasswordController,
                        obscureText: !passwordVisible,
                        suffixIcon: IconButton(
                          color: textGrey,
                          splashRadius: 1,
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: togglePassword,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: graytext,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomGradiantButton(
                loading: forgotPasswordController.isLoading.value,
                buttonColor: primarycolor,
                textValue: 'Change Password',
                textColor: onprimary,
                onPressed: () {
                  final String _currentPasssword =
                      currentPasswordController.text;
                  final String _newpassword = passwordController.text;
                  final String _confirmPassword = conPasswordController.text;

                  if (_currentPasssword.length < 4) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Please Enter Valid Current Password",
                    );
                  } else if (_newpassword.isEmpty ||
                      !_isValidPassword(_newpassword)) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Please enter a valid Password ",
                    );
                  } else if (_confirmPassword.isEmpty ||
                      _newpassword != _confirmPassword) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Password and Confirm Password do not match",
                    );
                  } else {
                    forgotPasswordController.changePassword(
                      token,
                      _currentPasssword,
                      _newpassword,
                      _confirmPassword,
                      context,
                    );
                  }
                },
              ),

              SizedBox(height: 10),
            ],
          ),
        );
     })
        
        
        
      ),
    );
  }
}
