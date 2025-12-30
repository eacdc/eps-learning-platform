class UnifiedScoreAll {
  final bool success;
  final UnifiedScoreData? data;

  UnifiedScoreAll({
    required this.success,
    this.data,
  });

  factory UnifiedScoreAll.fromJson(Map<String, dynamic> json) {
    return UnifiedScoreAll(
      success: json['success'] ?? false,
      data: json['data'] != null ? UnifiedScoreData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class UnifiedScoreData {
  final String? userId;
  final String? timestamp;
  final ScoreFilters? filters;
  final BasicStats? basic;
  final DetailedStats? detailed;
  final RecentActivity? recent;
  final Scoreboard? scoreboard;
  final Assessment? assessment;
  final Trends? trends;

  UnifiedScoreData({
    this.userId,
    this.timestamp,
    this.filters,
    this.basic,
    this.detailed,
    this.recent,
    this.scoreboard,
    this.assessment,
    this.trends,
  });

  factory UnifiedScoreData.fromJson(Map<String, dynamic> json) {
    return UnifiedScoreData(
      userId: json['userId'],
      timestamp: json['timestamp'],
      filters: json['filters'] != null ? ScoreFilters.fromJson(json['filters']) : null,
      basic: json['basic'] != null ? BasicStats.fromJson(json['basic']) : null,
      detailed: json['detailed'] != null ? DetailedStats.fromJson(json['detailed']) : null,
      recent: json['recent'] != null ? RecentActivity.fromJson(json['recent']) : null,
      scoreboard: json['scoreboard'] != null ? Scoreboard.fromJson(json['scoreboard']) : null,
      assessment: json['assessment'] != null ? Assessment.fromJson(json['assessment']) : null,
      trends: json['trends'] != null ? Trends.fromJson(json['trends']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'timestamp': timestamp,
      'filters': filters?.toJson(),
      'basic': basic?.toJson(),
      'detailed': detailed?.toJson(),
      'recent': recent?.toJson(),
      'scoreboard': scoreboard?.toJson(),
      'assessment': assessment?.toJson(),
      'trends': trends?.toJson(),
    };
  }
}

class ScoreFilters {
  final DateRange? dateRange;

  ScoreFilters({this.dateRange});

  factory ScoreFilters.fromJson(Map<String, dynamic> json) {
    return ScoreFilters(
      dateRange: json['dateRange'] != null ? DateRange.fromJson(json['dateRange']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateRange': dateRange?.toJson(),
    };
  }
}

class DateRange {
  final String? start;
  final String? end;

  DateRange({this.start, this.end});

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}

class BasicStats {
  final int? booksStarted;
  final int? chaptersCompleted;
  final int? chaptersInProgress;
  final int? chaptersNotStarted;
  final int? totalChaptersInBooks;
  final int? quizzesTaken;
  final int? totalQuestionsAnswered;
  final int? totalMarksEarned;
  final int? totalMarksAvailable;
  final num? overallScore;
  final int? totalTimeSpentMinutes;
  final num? totalTimeSpentHours;
  final int? quizTimeSpentMinutes;
  final num? quizTimeSpentHours;
  final int? learningTimeSpentMinutes;
  final num? learningTimeSpentHours;
  final int? totalPointsEarned;
  final int? points;

  BasicStats({
    this.booksStarted,
    this.chaptersCompleted,
    this.chaptersInProgress,
    this.chaptersNotStarted,
    this.totalChaptersInBooks,
    this.quizzesTaken,
    this.totalQuestionsAnswered,
    this.totalMarksEarned,
    this.totalMarksAvailable,
    this.overallScore,
    this.totalTimeSpentMinutes,
    this.totalTimeSpentHours,
    this.quizTimeSpentMinutes,
    this.quizTimeSpentHours,
    this.learningTimeSpentMinutes,
    this.learningTimeSpentHours,
    this.totalPointsEarned,
    this.points,
  });

  factory BasicStats.fromJson(Map<String, dynamic> json) {
    return BasicStats(
      booksStarted: json['booksStarted'],
      chaptersCompleted: json['chaptersCompleted'],
      chaptersInProgress: json['chaptersInProgress'],
      chaptersNotStarted: json['chaptersNotStarted'],
      totalChaptersInBooks: json['totalChaptersInBooks'],
      quizzesTaken: json['quizzesTaken'],
      totalQuestionsAnswered: json['totalQuestionsAnswered'],
      totalMarksEarned: json['totalMarksEarned'],
      totalMarksAvailable: json['totalMarksAvailable'],
      overallScore: json['overallScore'],
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'],
      totalTimeSpentHours: json['totalTimeSpentHours'],
      quizTimeSpentMinutes: json['quizTimeSpentMinutes'],
      quizTimeSpentHours: json['quizTimeSpentHours'],
      learningTimeSpentMinutes: json['learningTimeSpentMinutes'],
      learningTimeSpentHours: json['learningTimeSpentHours'],
      totalPointsEarned: json['totalPointsEarned'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booksStarted': booksStarted,
      'chaptersCompleted': chaptersCompleted,
      'chaptersInProgress': chaptersInProgress,
      'chaptersNotStarted': chaptersNotStarted,
      'totalChaptersInBooks': totalChaptersInBooks,
      'quizzesTaken': quizzesTaken,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'totalMarksEarned': totalMarksEarned,
      'totalMarksAvailable': totalMarksAvailable,
      'overallScore': overallScore,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'totalTimeSpentHours': totalTimeSpentHours,
      'quizTimeSpentMinutes': quizTimeSpentMinutes,
      'quizTimeSpentHours': quizTimeSpentHours,
      'learningTimeSpentMinutes': learningTimeSpentMinutes,
      'learningTimeSpentHours': learningTimeSpentHours,
      'totalPointsEarned': totalPointsEarned,
      'points': points,
    };
  }
}

class DetailedStats {
  final UserInfo? userInfo;
  final ChapterDetails? chapterDetails;
  final Breakdown? breakdown;

  DetailedStats({
    this.userInfo,
    this.chapterDetails,
    this.breakdown,
  });

  factory DetailedStats.fromJson(Map<String, dynamic> json) {
    return DetailedStats(
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
      chapterDetails: json['chapterDetails'] != null ? ChapterDetails.fromJson(json['chapterDetails']) : null,
      breakdown: json['breakdown'] != null ? Breakdown.fromJson(json['breakdown']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userInfo': userInfo?.toJson(),
      'chapterDetails': chapterDetails?.toJson(),
      'breakdown': breakdown?.toJson(),
    };
  }
}

class UserInfo {
  final String? username;
  final String? fullname;
  final String? grade;
  final String? memberSince;

  UserInfo({
    this.username,
    this.fullname,
    this.grade,
    this.memberSince,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      fullname: json['fullname'],
      grade: json['grade'],
      memberSince: json['memberSince'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'grade': grade,
      'memberSince': memberSince,
    };
  }
}

class ChapterDetails {
  final List<ChapterProgress>? completed;
  final List<ChapterProgress>? inProgress;

  ChapterDetails({
    this.completed,
    this.inProgress,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    return ChapterDetails(
      completed: json['completed'] != null
          ? (json['completed'] as List<dynamic>)
              .map((e) => ChapterProgress.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      inProgress: json['inProgress'] != null
          ? (json['inProgress'] as List<dynamic>)
              .map((e) => ChapterProgress.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completed': completed?.map((e) => e.toJson()).toList(),
      'inProgress': inProgress?.map((e) => e.toJson()).toList(),
    };
  }
}

class ChapterProgress {
  final String? id;
  final String? title;
  final String? bookId;
  final String? bookTitle;
  final String? subject;
  final int? questionsAnswered;
  final int? totalQuestions;
  final num? completionPercentage;
  final int? marksEarned;
  final int? marksAvailable;
  final num? scorePercentage;
  final String? sessionStatus;
  final int? sessionId;
  final String? lastAttempted;

  ChapterProgress({
    this.id,
    this.title,
    this.bookId,
    this.bookTitle,
    this.subject,
    this.questionsAnswered,
    this.totalQuestions,
    this.completionPercentage,
    this.marksEarned,
    this.marksAvailable,
    this.scorePercentage,
    this.sessionStatus,
    this.sessionId,
    this.lastAttempted,
  });

  factory ChapterProgress.fromJson(Map<String, dynamic> json) {
    return ChapterProgress(
      id: json['id'],
      title: json['title'],
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      questionsAnswered: json['questionsAnswered'],
      totalQuestions: json['totalQuestions'],
      completionPercentage: json['completionPercentage'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      scorePercentage: json['scorePercentage'],
      sessionStatus: json['sessionStatus'],
      sessionId: json['sessionId'],
      lastAttempted: json['lastAttempted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'subject': subject,
      'questionsAnswered': questionsAnswered,
      'totalQuestions': totalQuestions,
      'completionPercentage': completionPercentage,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'scorePercentage': scorePercentage,
      'sessionStatus': sessionStatus,
      'sessionId': sessionId,
      'lastAttempted': lastAttempted,
    };
  }
}

class Breakdown {
  final List<SubjectBreakdown>? bySubject;
  final List<GradeBreakdown>? byGrade;
  final List<PublisherBreakdown>? byPublisher;

  Breakdown({
    this.bySubject,
    this.byGrade,
    this.byPublisher,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    return Breakdown(
      bySubject: json['bySubject'] != null
          ? (json['bySubject'] as List<dynamic>)
              .map((e) => SubjectBreakdown.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      byGrade: json['byGrade'] != null
          ? (json['byGrade'] as List<dynamic>)
              .map((e) => GradeBreakdown.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      byPublisher: json['byPublisher'] != null
          ? (json['byPublisher'] as List<dynamic>)
              .map((e) => PublisherBreakdown.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bySubject': bySubject?.map((e) => e.toJson()).toList(),
      'byGrade': byGrade?.map((e) => e.toJson()).toList(),
      'byPublisher': byPublisher?.map((e) => e.toJson()).toList(),
    };
  }
}

class SubjectBreakdown {
  final String? subject;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final num? percentage;
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
      percentage: json['percentage'],
      chaptersAttempted: json['chaptersAttempted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'questionsAnswered': questionsAnswered,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'percentage': percentage,
      'chaptersAttempted': chaptersAttempted,
    };
  }
}

class GradeBreakdown {
  final String? grade;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final num? percentage;
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
      percentage: json['percentage'],
      booksAttempted: json['booksAttempted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade': grade,
      'questionsAnswered': questionsAnswered,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'percentage': percentage,
      'booksAttempted': booksAttempted,
    };
  }
}

class PublisherBreakdown {
  final String? publisher;
  final int? questionsAnswered;
  final int? marksEarned;
  final int? marksAvailable;
  final num? percentage;
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
      percentage: json['percentage'],
      booksAttempted: json['booksAttempted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publisher': publisher,
      'questionsAnswered': questionsAnswered,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'percentage': percentage,
      'booksAttempted': booksAttempted,
    };
  }
}

class RecentActivity {
  final String? timeframe;
  final List<Activity>? activities;
  final ActivitySummary? summary;

  RecentActivity({
    this.timeframe,
    this.activities,
    this.summary,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      timeframe: json['timeframe'],
      activities: json['activities'] != null
          ? (json['activities'] as List<dynamic>)
              .map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      summary: json['summary'] != null ? ActivitySummary.fromJson(json['summary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeframe': timeframe,
      'activities': activities?.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
    };
  }
}

class Activity {
  final String? type;
  final String? chapterId;
  final String? chapterTitle;
  final String? bookTitle;
  final String? subject;
  final int? questionsAnswered;
  final int? totalQuestions;
  final int? marksEarned;
  final int? marksAvailable;
  final num? scorePercentage;
  final int? messageCount;
  final int? sessionId;
  final String? sessionStatus;
  final String? timestamp;
  final String? bookCoverImgLink;
  final int? pointsEarned;

  Activity({
    this.type,
    this.chapterId,
    this.chapterTitle,
    this.bookTitle,
    this.subject,
    this.questionsAnswered,
    this.totalQuestions,
    this.marksEarned,
    this.marksAvailable,
    this.scorePercentage,
    this.messageCount,
    this.sessionId,
    this.sessionStatus,
    this.timestamp,
    this.bookCoverImgLink,
    this.pointsEarned,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: json['type'],
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      questionsAnswered: json['questionsAnswered'],
      totalQuestions: json['totalQuestions'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      scorePercentage: json['scorePercentage'],
      messageCount: json['messageCount'],
      sessionId: json['sessionId'],
      sessionStatus: json['sessionStatus'],
      timestamp: json['timestamp'],
      bookCoverImgLink: json['bookCoverImgLink'],
      pointsEarned: json['pointsEarned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'bookTitle': bookTitle,
      'subject': subject,
      'questionsAnswered': questionsAnswered,
      'totalQuestions': totalQuestions,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'scorePercentage': scorePercentage,
      'messageCount': messageCount,
      'sessionId': sessionId,
      'sessionStatus': sessionStatus,
      'timestamp': timestamp,
      'bookCoverImgLink': bookCoverImgLink,
      'pointsEarned': pointsEarned,
    };
  }
}

class ActivitySummary {
  final int? totalActivities;
  final int? quizActivities;
  final int? chapterVisits;
  final int? totalPointsEarned;

  ActivitySummary({
    this.totalActivities,
    this.quizActivities,
    this.chapterVisits,
    this.totalPointsEarned,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      totalActivities: json['totalActivities'],
      quizActivities: json['quizActivities'],
      chapterVisits: json['chapterVisits'],
      totalPointsEarned: json['totalPointsEarned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalActivities': totalActivities,
      'quizActivities': quizActivities,
      'chapterVisits': chapterVisits,
      'totalPointsEarned': totalPointsEarned,
    };
  }
}

class Scoreboard {
  final List<QuizScore>? completedQuizzes;
  final List<QuizScore>? quizzesInProgress;
  final int? totalPointsEarned;
  final int? totalTimeSpentMinutes;
  final num? totalHoursSpent;
  final int? quizTimeSpentMinutes;
  final num? quizTimeSpentHours;
  final int? learningTimeSpentMinutes;
  final num? learningTimeSpentHours;
  final StreakData? streakData;
  final ScoreboardSummary? summary;

  Scoreboard({
    this.completedQuizzes,
    this.quizzesInProgress,
    this.totalPointsEarned,
    this.totalTimeSpentMinutes,
    this.totalHoursSpent,
    this.quizTimeSpentMinutes,
    this.quizTimeSpentHours,
    this.learningTimeSpentMinutes,
    this.learningTimeSpentHours,
    this.streakData,
    this.summary,
  });

  factory Scoreboard.fromJson(Map<String, dynamic> json) {
    return Scoreboard(
      completedQuizzes: json['completedQuizzes'] != null
          ? (json['completedQuizzes'] as List<dynamic>)
              .map((e) => QuizScore.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      quizzesInProgress: json['quizzesInProgress'] != null
          ? (json['quizzesInProgress'] as List<dynamic>)
              .map((e) => QuizScore.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      totalPointsEarned: json['totalPointsEarned'],
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'],
      totalHoursSpent: json['totalHoursSpent'],
      quizTimeSpentMinutes: json['quizTimeSpentMinutes'],
      quizTimeSpentHours: json['quizTimeSpentHours'],
      learningTimeSpentMinutes: json['learningTimeSpentMinutes'],
      learningTimeSpentHours: json['learningTimeSpentHours'],
      streakData: json['streakData'] != null ? StreakData.fromJson(json['streakData']) : null,
      summary: json['summary'] != null ? ScoreboardSummary.fromJson(json['summary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedQuizzes': completedQuizzes?.map((e) => e.toJson()).toList(),
      'quizzesInProgress': quizzesInProgress?.map((e) => e.toJson()).toList(),
      'totalPointsEarned': totalPointsEarned,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'totalHoursSpent': totalHoursSpent,
      'quizTimeSpentMinutes': quizTimeSpentMinutes,
      'quizTimeSpentHours': quizTimeSpentHours,
      'learningTimeSpentMinutes': learningTimeSpentMinutes,
      'learningTimeSpentHours': learningTimeSpentHours,
      'streakData': streakData?.toJson(),
      'summary': summary?.toJson(),
    };
  }
}

class QuizScore {
  final String? chapterId;
  final String? chapterTitle;
  final String? bookTitle;
  final String? subject;
  final int? questionsAnswered;
  final int? totalQuestions;
  final num? completionPercentage;
  final int? marksEarned;
  final int? marksAvailable;
  final num? scorePercentage;
  final int? pointsEarned;
  final int? sessionId;
  final String? sessionStatus;
  final String? startSessionAfter;
  final String? lastAttempted;
  final String? status;

  QuizScore({
    this.chapterId,
    this.chapterTitle,
    this.bookTitle,
    this.subject,
    this.questionsAnswered,
    this.totalQuestions,
    this.completionPercentage,
    this.marksEarned,
    this.marksAvailable,
    this.scorePercentage,
    this.pointsEarned,
    this.sessionId,
    this.sessionStatus,
    this.startSessionAfter,
    this.lastAttempted,
    this.status,
  });

  factory QuizScore.fromJson(Map<String, dynamic> json) {
    return QuizScore(
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      questionsAnswered: json['questionsAnswered'],
      totalQuestions: json['totalQuestions'],
      completionPercentage: json['completionPercentage'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      scorePercentage: json['scorePercentage'],
      pointsEarned: json['pointsEarned'],
      sessionId: json['sessionId'],
      sessionStatus: json['sessionStatus'],
      startSessionAfter: json['startSessionAfter'],
      lastAttempted: json['lastAttempted'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'bookTitle': bookTitle,
      'subject': subject,
      'questionsAnswered': questionsAnswered,
      'totalQuestions': totalQuestions,
      'completionPercentage': completionPercentage,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'scorePercentage': scorePercentage,
      'pointsEarned': pointsEarned,
      'sessionId': sessionId,
      'sessionStatus': sessionStatus,
      'startSessionAfter': startSessionAfter,
      'lastAttempted': lastAttempted,
      'status': status,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate,
    };
  }
}

class ScoreboardSummary {
  final int? totalQuizzes;
  final int? completedCount;
  final int? inProgressCount;
  final int? notStarted;
  final num? averageScore;

  ScoreboardSummary({
    this.totalQuizzes,
    this.completedCount,
    this.inProgressCount,
    this.notStarted,
    this.averageScore,
  });

  factory ScoreboardSummary.fromJson(Map<String, dynamic> json) {
    return ScoreboardSummary(
      totalQuizzes: json['totalQuizzes'],
      completedCount: json['completedCount'],
      inProgressCount: json['inProgressCount'],
      notStarted: json['notStarted'],
      averageScore: json['averageScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuizzes': totalQuizzes,
      'completedCount': completedCount,
      'inProgressCount': inProgressCount,
      'averageScore': averageScore,
    };
  }
}

class Assessment {
  final int? totalAssessments;
  final PerformanceMetrics? performanceMetrics;
  final DifficultyAnalysis? difficultyAnalysis;
  final List<SubjectAnalysis>? subjectAnalysis;
  final List<SubjectAnalysis>? strengths;
  final List<SubjectAnalysis>? weaknesses;
  final List<String>? recommendations;

  Assessment({
    this.totalAssessments,
    this.performanceMetrics,
    this.difficultyAnalysis,
    this.subjectAnalysis,
    this.strengths,
    this.weaknesses,
    this.recommendations,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      totalAssessments: json['totalAssessments'],
      performanceMetrics: json['performanceMetrics'] != null
          ? PerformanceMetrics.fromJson(json['performanceMetrics'])
          : null,
      difficultyAnalysis: json['difficultyAnalysis'] != null
          ? DifficultyAnalysis.fromJson(json['difficultyAnalysis'])
          : null,
      subjectAnalysis: json['subjectAnalysis'] != null
          ? (json['subjectAnalysis'] as List<dynamic>)
              .map((e) => SubjectAnalysis.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      strengths: json['strengths'] != null
          ? (json['strengths'] as List<dynamic>)
              .map((e) => SubjectAnalysis.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      weaknesses: json['weaknesses'] != null
          ? (json['weaknesses'] as List<dynamic>)
              .map((e) => SubjectAnalysis.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAssessments': totalAssessments,
      'performanceMetrics': performanceMetrics?.toJson(),
      'difficultyAnalysis': difficultyAnalysis?.toJson(),
      'subjectAnalysis': subjectAnalysis?.map((e) => e.toJson()).toList(),
      'strengths': strengths?.map((e) => e.toJson()).toList(),
      'weaknesses': weaknesses?.map((e) => e.toJson()).toList(),
      'recommendations': recommendations,
    };
  }
}

class PerformanceMetrics {
  final int? totalQuestions;
  final num? avgScore;
  final num? accuracyRate;
  final num? completionRate;

  PerformanceMetrics({
    this.totalQuestions,
    this.avgScore,
    this.accuracyRate,
    this.completionRate,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      totalQuestions: json['totalQuestions'],
      avgScore: json['avgScore'],
      accuracyRate: json['accuracyRate'],
      completionRate: json['completionRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'avgScore': avgScore,
      'accuracyRate': accuracyRate,
      'completionRate': completionRate,
    };
  }
}

class DifficultyAnalysis {
  final DifficultyLevel? easy;
  final DifficultyLevel? medium;
  final DifficultyLevel? hard;

  DifficultyAnalysis({
    this.easy,
    this.medium,
    this.hard,
  });

  factory DifficultyAnalysis.fromJson(Map<String, dynamic> json) {
    return DifficultyAnalysis(
      easy: json['easy'] != null ? DifficultyLevel.fromJson(json['easy']) : null,
      medium: json['medium'] != null ? DifficultyLevel.fromJson(json['medium']) : null,
      hard: json['hard'] != null ? DifficultyLevel.fromJson(json['hard']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'easy': easy?.toJson(),
      'medium': medium?.toJson(),
      'hard': hard?.toJson(),
    };
  }
}

class DifficultyLevel {
  final int? attempted;
  final int? correct;
  final num? avgScore;

  DifficultyLevel({
    this.attempted,
    this.correct,
    this.avgScore,
  });

  factory DifficultyLevel.fromJson(Map<String, dynamic> json) {
    return DifficultyLevel(
      attempted: json['attempted'],
      correct: json['correct'],
      avgScore: json['avgScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempted': attempted,
      'correct': correct,
      'avgScore': avgScore,
    };
  }
}

class SubjectAnalysis {
  final String? subject;
  final int? attempted;
  final num? accuracy;
  final num? avgScore;

  SubjectAnalysis({
    this.subject,
    this.attempted,
    this.accuracy,
    this.avgScore,
  });

  factory SubjectAnalysis.fromJson(Map<String, dynamic> json) {
    return SubjectAnalysis(
      subject: json['subject'],
      attempted: json['attempted'],
      accuracy: json['accuracy'],
      avgScore: json['avgScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'attempted': attempted,
      'accuracy': accuracy,
      'avgScore': avgScore,
    };
  }
}

class Trends {
  final List<SubjectWiseTrend>? subjectWise;
  final List<BookWiseTrend>? bookWise;
  final List<ChapterWiseTrend>? chapterWise;
  final TrendFilters? filters;

  Trends({
    this.subjectWise,
    this.bookWise,
    this.chapterWise,
    this.filters,
  });

  factory Trends.fromJson(Map<String, dynamic> json) {
    return Trends(
      subjectWise: json['subjectWise'] != null
          ? (json['subjectWise'] as List<dynamic>)
              .map((e) => SubjectWiseTrend.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      bookWise: json['bookWise'] != null
          ? (json['bookWise'] as List<dynamic>)
              .map((e) => BookWiseTrend.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      chapterWise: json['chapterWise'] != null
          ? (json['chapterWise'] as List<dynamic>)
              .map((e) => ChapterWiseTrend.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      filters: json['filters'] != null ? TrendFilters.fromJson(json['filters']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectWise': subjectWise?.map((e) => e.toJson()).toList(),
      'bookWise': bookWise?.map((e) => e.toJson()).toList(),
      'chapterWise': chapterWise?.map((e) => e.toJson()).toList(),
      'filters': filters?.toJson(),
    };
  }
}

class SubjectWiseTrend {
  final String? subject;
  final num? score;
  final num? totalQuizHours;
  final num? totalLearningHours;
  final int? marksEarned;
  final int? marksAvailable;
  final int? questionsAnswered;
  final int? quizzes;

  SubjectWiseTrend({
    this.subject,
    this.score,
    this.totalQuizHours,
    this.totalLearningHours,
    this.marksEarned,
    this.marksAvailable,
    this.questionsAnswered,
    this.quizzes,
  });

  factory SubjectWiseTrend.fromJson(Map<String, dynamic> json) {
    return SubjectWiseTrend(
      subject: json['subject'],
      score: json['score'],
      totalQuizHours: json['totalQuizHours'],
      totalLearningHours: json['totalLearningHours'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      questionsAnswered: json['questionsAnswered'],
      quizzes: json['quizzes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'score': score,
      'totalQuizHours': totalQuizHours,
      'totalLearningHours': totalLearningHours,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'questionsAnswered': questionsAnswered,
      'quizzes': quizzes,
    };
  }
}

class BookWiseTrend {
  final String? bookId;
  final String? bookTitle;
  final String? subject;
  final num? score;
  final num? totalQuizHours;
  final num? totalLearningHours;
  final int? marksEarned;
  final int? marksAvailable;
  final int? questionsAnswered;
  final int? quizzes;

  BookWiseTrend({
    this.bookId,
    this.bookTitle,
    this.subject,
    this.score,
    this.totalQuizHours,
    this.totalLearningHours,
    this.marksEarned,
    this.marksAvailable,
    this.questionsAnswered,
    this.quizzes,
  });

  factory BookWiseTrend.fromJson(Map<String, dynamic> json) {
    return BookWiseTrend(
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      subject: json['subject'],
      score: json['score'],
      totalQuizHours: json['totalQuizHours'],
      totalLearningHours: json['totalLearningHours'],
      marksEarned: json['marksEarned'],
      marksAvailable: json['marksAvailable'],
      questionsAnswered: json['questionsAnswered'],
      quizzes: json['quizzes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'subject': subject,
      'score': score,
      'totalQuizHours': totalQuizHours,
      'totalLearningHours': totalLearningHours,
      'marksEarned': marksEarned,
      'marksAvailable': marksAvailable,
      'questionsAnswered': questionsAnswered,
      'quizzes': quizzes,
    };
  }
}

class ChapterWiseTrend {
  final String? chapterId;
  final String? chapterTitle;
  final String? bookId;
  final String? subject;
  final List<dynamic>? sessions;

  ChapterWiseTrend({
    this.chapterId,
    this.chapterTitle,
    this.bookId,
    this.subject,
    this.sessions,
  });

  factory ChapterWiseTrend.fromJson(Map<String, dynamic> json) {
    return ChapterWiseTrend(
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      bookId: json['bookId'],
      subject: json['subject'],
      sessions: json['sessions'] != null ? List<dynamic>.from(json['sessions']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'bookId': bookId,
      'subject': subject,
      'sessions': sessions,
    };
  }
}

class TrendFilters {
  final String? appliedSubject;
  final String? appliedChapter;
  final String? note;

  TrendFilters({
    this.appliedSubject,
    this.appliedChapter,
    this.note,
  });

  factory TrendFilters.fromJson(Map<String, dynamic> json) {
    return TrendFilters(
      appliedSubject: json['appliedSubject'],
      appliedChapter: json['appliedChapter'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appliedSubject': appliedSubject,
      'appliedChapter': appliedChapter,
      'note': note,
    };
  }
} 