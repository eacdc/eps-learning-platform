class ScoreboardModel {
  final bool? success;
  final ScoreboardData? data;

  ScoreboardModel({this.success, this.data});

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) {
    return ScoreboardModel(
      success: json['success'],
      data: json['data'] != null ? ScoreboardData.fromJson(json['data']) : null,
    );
  }
}

class ScoreboardData {
  final String? userId;
  final QuizSummary? summary;
  final List<Quiz>? quizzesInProgress;
  final List<Quiz>? completedQuizzes;
  final List<dynamic>? achievements;
  final StreakData? streakData;
  final Rankings? rankings;

  ScoreboardData({
    this.userId,
    this.summary,
    this.quizzesInProgress,
    this.completedQuizzes,
    this.achievements,
    this.streakData,
    this.rankings,
  });

  factory ScoreboardData.fromJson(Map<String, dynamic> json) {
    return ScoreboardData(
      userId: json['userId'],
      summary: json['summary'] != null ? QuizSummary.fromJson(json['summary']) : null,
      quizzesInProgress: (json['quizzesInProgress'] as List?)?.map((e) => Quiz.fromJson(e)).toList(),
      completedQuizzes: (json['completedQuizzes'] as List?)?.map((e) => Quiz.fromJson(e)).toList(),
      achievements: json['achievements'],
      streakData: json['streakData'] != null ? StreakData.fromJson(json['streakData']) : null,
      rankings: json['rankings'] != null ? Rankings.fromJson(json['rankings']) : null,
    );
  }
}

class QuizSummary {
  final int? totalQuizzesInProgress;
  final int? totalCompletedQuizzes;
  final double? totalHoursSpent;
  final num? totalPointsEarned;
  final int? currentStreak;
  final int? achievementsUnlocked;

  QuizSummary({
    this.totalQuizzesInProgress,
    this.totalCompletedQuizzes,
    this.totalHoursSpent,
    this.totalPointsEarned,
    this.currentStreak,
    this.achievementsUnlocked,
  });

  factory QuizSummary.fromJson(Map<String, dynamic> json) {
    return QuizSummary(
      totalQuizzesInProgress: json['totalQuizzesInProgress'],
      totalCompletedQuizzes: json['totalCompletedQuizzes'],
      totalHoursSpent: (json['totalHoursSpent'] as num?)?.toDouble(),
      totalPointsEarned: json['totalPointsEarned'],
      currentStreak: json['currentStreak'],
      achievementsUnlocked: json['achievementsUnlocked'],
    );
  }
}

class Quiz {
  final String? chapterId;
  final String? chapterTitle;
  final String? bookTitle;
  final String? subject;
  final String? grade;
  final int? questionsAnswered;
  final int? totalQuestions;
  final int? completionPercentage;
  final num? marksEarned;
  final num? marksAvailable;
  final double? scorePercentage;
  final num? pointsEarned;
  final String? lastAttempted;
  final String? status;

  Quiz({
    this.chapterId,
    this.chapterTitle,
    this.bookTitle,
    this.subject,
    this.grade,
    this.questionsAnswered,
    this.totalQuestions,
    this.completionPercentage,
    this.marksEarned,
    this.marksAvailable,
    this.scorePercentage,
    this.pointsEarned,
    this.lastAttempted,
    this.status,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      grade: json['grade'],
      questionsAnswered: json['questionsAnswered'],
      totalQuestions: json['totalQuestions'],
      completionPercentage: json['completionPercentage'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble(),
      pointsEarned: json['pointsEarned'],
      lastAttempted: json['lastAttempted'],
      status: json['status'],
    );
  }
}

class StreakData {
  final int? currentStreak;
  final int? longestStreak;
  final String? lastActivityDate;

  StreakData({
    this.currentStreak,
    this.longestStreak,
    this.lastActivityDate,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      lastActivityDate: json['lastActivityDate'],
    );
  }
}

class Rankings {
  final dynamic weeklyRank;
  final dynamic monthlyRank;
  final dynamic overallRank;

  Rankings({
    this.weeklyRank,
    this.monthlyRank,
    this.overallRank,
  });

  factory Rankings.fromJson(Map<String, dynamic> json) {
    return Rankings(
      weeklyRank: json['weeklyRank'],
      monthlyRank: json['monthlyRank'],
      overallRank: json['overallRank'],
    );
  }
}
