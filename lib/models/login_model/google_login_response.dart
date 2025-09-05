class GoogleLoginResponse {
  final bool? success;
  final String? message;
  final String? token;
  final User? user;
  final AuthInfo? authInfo;

  GoogleLoginResponse({
    this.success,
    this.message,
    this.token,
    this.user,
    this.authInfo,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      authInfo: json['authInfo'] != null ? AuthInfo.fromJson(json['authInfo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': user?.toJson(),
      'authInfo': authInfo?.toJson(),
    };
  }
}

class User {
  final String? id;
  final String? username;
  final String? fullname;
  final String? email;
  final String? phone;
  final String? role;
  final String? grade;
  final String? authProvider;
  final bool? isEmailVerified;
  final String? googleId;
  final String? createdAt;

  User({
    this.id,
    this.username,
    this.fullname,
    this.email,
    this.phone,
    this.role,
    this.grade,
    this.authProvider,
    this.isEmailVerified,
    this.googleId,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      grade: json['grade'] as String?,
      authProvider: json['authProvider'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      googleId: json['googleId'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'role': role,
      'grade': grade,
      'authProvider': authProvider,
      'isEmailVerified': isEmailVerified,
      'googleId': googleId,
      'createdAt': createdAt,
    };
  }
}

class AuthInfo {
  final String? provider;
  final String? tokenExpiresIn;
  final String? tokenType;

  AuthInfo({
    this.provider,
    this.tokenExpiresIn,
    this.tokenType,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      provider: json['provider'] as String?,
      tokenExpiresIn: json['tokenExpiresIn'] as String?,
      tokenType: json['tokenType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'tokenExpiresIn': tokenExpiresIn,
      'tokenType': tokenType,
    };
  }
}
