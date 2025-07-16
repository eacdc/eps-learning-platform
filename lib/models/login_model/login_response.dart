import 'dart:convert';

import 'package:test_your_learing/models/login_model/employee_details.dart';


class LoginResponse {
  final String token;
  final String userId;
  final String name;
  final String role;
  final String grade;
  final String loginOrigin;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.name,
    required this.role,
    required this.grade,
    required this.loginOrigin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"] ?? "",
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      grade: json["grade"] ?? "",
      loginOrigin: json["loginOrigin"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "userId": userId,
      "name": name,
      "role": role,
      "grade": grade,
      "loginOrigin": loginOrigin,
    };
  }
}
