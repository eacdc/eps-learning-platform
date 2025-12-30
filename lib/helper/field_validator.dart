class FieldValidators {
  static bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static bool isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  static bool isValidPassword(String password) {
    // special character optional
    return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=<>?/\\[\]{}|~`-]{8,}$',
    ).hasMatch(password);
  }

  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9._]{2,}$').hasMatch(username);
  }
}
