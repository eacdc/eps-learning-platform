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
                        'Compte et sécurité',
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
                        title: "Mot de passe actuel",
                        hintText: 'Entrez le mot de passe actuel',
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
                        title: "Nouveau mot de passe",
                        hintText: 'Créez un mot de passe fort',
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
                          "Au moins 8 caractères avec une combinaison de lettres et de chiffres",
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
                        title: "Confirmer le mot de passe",
                        hintText: 'Confirmez votre mot de passe',
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
                textValue: 'Changer le mot de passe',
                textColor: onprimary,
                onPressed: () {
                  final String _currentPasssword =
                      currentPasswordController.text;
                  final String _newpassword = passwordController.text;
                  final String _confirmPassword = conPasswordController.text;

                  if (_currentPasssword.length < 4) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Veuillez entrer un mot de passe actuel valide",
                    );
                  } else if (_newpassword.isEmpty ||
                      !_isValidPassword(_newpassword)) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Veuillez entrer un mot de passe valide",
                    );
                  } else if (_confirmPassword.isEmpty ||
                      _newpassword != _confirmPassword) {
                    SnackBarHelper.showFailureSnackBar(
                      context,
                      "Le mot de passe et la confirmation ne correspondent pas",
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
