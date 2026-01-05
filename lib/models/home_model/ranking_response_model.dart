class RankingResponse {
  final bool success;
  final RankingData? data;

  RankingResponse({
    required this.success,
    this.data,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    return RankingResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? RankingData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class RankingData {
  final bool success;
  final UserRanking userRanking;
  final List<RankedUser> usersAbove;
  final List<RankedUser> usersBelow;

  RankingData({
    required this.success,
    required this.userRanking,
    required this.usersAbove,
    required this.usersBelow,
  });

  factory RankingData.fromJson(Map<String, dynamic> json) {
    return RankingData(
      success: json['success'] ?? false,
      userRanking: UserRanking.fromJson(json['userRanking']),
      usersAbove: (json['usersAbove'] as List<dynamic>?)
              ?.map((e) => RankedUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      usersBelow: (json['usersBelow'] as List<dynamic>?)
              ?.map((e) => RankedUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'userRanking': userRanking.toJson(),
      'usersAbove': usersAbove.map((e) => e.toJson()).toList(),
      'usersBelow': usersBelow.map((e) => e.toJson()).toList(),
    };
  }
}

class UserRanking {
  final int rank;
  final int totalUsers;
  final String userId;
  final String username;
  final String fullname;
  final num points;
  final num totalMarksEarned;
  final double quizTimeHours;
  final double learningTimeHours;
  final DateTime lastUpdated;

  UserRanking({
    required this.rank,
    required this.totalUsers,
    required this.userId,
    required this.username,
    required this.fullname,
    required this.points,
    required this.totalMarksEarned,
    required this.quizTimeHours,
    required this.learningTimeHours,
    required this.lastUpdated,
  });

  factory UserRanking.fromJson(Map<String, dynamic> json) {
    return UserRanking(
      rank: json['rank'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      points: json['points'] ?? 0,
      totalMarksEarned: json['totalMarksEarned'] ?? 0,
      quizTimeHours: (json['quizTimeHours'] ?? 0).toDouble(),
      learningTimeHours: (json['learningTimeHours'] ?? 0).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'totalUsers': totalUsers,
      'userId': userId,
      'username': username,
      'fullname': fullname,
      'points': points,
      'totalMarksEarned': totalMarksEarned,
      'quizTimeHours': quizTimeHours,
      'learningTimeHours': learningTimeHours,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class RankedUser {
  final int rank;
  final String userId;
  final String username;
  final String fullname;
  final num points;
  final double quizTimeHours;

  RankedUser({
    required this.rank,
    required this.userId,
    required this.username,
    required this.fullname,
    required this.points,
    required this.quizTimeHours,
  });

  factory RankedUser.fromJson(Map<String, dynamic> json) {
    return RankedUser(
      rank: json['rank'] ?? 0,
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      points: json['points'] ?? 0,
      quizTimeHours: (json['quizTimeHours'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'username': username,
      'fullname': fullname,
      'points': points,
      'quizTimeHours': quizTimeHours,
    };
  }
}