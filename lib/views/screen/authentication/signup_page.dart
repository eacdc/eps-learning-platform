import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/constants/grade_list.dart';
import 'package:test_your_learing/constants/role_list.dart';

import 'package:test_your_learing/controllers/login_controller.dart';
import 'package:test_your_learing/controllers/signup_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/custom_dropdown.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

import '../../../helper/getx_helper.dart';
import '../../custom_widgets/circular_back_button.dart';
import '../../custom_widgets/progressbar_widget.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final signupController = Get.put(SignupController());
  final loginController = findOrPut(() => LoginController());

  final _formKey4 = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final TextEditingController passwordController = TextEditingController(
    text: '',
  );
  final TextEditingController conPasswordController = TextEditingController(
    text: '',
  );

  Grade? grade;
  String? role;

  bool passwordVisible = false;
  bool isRememberMe = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleSubscription;
  bool _handlingGoogleEvent = false;
  bool _googleInitialized = false;

  final List<String> scopes = ['email', 'profile', 'openid'];

  @override
  void dispose() {
    _googleSubscription?.cancel();
    super.dispose();
  }

  void googleAccountLogin() {
    _googleSubscription?.cancel();
    _handlingGoogleEvent = false;

    _googleSubscription = GoogleSignIn.instance.authenticationEvents
        .listen(_handleAuthenticationEvent)
          ..onError(_handleAuthenticationError);

    GoogleSignIn.instance.authenticate(scopeHint: scopes);
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (_handlingGoogleEvent) return;
    _handlingGoogleEvent = true;
    _googleSubscription?.cancel();
    _googleSubscription = null;

    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user == null) {
      _handlingGoogleEvent = false;
      return;
    }

    final GoogleSignInClientAuthorization? authorization = await user
        .authorizationClient
        .authorizationForScopes(scopes);

    if (!mounted) return;

    if (authorization == null) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Impossible de récupérer les détails du compte Google. Veuillez réessayer.",
      );
      return;
    }

    final googleToken = user.authentication.idToken;
    if (googleToken == null || googleToken.isEmpty) {
      _handlingGoogleEvent = false;
      SnackBarHelper.showFailureSnackBar(
        context,
        "Impossible de vérifier le jeton Google. Veuillez réessayer.",
      );
      return;
    }

    final response = await loginController.fetchAccountsByGoogleToken(
      googleToken,
      context,
    );

    if (!mounted) return;
    _handlingGoogleEvent = false;

    if (response.statusCode != 200) {
      SnackBarHelper.showFailureSnackBar(
        context,
        response.data["message"] ?? "Impossible de continuer avec Google",
      );
      return;
    }

    signupController.googleToken.value = googleToken;
    final email = response.data["email"]?.toString() ?? "";
    if (email.isNotEmpty) {
      signupController.emailid.value = email;
      emailController.text = email;
    }
    SnackBarHelper.showSuccessSnackBar(
      context,
      "Compte Google vérifié. Complétez le formulaire pour créer votre compte.",
    );
  }

  Future<void> _handleAuthenticationError(Object e) async {
    _handlingGoogleEvent = false;
    if (!mounted) return;
    SnackBarHelper.showFailureSnackBar(
      context,
      "La connexion Google a échoué. Veuillez réessayer.",
    );
  }

  @override
  void initState() {
    super.initState();
    if (!_googleInitialized) {
      _googleInitialized = true;
      GoogleSignIn.instance
          .initialize(
            clientId: Constants.googleLoginClientId,
            serverClientId: Constants.googleLoginServerClientId,
          )
          .catchError((_) {});
    }
    final args = Get.arguments as Map<String, dynamic>?;
    final token = args?["googleToken"] as String?;
    final googleEmail = args?["googleEmail"] as String?;
    if (token != null && token.isNotEmpty) {
      signupController.googleToken.value = token;
    }
    if (googleEmail != null && googleEmail.isNotEmpty) {
      emailController.text = googleEmail;
      signupController.emailid.value = googleEmail;
    }

    try {
      role = roleList.firstWhere((role) => role == "student");

      if (role != null) roleController.text = role!;
    } catch (e) {
      role = null; // Keep it null if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          _buildGetOtpForm(context),
        ],
      ),
    );
  }

  Widget _buildGetOtpForm(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey4,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircularBackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Bienvenue sur EPS Learning",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Rejoignez l’écosystème EPS Digital Learning et découvrez l’apprentissage intelligent. C’est gratuit !",
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputField(
                                title: "Nom d'utilisateur (utilisé pour la connexion)",
                                hintText: "Créez un nom d'utilisateur",
                                suffixIcon: _buildUsernameSuffixIcon(
                                  signupController,
                                ),
                                controller: usernameController,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: graytext,
                                  size: 16,
                                ),
                                onChanged: (val) {
                                  signupController.user_name.value = val;

                                  signupController.checkUsernameExist(
                                    val.toString(),
                                    context,
                                  );
                                },
                                onSaved:
                                    (val) =>
                                        signupController.emailid.value = val!,
                                validator:
                                    (val) =>
                                        (val == null || val.trim().length < 2)
                                            ? "Entrez un nom d'utilisateur valide"
                                            : null,
                              ),
                              _buildUsernameMessage(signupController),
                              SizedBox(height: 16),

                              InputField(
                                title: "Nom complet",
                                hintText: 'Entrez votre nom complet',
                                suffixIcon: SizedBox.shrink(),
                                controller: fullnameController,
                              ),
                              SizedBox(height: 16),

                              InputField(
                                title: "Adresse e-mail",
                                hintText: 'Entrez votre adresse e-mail',
                                suffixIcon: _buildSuffixIcon(),
                                // mandatory: true,
                                controller: emailController,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: graytext,
                                  size: 16,
                                ),
                                onChanged: (val) {
                                  signupController.emailid.value = val;
                                },
                                onSaved:
                                    (val) =>
                                        signupController.emailid.value = val!,
                                validator:
                                    (val) =>
                                        (val == null || val.trim().isEmpty)
                                            ? "Entrez une adresse e-mail valide"
                                            : null,
                              ),
                              SizedBox(height: 16),

                              InputField(
                                title: "Numéro de téléphone",
                                hintText: 'Entrez votre numéro de téléphone',
                                suffixIcon: SizedBox.shrink(),
                                controller: phonenoController,
                              ),
                              SizedBox(height: 16),

                              IgnorePointer(
                                child: CommonDropdownButton(
                                  title: "Sélectionnez votre rôle",
                                  hintText: "Sélectionnez votre rôle",
                                  //chosenValue: shiftList.isNotEmpty ? shiftList.first : null,
                                  chosenValue: role,
                                  itemsList: roleList,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Select your role';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      // chosenAgent = value;
                                      role = value;
                                    });
                                  },
                                  displayField: (role) => role ?? "",
                                ),
                              ),

                              SizedBox(height: 16),

                              CommonDropdownButton(
                                title: "Sélectionnez votre niveau",
                                hintText: "Sélectionnez votre niveau",
                                //chosenValue: shiftList.isNotEmpty ? shiftList.first : null,
                                chosenValue: grade,
                                itemsList: gradeList,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Select your grade';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    // chosenAgent = value;
                                    grade = value;
                                  });
                                },
                                displayField: (grade) => grade?.name ?? "",
                              ),

                              SizedBox(height: 16),

                              InputField(
                                title: "Password",
                                hintText: 'Créez un mot de passe solide',
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
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
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

                              /*   SizedBox(height: 12),
            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isRememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            isRememberMe = value!;
                                          });
                                        },
                                        activeColor: primarycolor,
                                        side: BorderSide(),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
            
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      Text('Remember Me'),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ForgotPasswordPage());
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "--------- ",
                                        style: TextStyle(
                                          color: graytext,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
             */
                              SizedBox(height: 24),
                              CustomGradiantButton(
                                loading: signupController.isLoading.value,
                                buttonColor: primarycolor,
                                textValue: "S'inscrire",
                                textColor: onprimary,
                                onPressed: () {
                                  /*     final form = _formKey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                      authController.getOtp(context);
                                      authController.showProgressbar.value = true;
                                    } */

                                  final _username = usernameController.text;
                                  final _fullname = fullnameController.text;
                                  final _email = emailController.text;
                                  final _phonenumber = phonenoController.text;
                                  final _password = passwordController.text;
                                  final _conpassword =
                                      conPasswordController.text;
                                  final _role = role;
                                  final _grade = grade;
                                  final publisher = "";

                                  if (validateCredentials(
                                    _username,
                                    _fullname,
                                    _email,
                                    _phonenumber,
                                    _password,
                                    _conpassword,
                                    _role,
                                    _grade,
                                    context,
                                  )) {
                                    /*  loginController.loginUser(
                                          _email, _password, context); */
                                    if (signupController
                                        .googleToken
                                        .value
                                        .isNotEmpty) {
                                      signupController.registerGoogleVerified(
                                        _username,
                                        _fullname,
                                        _phonenumber,
                                        _password,
                                        _role!,
                                        _grade,
                                        publisher,
                                        context,
                                      );
                                    } else {
                                      signupController.registerUser(
                                        _username,
                                        _fullname,
                                        _email,
                                        _phonenumber,
                                        _password,
                                        _role!,
                                        _grade,
                                        publisher,
                                        context,
                                      );
                                    }

                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                },
                              ),

                              const SizedBox(height: 16),

                              Material(
                                borderRadius: BorderRadius.circular(32.0),
                                elevation: 0,
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                    /*  gradient: LinearGradient(
                                colors: [
                                  primarycolor,
                                  primarycolor
                                ], // Replace with your gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ), */
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                  if (signupController.googleToken.value.isEmpty) {
                                    googleAccountLogin();
                                  }
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/icon_google.png",
                                            height: 24,
                                            width: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            signupController.googleToken.value
                                                .isNotEmpty
                                                ? "Google vérifié"
                                                : "S'inscrire avec Google",
                                            style: heading6.copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 32),

                              InkWell(
                                onTap: () {
                                  // showCustomerOnboardBottomsheet(context);
                                  Get.off(() => LoginPage());
                                },
                                child: Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Vous avez déjà un compte ?  ',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                          fontFamily: Constants.fontFamily,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          /* TextSpan(
                                  text: 'bold',
                                  style: TextStyle(fontWeight: FontWeight.bold)), */
                                          TextSpan(
                                            text: 'Se connecter',
                                            style: TextStyle(
                                              color: primarycolor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 32),

                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  signupController.googleToken.value.isNotEmpty
                                      ? "Compte Google vérifié. Complétez les champs ci-dessous pour créer votre compte."
                                      : "En vous inscrivant, vous acceptez les conditions d’utilisation et la politique de confidentialité d’EPS",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withAlpha(200),

                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ProgressBarWidget(visible: loginController.getStartLoading.value),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyOtpForm(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget _buildSuffixIcon() {
    return AnimatedOpacity(
      opacity: _isValidEmail(signupController.emailid.value) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Icon(Icons.check_circle, color: primarycolor, size: 18),
    );
  }

  Widget _buildUsernameSuffixIcon(SignupController signupController) {
    return Obx(() {
      final username = signupController.user_name.value;
      final isLoading = signupController.user_nameLoading.value;
      final isAvailable = signupController.user_name_available.value;

      if (username.isEmpty) {
        return const SizedBox.shrink(); // No icon
      } else if (isLoading) {
        return Container(
          padding: EdgeInsets.all(16),

          /*     Transform.scale(
  scale: 0.5,
  child: CircularProgressIndicator(),
) */
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: primarycolor),
        );
      } else {
        return Icon(
          isAvailable ? Icons.check_circle : Icons.error,
          color: isAvailable ? Colors.green : Colors.red,
          size: 18,
        );
      }
    });
  }

  Widget _buildUsernameMessage(SignupController signupController) {
    return Obx(() {
      final username = signupController.user_name.value;
      final isLoading = signupController.user_nameLoading.value;
      final isAvailable = signupController.user_name_available.value;
      final usernameMessage = signupController.user_namemessage.value;

      if (username.isEmpty) {
        return const SizedBox.shrink(); // No icon
      } /* else if (isLoading) {
      return  Container(
        padding: EdgeInsets.all(16),
    /*     Transform.scale(
  scale: 0.5,
  child: CircularProgressIndicator(),
) */
        
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2,color: primarycolor,),
      );
    } */ else {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              Text(
                usernameMessage,
                // textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  /// Function to check if email is valid
  bool _isValidEmail(String email) {
    // return email.length > 3;
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  bool _isValidPassword(String password) {
    /*  // special charecer compulsory
   return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=<>?/\\[\]{}|~`]).{8,}$',
    ).hasMatch(password); */

    // special charecer optional
    return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{6,}$',
    ).hasMatch(password);

    // no special charecer
    // return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);

    //   ^(?=.*[A-Za-z])       # must contain at least one letter
    // (?=.*\d)              # must contain at least one digit
    // [A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$   # allowed characters, min length 8
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9._]{2,}$').hasMatch(username);
  }

  
  
  bool validateCredentials(
    String _username,
    String _fullname,
    String _email,
    String _phonenumber,
    String _password,
    String _conpassword,
    String? _role,
    Grade? _grade,
    BuildContext context,
  ) {
    if (_username.isEmpty ||
        // _username.trim().length < 4 ||
        !_isValidUsername(_username)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Veuillez entrer un nom d'utilisateur valide",
      );
      return false;
    }

    if (_fullname.isEmpty || _fullname.trim().length < 4) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Veuillez entrer votre nom complet",
      );
      return false;
    }

    if (_email.isEmpty || !_isValidEmail(_email)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Veuillez entrer une adresse e-mail valide",
      );
      return false;
    }

    if (_phonenumber.isEmpty || !_isValidMobile(_phonenumber)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Veuillez entrer un numéro de téléphone valide",
      );
      return false;
    }

    if (_role == null) {
      SnackBarHelper.showFailureSnackBar(context, "Veuillez sélectionner un rôle valide");
      return false;
    }

    if (_grade == null) {
      SnackBarHelper.showFailureSnackBar(context, "Veuillez sélectionner un niveau valide");
      return false;
    }

    if (_password.isEmpty || !_isValidPassword(_password)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Veuillez entrer un mot de passe valide",
      );
      return false;
    }

    if (_password != _conpassword) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Le mot de passe et la confirmation ne correspondent pas",
      );
      return false;
    }

    return true;
  }

  Widget _textFieldOTP({bool first = true, last, controller}) {
    var height = (Get.width - 82) / 6;
    return Container(
      height: height,

      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              Get.focusScope?.nextFocus();
            }
            if (value.length == 0 && first == false) {
              Get.focusScope?.previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: height / 2.5, fontWeight: FontWeight.w600),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: primarycolor),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
    );
  }
}
