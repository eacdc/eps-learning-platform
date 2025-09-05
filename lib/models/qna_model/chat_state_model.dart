class ChatStats {
  final bool? hasStats;
  final double? earnedMarks;
  final double? totalMarks;
  final double? percentage;
  final int? answeredQuestions;
  final int? totalQuestions;

  ChatStats({
    this.hasStats,
    this.earnedMarks,
    this.totalMarks,
    this.percentage,
    this.answeredQuestions,
    this.totalQuestions,
  });

  factory ChatStats.fromJson(Map<String, dynamic> json) {
    return ChatStats(
      hasStats: json['hasStats'] as bool?,
      earnedMarks: (json['earnedMarks'] as num?)?.toDouble(),
      totalMarks: (json['totalMarks'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
      answeredQuestions: json['answeredQuestions'] as int?,
      totalQuestions: json['totalQuestions'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasStats': hasStats,
      'earnedMarks': earnedMarks,
      'totalMarks': totalMarks,
      'percentage': percentage,
      'answeredQuestions': answeredQuestions,
      'totalQuestions': totalQuestions,
    };
  }
}
