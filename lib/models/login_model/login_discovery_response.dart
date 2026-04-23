class LoginDiscoveryResponse {
  final bool requiresUsernameSelection;
  final String message;
  final List<LoginCandidate> usernames;

  LoginDiscoveryResponse({
    required this.requiresUsernameSelection,
    required this.message,
    required this.usernames,
  });

  factory LoginDiscoveryResponse.fromJson(Map<String, dynamic> json) {
    final usernameList = json["usernames"] as List<dynamic>? ?? [];
    return LoginDiscoveryResponse(
      requiresUsernameSelection: json["requiresUsernameSelection"] ?? false,
      message: json["message"] ?? "",
      usernames:
          usernameList
              .map((item) => LoginCandidate.fromJson(item))
              .toList(),
    );
  }
}

class LoginCandidate {
  final String username;
  final String fullname;
  final String role;

  LoginCandidate({
    required this.username,
    required this.fullname,
    required this.role,
  });

  factory LoginCandidate.fromJson(Map<String, dynamic> json) {
    return LoginCandidate(
      username: json["username"] ?? "",
      fullname: json["fullname"] ?? "",
      role: json["role"] ?? "",
    );
  }
}
