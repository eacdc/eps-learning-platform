class RecentActivityModel {
  final bool? success;
  final UserData? data;

  RecentActivityModel({this.success, this.data});

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      success: json['success'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String? userId;
  final String? timeframe;
  final List<Book>? recentBooks;
  final int? totalChaptersCompleted;
  final int? totalChaptersInProgress;
  final double? overallProgressPercentage;
  final int? totalQuestionsAnswered;
  final List<RecentActivity>? recentActivities;
  final QuizData? quizData;
  final ActivitySummary? activitySummary;

  UserData({
    this.userId,
    this.timeframe,
    this.recentBooks,
    this.totalChaptersCompleted,
    this.totalChaptersInProgress,
    this.overallProgressPercentage,
    this.totalQuestionsAnswered,
    this.recentActivities,
    this.quizData,
    this.activitySummary,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      timeframe: json['timeframe'],
      recentBooks: (json['recentBooks'] as List?)
          ?.map((e) => Book.fromJson(e))
          .toList(),
      totalChaptersCompleted: json['totalChaptersCompleted'],
      totalChaptersInProgress: json['totalChaptersInProgress'],
      overallProgressPercentage: (json['overallProgressPercentage'] as num?)?.toDouble(),
      totalQuestionsAnswered: json['totalQuestionsAnswered'],
      recentActivities: (json['recentActivities'] as List?)
          ?.map((e) => RecentActivity.fromJson(e))
          .toList(),
      quizData: json['quizData'] != null
          ? QuizData.fromJson(json['quizData'])
          : null,
      activitySummary: json['activitySummary'] != null
          ? ActivitySummary.fromJson(json['activitySummary'])
          : null,
    );
  }
}

class Book {
  final String? bookId;
  final String? title;
  final String? subject;
  final String? grade;
  final String? bookCoverImgLink;
  final int? chaptersAttempted;
  final int? chaptersCompleted;
  final int? questionsAnswered;
  final num? marksEarned;
  final num? marksAvailable;
  final double? progressPercentage;
  final String? lastActivity;

  Book({
    this.bookId,
    this.title,
    this.subject,
    this.grade,
    this.bookCoverImgLink,
    this.chaptersAttempted,
    this.chaptersCompleted,
    this.questionsAnswered,
    this.marksEarned,
    this.marksAvailable,
    this.progressPercentage,
    this.lastActivity,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'],
      title: json['title'],
      subject: json['subject'],
      grade: json['grade'],
      bookCoverImgLink: json['bookCoverImgLink'],
      chaptersAttempted: json['chaptersAttempted'],
      chaptersCompleted: json['chaptersCompleted'],
      questionsAnswered: json['questionsAnswered'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble(),
      lastActivity: json['lastActivity'],
    );
  }
}

class RecentActivity {
  final String? type;
  final String? chapterId;
  final String? chapterTitle;
  final String? bookTitle;
  final String? subject;
  final String? grade;
  final int? questionsAnswered;
  final int? totalQuestions;
  final num? marksEarned;
  final num? marksAvailable;
  final double? scorePercentage;
  final String? timestamp;
  final num? pointsEarned;

  RecentActivity({
    this.type,
    this.chapterId,
    this.chapterTitle,
    this.bookTitle,
    this.subject,
    this.grade,
    this.questionsAnswered,
    this.totalQuestions,
    this.marksEarned,
    this.marksAvailable,
    this.scorePercentage,
    this.timestamp,
    this.pointsEarned,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      type: json['type'],
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      grade: json['grade'],
      questionsAnswered: json['questionsAnswered'],
      totalQuestions: json['totalQuestions'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble(),
      timestamp: json['timestamp'],
      pointsEarned: json['pointsEarned'],
    );
  }
}

class QuizData {
  final int? totalQuizzesTaken;
  final double? avgQuizScore;
  final num? totalPointsEarned;

  QuizData({
    this.totalQuizzesTaken,
    this.avgQuizScore,
    this.totalPointsEarned,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      totalQuizzesTaken: json['totalQuizzesTaken'],
      avgQuizScore: (json['avgQuizScore'] as num?)?.toDouble(),
      totalPointsEarned: json['totalPointsEarned'],
    );
  }
}

class ActivitySummary {
  final int? totalActivities;
  final int? quizActivities;
  final int? chapterVisits;
  final String? mostActiveDay;

  ActivitySummary({
    this.totalActivities,
    this.quizActivities,
    this.chapterVisits,
    this.mostActiveDay,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      totalActivities: json['totalActivities'],
      quizActivities: json['quizActivities'],
      chapterVisits: json['chapterVisits'],
      mostActiveDay: json['mostActiveDay'],
    );
  }
}
