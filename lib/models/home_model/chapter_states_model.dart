class ChapterStates {
  final bool? success;
  final StatsData? data;

  ChapterStates({this.success, this.data});

  factory ChapterStates.fromJson(Map<String, dynamic> json) {
    return ChapterStates(
      success: json['success'] as bool?,
      data: json['data'] != null ? StatsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class StatsData {
  final String? userId;
  final DateRange? dateRange;
  final OverallStats? overall;
  final List<BookStat>? bookStats;

  StatsData({this.userId, this.dateRange, this.overall, this.bookStats});

  factory StatsData.fromJson(Map<String, dynamic> json) {
    return StatsData(
      userId: json['userId'] as String?,
      dateRange: json['dateRange'] != null
          ? DateRange.fromJson(json['dateRange'])
          : null,
      overall:
          json['overall'] != null ? OverallStats.fromJson(json['overall']) : null,
      bookStats: (json['bookStats'] as List?)
          ?.map((e) => BookStat.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dateRange': dateRange?.toJson(),
      'overall': overall?.toJson(),
      'bookStats': bookStats?.map((e) => e.toJson()).toList(),
    };
  }
}

class DateRange {
  final String? start;
  final String? end;

  DateRange({this.start, this.end});

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: json['start'] as String?,
      end: json['end'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}

class OverallStats {
  final int? totalBooks;
  final int? totalChapters;
  final CountPercentage? completed;
  final CountPercentage? inProgress;
  final CountPercentage? notStarted;

  OverallStats({
    this.totalBooks,
    this.totalChapters,
    this.completed,
    this.inProgress,
    this.notStarted,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalBooks: json['totalBooks'] as int?,
      totalChapters: json['totalChapters'] as int?,
      completed: json['completed'] != null
          ? CountPercentage.fromJson(json['completed'])
          : null,
      inProgress: json['inProgress'] != null
          ? CountPercentage.fromJson(json['inProgress'])
          : null,
      notStarted: json['notStarted'] != null
          ? CountPercentage.fromJson(json['notStarted'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBooks': totalBooks,
      'totalChapters': totalChapters,
      'completed': completed?.toJson(),
      'inProgress': inProgress?.toJson(),
      'notStarted': notStarted?.toJson(),
    };
  }
}

class CountPercentage {
  final int? count;
  final double? percentage;
  final List<Chapter>? chapters;

  CountPercentage({this.count, this.percentage, this.chapters});

  factory CountPercentage.fromJson(Map<String, dynamic> json) {
    return CountPercentage(
      count: json['count'] as int?,
      percentage:  (json['percentage'] != null)
        ? (json['percentage'] as num).toDouble()
        : null,
      chapters: (json['chapters'] as List?)
          ?.map((e) => Chapter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
      'chapters': chapters?.map((e) => e.toJson()).toList(),
    };
  }
}

class Chapter {
  final String? id;
  final String? title;

  Chapter({this.id, this.title});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class BookStat {
  final String? bookId;
  final String? title;
  final int? totalChapters;
  final CountPercentage? completed;
  final CountPercentage? inProgress;
  final CountPercentage? notStarted;

  BookStat({
    this.bookId,
    this.title,
    this.totalChapters,
    this.completed,
    this.inProgress,
    this.notStarted,
  });

  factory BookStat.fromJson(Map<String, dynamic> json) {
    return BookStat(
      bookId: json['bookId'] as String?,
      title: json['title'] as String?,
      totalChapters: json['totalChapters'] as int?,
      completed: json['completed'] != null
          ? CountPercentage.fromJson(json['completed'])
          : null,
      inProgress: json['inProgress'] != null
          ? CountPercentage.fromJson(json['inProgress'])
          : null,
      notStarted: json['notStarted'] != null
          ? CountPercentage.fromJson(json['notStarted'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'totalChapters': totalChapters,
      'completed': completed?.toJson(),
      'inProgress': inProgress?.toJson(),
      'notStarted': notStarted?.toJson(),
    };
  }
}
