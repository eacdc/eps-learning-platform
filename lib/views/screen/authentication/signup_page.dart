import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/constants/grade_list.dart';
import 'package:test_your_learing/constants/role_list.dart';

import 'package:test_your_learing/controllers/auth_controller.dart';
import 'package:test_your_learing/controllers/login_controller.dart';
import 'package:test_your_learing/controllers/signup_controller.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/custom_dropdown.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';
import 'package:test_your_learing/views/screen/authentication/forgotpasswordpage/forgotpassword_page.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

import '../../custom_widgets/circular_back_button.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final signupController = Get.put(SignupController());

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Prefill data if editing

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
          // _buildGetOtpForm(context),
          // _buildVerifyOtpForm(context),
          Obx(
            () =>
                signupController.isOtpSent.value
                    ? _buildVerifyOtpForm(context)
                    : _buildGetOtpForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGetOtpForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                      "Welcome to EPS Learning",
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
                      "Let’s join to Test Your Learning ecosystem & experience smart learning. It’s Free!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                          title: "Username (Used for login)",
                          hintText: 'Create a user name',
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
                              (val) => signupController.emailid.value = val!,
                          validator:
                              (val) =>
                                  (val!.isEmpty || val!.length < 10)
                                      ? "Enter valid Email Address"
                                      : null,
                        ),
                        _buildUsernameMessage(signupController),
                        SizedBox(height: 16),

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
                              (val) => signupController.emailid.value = val!,
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
                        SizedBox(height: 16),

                        IgnorePointer(
                          child: CommonDropdownButton(
                            title: "Select your role",
                            hintText: "Select your role",
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
                          title: "Select your grade",
                          hintText: "Select your grade",
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
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
                          textValue: 'Sign Up',
                          textColor: onprimary,
                          onPressed: () {
                            /*     final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                authController.getOtp(context);
                                authController.showProgressbar.value = true;
                              } */

                            final _username = usernameController.text;
                            final _fullname = usernameController.text;
                            final _email = emailController.text;
                            final _phonenumber = phonenoController.text;
                            final _password = passwordController.text;
                            final _conpassword = conPasswordController.text;
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
                              signupController.emailid.value = _email;
                              // update email to controller
                              signupController.sendSignupOTP(
                                _username,
                                _fullname,
                                _email,
                                _phonenumber,
                                _password,
                                _conpassword,
                                _role!,
                                _grade!,
                                publisher,
                                context,
                              );

                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
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
                                  text: 'Already have an account?  ',
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
                                      text: 'Sign In',
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
                            "By signing up to create an account I accept Eduline’s Terms of Service & Privacy Policy",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant.withAlpha(200),

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
    );
  }

  Widget _buildVerifyOtpForm(BuildContext context) {
    List<TextEditingController> otpFieldsControler = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];

    return SafeArea(
      child: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),

               Align(
                    alignment: Alignment.centerLeft,
                    child: CircularBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Constants.fontFamily,
                      ),
                      children: [
                        TextSpan(
                          text: "We have sent a verification code to Email ",
                        ),
                        TextSpan(
                          text: signupController.emailid.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verification Code',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _textFieldOTP(
                            first: true,
                            last: false,
                            controller: otpFieldsControler[0],
                          ),
                          _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[1],
                          ),
                          _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[2],
                          ),
                          _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[3],
                          ),
                          _textFieldOTP(
                            first: false,
                            last: false,
                            controller: otpFieldsControler[4],
                          ),
                          _textFieldOTP(
                            first: false,
                            last: true,
                            controller: otpFieldsControler[5],
                          ),
                        ],
                      ),
                      /*   Text(
                      forgotPasswordController.statusMessage.value,
                      style: TextStyle(
                          color:
                              forgotPasswordController.statusMessageColor.value,
                          fontWeight: FontWeight.bold),
                    ), */
                      SizedBox(height: 32),
                      CustomGradiantButton(
                        loading: signupController.isLoading.value,
                        buttonColor: primarycolor,
                        textValue: 'Verify',
                        textColor: onprimary,
                        onPressed: () {
                          /*     final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                authController.getOtp(context);
                                authController.showProgressbar.value = true;
                              } */

                          signupController.otp.value = "";
                          otpFieldsControler.forEach((controller) {
                            signupController.otp.value += controller.text;
                          });

                          if (signupController.otp.value.length == 6) {
                            signupController.verifySignupOTP(
                              emailController.text,
                              signupController.otp.value,
                              context,
                            );
                          } else {
                            SnackBarHelper.showFailureSnackBar(
                              context,
                              "Please Enter 6 Digit OTP Sent To Your Email",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                /* SizedBox(
                height: 18,
              ),
              Text(
                "Didn't receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ), */
                SizedBox(height: 16),
                Obx(
                  () => TextButton(
                    onPressed:
                        () =>
                            signupController.resendOTP.value
                                ? signupController.resendSignupOtp(
                                  emailController.text,
                                  context,
                                )
                                // ? null
                                : null,
                    child: Text(
                      signupController.resendOTP.value
                          ? "Resend new code"
                          : "Send Code again in ${signupController.resendAfter} seconds",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
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
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$',
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
        "Please enter a valid Username",
      );
      return false;
    }

    if (_fullname.isEmpty || _fullname.trim().length < 4) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter your valid name",
      );
      return false;
    }

    if (_email.isEmpty || !_isValidEmail(_email)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter a valid Emailid",
      );
      return false;
    }

    if (_phonenumber.isEmpty || !_isValidMobile(_phonenumber)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter a valid Mobile number",
      );
      return false;
    }

    if (_role == null) {
      SnackBarHelper.showFailureSnackBar(context, "Please enter a valid Role");
      return false;
    }

    if (_grade == null) {
      SnackBarHelper.showFailureSnackBar(context, "Please enter a valid Grade");
      return false;
    }

    if (_password.isEmpty || !_isValidPassword(_password)) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Please enter a valid Password",
      );
      return false;
    }

    if (_password != _conpassword) {
      SnackBarHelper.showFailureSnackBar(
        context,
        "Password and Confirm Password do not match",
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
              borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
