class ScoreProgressModel {
  final bool? success;
  final ScoreProgressData? data;

  ScoreProgressModel({this.success, this.data});

  factory ScoreProgressModel.fromJson(Map<String, dynamic> json) {
    return ScoreProgressModel(
      success: json['success'],
      data: json['data'] != null ? ScoreProgressData.fromJson(json['data']) : null,
    );
  }
}

class ScoreProgressData {
  final String? userId;
  final int? booksStarted;
  final int? chaptersCompleted;
  final int? chaptersInProgress;
  final int? quizzesTaken;
  final int? totalQuestionsAnswered;
  final double? overallScore;
  final int? totalMarksEarned;
  final int? totalMarksAvailable;
  final int? totalTimeSpentMinutes;
  final int? totalTimeSpentHours;
  final Breakdown? breakdown;

  ScoreProgressData({
    this.userId,
    this.booksStarted,
    this.chaptersCompleted,
    this.chaptersInProgress,
    this.quizzesTaken,
    this.totalQuestionsAnswered,
    this.overallScore,
    this.totalMarksEarned,
    this.totalMarksAvailable,
    this.totalTimeSpentMinutes,
    this.totalTimeSpentHours,
    this.breakdown,
  });

  factory ScoreProgressData.fromJson(Map<String, dynamic> json) {
    return ScoreProgressData(
      userId: json['userId'],
      booksStarted: json['booksStarted'],
      chaptersCompleted: json['chaptersCompleted'],
      chaptersInProgress: json['chaptersInProgress'],
      quizzesTaken: json['quizzesTaken'],
      totalQuestionsAnswered: json['totalQuestionsAnswered'],
      overallScore: (json['overallScore'] as num?)?.toDouble(),
      totalMarksEarned: json['totalMarksEarned'],
      totalMarksAvailable: json['totalMarksAvailable'],
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'],
      totalTimeSpentHours: json['totalTimeSpentHours'],
      breakdown: json['breakdown'] != null ? Breakdown.fromJson(json['breakdown']) : null,
    );
  }
}

class Breakdown {
  final List<SubjectBreakdown>? bySubject;
  final List<GradeBreakdown>? byGrade;
  final List<PublisherBreakdown>? byPublisher;

  Breakdown({this.bySubject, this.byGrade, this.byPublisher});

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    return Breakdown(
      bySubject: (json['bySubject'] as List?)
          ?.map((e) => SubjectBreakdown.fromJson(e))
          .toList(),
      byGrade: (json['byGrade'] as List?)
          ?.map((e) => GradeBreakdown.fromJson(e))
          .toList(),
      byPublisher: (json['byPublisher'] as List?)
          ?.map((e) => PublisherBreakdown.fromJson(e))
          .toList(),
    );
  }
}

class SubjectBreakdown {
  final String? subject;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final double? percentage;
  final int? chaptersAttempted;

  SubjectBreakdown({
    this.subject,
    this.questionsAnswered,
    this.marksEarned,
    this.marksAvailable,
    this.percentage,
    this.chaptersAttempted,
  });

  factory SubjectBreakdown.fromJson(Map<String, dynamic> json) {
    return SubjectBreakdown(
      subject: json['subject'],
      questionsAnswered: json['questionsAnswered'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      percentage: (json['percentage'] as num?)?.toDouble(),
      chaptersAttempted: json['chaptersAttempted'],
    );
  }
}

class GradeBreakdown {
  final String? grade;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final double? percentage;
  final int? booksAttempted;

  GradeBreakdown({
    this.grade,
    this.questionsAnswered,
    this.marksEarned,
    this.marksAvailable,
    this.percentage,
    this.booksAttempted,
  });

  factory GradeBreakdown.fromJson(Map<String, dynamic> json) {
    return GradeBreakdown(
      grade: json['grade'],
      questionsAnswered: json['questionsAnswered'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      percentage: (json['percentage'] as num?)?.toDouble(),
      booksAttempted: json['booksAttempted'],
    );
  }
}

class PublisherBreakdown {
  final String? publisher;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final double? percentage;
  final int? booksAttempted;

  PublisherBreakdown({
    this.publisher,
    this.questionsAnswered,
    this.marksEarned,
    this.marksAvailable,
    this.percentage,
    this.booksAttempted,
  });

  factory PublisherBreakdown.fromJson(Map<String, dynamic> json) {
    return PublisherBreakdown(
      publisher: json['publisher'],
      questionsAnswered: json['questionsAnswered'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      percentage: (json['percentage'] as num?)?.toDouble(),
      booksAttempted: json['booksAttempted'],
    );
  }
}
