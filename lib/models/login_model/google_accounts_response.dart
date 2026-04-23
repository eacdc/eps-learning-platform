class GoogleAccountsResponse {
  final String email;
  final List<GoogleAccountUser> users;

  GoogleAccountsResponse({required this.email, required this.users});

  factory GoogleAccountsResponse.fromJson(Map<String, dynamic> json) {
    final usersList = json["users"] as List<dynamic>? ?? [];
    return GoogleAccountsResponse(
      email: json["email"] ?? "",
      users: usersList.map((item) => GoogleAccountUser.fromJson(item)).toList(),
    );
  }
}

class GoogleAccountUser {
  final String username;
  final String fullname;
  final String role;
  final String grade;

  GoogleAccountUser({
    required this.username,
    required this.fullname,
    required this.role,
    required this.grade,
  });

  factory GoogleAccountUser.fromJson(Map<String, dynamic> json) {
    return GoogleAccountUser(
      username: json["username"] ?? "",
      fullname: json["fullname"] ?? "",
      role: json["role"] ?? "",
      grade: json["grade"] ?? "",
    );
  }
}
