class UnifiedScore {
  final bool? success;
  final ScoreData? data;

  UnifiedScore({this.success, this.data});

  factory UnifiedScore.fromJson(Map<String, dynamic> json) {
    return UnifiedScore(
      success: json['success'] as bool?,
      data: json['data'] != null ? ScoreData.fromJson(json['data']) : null,
    );
  }
}

class ScoreData {
  final String? userId;
  final String? timestamp;
  final BasicStats? basic;
  final DetailedStats? detailed;
  final AssessmentData? assessmentData;

  ScoreData({
    this.userId,
    this.timestamp,
    this.basic,
    this.detailed,
    this.assessmentData,
  });

  factory ScoreData.fromJson(Map<String, dynamic> json) {
    return ScoreData(
      userId: json['userId'] as String?,
      timestamp: json['timestamp'] as String?,
      basic: json['basic'] != null ? BasicStats.fromJson(json['basic']) : null,
      detailed:
          json['detailed'] != null
              ? DetailedStats.fromJson(json['detailed'])
              : null,
      assessmentData:
          json['assessment'] != null
              ? AssessmentData.fromJson(json['assessment'])
              : null,
    );
  }
}

class BasicStats {
  final int? booksStarted;
  final int? chaptersCompleted;
  final int? chaptersInProgress;
  final int? quizzesTaken;
  final int? totalQuestionsAnswered;
  final int? totalMarksEarned;
  final int? totalMarksAvailable;
  final double? overallScore;
  final int? totalTimeSpentMinutes;
  final double? totalTimeSpentHours;
  final int? totalPointsEarned;

  BasicStats({
    this.booksStarted,
    this.chaptersCompleted,
    this.chaptersInProgress,
    this.quizzesTaken,
    this.totalQuestionsAnswered,
    this.totalMarksEarned,
    this.totalMarksAvailable,
    this.overallScore,
    this.totalTimeSpentMinutes,
    this.totalTimeSpentHours,
    this.totalPointsEarned,
  });

  factory BasicStats.fromJson(Map<String, dynamic> json) {
    return BasicStats(
      booksStarted: json['booksStarted'] as int?,
      chaptersCompleted: json['chaptersCompleted'] as int?,
      chaptersInProgress: json['chaptersInProgress'] as int?,
      quizzesTaken: json['quizzesTaken'] as int?,
      totalQuestionsAnswered: json['totalQuestionsAnswered'] as int?,
      totalMarksEarned: json['totalMarksEarned'] as int?,
      totalMarksAvailable: json['totalMarksAvailable'] as int?,
      overallScore: (json['overallScore'] as num?)?.toDouble(),
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int?,
      totalTimeSpentHours: (json['totalTimeSpentHours'] as num?)?.toDouble(),
      totalPointsEarned: json['totalPointsEarned'] as int?,
    );
  }
}

class DetailedStats {
  final UserInfo? userInfo;

  DetailedStats({this.userInfo});

  factory DetailedStats.fromJson(Map<String, dynamic> json) {
    return DetailedStats(
      userInfo:
          json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }
}

class UserInfo {
  final String? username;
  final String? fullname;
  final String? grade;
  final String? memberSince;

  UserInfo({this.username, this.fullname, this.grade, this.memberSince});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      grade: json['grade'] as String?,
      memberSince: json['memberSince'] as String?,
    );
  }
}

class AssessmentData {
  final int? totalAssessments;
  final PerformanceMetrics? performanceMetrics;
  final DifficultyAnalysis? difficultyAnalysis;
  final List<SubjectAnalysis>? subjectAnalysis;
  final List<dynamic>? strengths;
  final List<Weakness>? weaknesses;
  final List<String>? recommendations;

  AssessmentData({
    this.totalAssessments,
    this.performanceMetrics,
    this.difficultyAnalysis,
    this.subjectAnalysis,
    this.strengths,
    this.weaknesses,
    this.recommendations,
  });

  factory AssessmentData.fromJson(Map<String, dynamic> json) {
    return AssessmentData(
      totalAssessments: json['totalAssessments'] as int?,
      performanceMetrics:
          json['performanceMetrics'] != null
              ? PerformanceMetrics.fromJson(json['performanceMetrics'])
              : null,
      difficultyAnalysis:
          json['difficultyAnalysis'] != null
              ? DifficultyAnalysis.fromJson(json['difficultyAnalysis'])
              : null,
      subjectAnalysis:
          json['subjectAnalysis'] != null
              ? (json['subjectAnalysis'] as List)
                  .map((e) => SubjectAnalysis.fromJson(e))
                  .toList()
              : null,
      strengths:
          json['strengths'] != null
              ? List<dynamic>.from(json['strengths'])
              : null,
      weaknesses:
          json['weaknesses'] != null
              ? (json['weaknesses'] as List)
                  .map((e) => Weakness.fromJson(e))
                  .toList()
              : null,
      recommendations:
          json['recommendations'] != null
              ? List<String>.from(json['recommendations'])
              : null,
    );
  }
}

class PerformanceMetrics {
  final int? totalQuestions;
  final double? avgScore;
  final double? accuracyRate;
  final double? completionRate;

  PerformanceMetrics({
    this.totalQuestions,
    this.avgScore,
    this.accuracyRate,
    this.completionRate,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      totalQuestions: json['totalQuestions'] as int?,
      avgScore: (json['avgScore'] as num?)?.toDouble(),
      accuracyRate: (json['accuracyRate'] as num?)?.toDouble(),
      completionRate: (json['completionRate'] as num?)?.toDouble(),
    );
  }
}

class DifficultyAnalysis {
  final DifficultyDetail? easy;
  final DifficultyDetail? medium;
  final DifficultyDetail? hard;

  DifficultyAnalysis({this.easy, this.medium, this.hard});

  factory DifficultyAnalysis.fromJson(Map<String, dynamic> json) {
    return DifficultyAnalysis(
      easy:
          json['easy'] != null ? DifficultyDetail.fromJson(json['easy']) : null,
      medium:
          json['medium'] != null
              ? DifficultyDetail.fromJson(json['medium'])
              : null,
      hard:
          json['hard'] != null ? DifficultyDetail.fromJson(json['hard']) : null,
    );
  }
}

class DifficultyDetail {
  final int? attempted;
  final int? correct;
  final double? avgScore;

  DifficultyDetail({this.attempted, this.correct, this.avgScore});

  factory DifficultyDetail.fromJson(Map<String, dynamic> json) {
    return DifficultyDetail(
      attempted: json['attempted'] as int?,
      correct: json['correct'] as int?,
      avgScore: (json['avgScore'] as num?)?.toDouble(),
    );
  }
}

class SubjectAnalysis {
  final String? subject;
  final int? attempted;
  final double? accuracy;
  final double? avgScore;

  SubjectAnalysis({this.subject, this.attempted, this.accuracy, this.avgScore});

  factory SubjectAnalysis.fromJson(Map<String, dynamic> json) {
    return SubjectAnalysis(
      subject: json['subject'] as String?,
      attempted: json['attempted'] as int?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      avgScore: (json['avgScore'] as num?)?.toDouble(),
    );
  }
}

class Weakness {
  final String? subject;
  final int? attempted;
  final double? accuracy;
  final double? avgScore;

  Weakness({this.subject, this.attempted, this.accuracy, this.avgScore});

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      subject: json['subject'] as String?,
      attempted: json['attempted'] as int?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      avgScore: (json['avgScore'] as num?)?.toDouble(),
    );
  }
}
