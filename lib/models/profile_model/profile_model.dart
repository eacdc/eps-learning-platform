class UserProfile {
  final String id;
  final String username;
  final String fullname;
  final String phone;
  final String email;
  final String grade;
  final String publisher;
  final String role;
  final String createdAt;
  final String profilePicture;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.grade,
    required this.publisher,
    required this.role,
    required this.createdAt,
    required this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      grade: json['grade'] ?? '',
      publisher: json['publisher'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'grade': grade,
      'publisher': publisher,
      'role': role,
      'createdAt': createdAt,
      'profilePicture': profilePicture,
    };
  }
}
