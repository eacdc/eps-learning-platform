class SignupOtpResponse {
  final String message;
  final String? email;
  final bool? developmentMode;
  final String? dummyOTP;

  SignupOtpResponse({
    required this.message,
    this.email,
    this.developmentMode,
    this.dummyOTP,
  });

  factory SignupOtpResponse.fromJson(Map<String, dynamic> json) {
    return SignupOtpResponse(
      message: json['message'] ?? '',
      email: json['email'],
      developmentMode: json['developmentMode'],
      dummyOTP: json['dummyOTP'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (email != null) 'email': email,
      if (developmentMode != null) 'developmentMode': developmentMode,
      if (dummyOTP != null) 'dummyOTP': dummyOTP,
    };
  }
}
