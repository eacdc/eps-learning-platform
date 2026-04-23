class ForgotPasswordVerifyResponse {
  final String message;
  final String email;
  final List<String> usernames;
  final String resetAuthToken;
  final int expiresIn;

  ForgotPasswordVerifyResponse({
    required this.message,
    required this.email,
    required this.usernames,
    required this.resetAuthToken,
    required this.expiresIn,
  });

  factory ForgotPasswordVerifyResponse.fromJson(Map<String, dynamic> json) {
    final rawUsernames = json['usernames'];
    List<String> parsedUsernames = [];
    if (rawUsernames is List) {
      parsedUsernames = rawUsernames.map((e) => e.toString()).toList();
    }
    return ForgotPasswordVerifyResponse(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      usernames: parsedUsernames,
      resetAuthToken: json['resetAuthToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 600,
    );
  }
}
