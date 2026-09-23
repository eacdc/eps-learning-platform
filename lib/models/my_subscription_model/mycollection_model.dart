class BooksResponse {
  final bool? success;
  final Data? data;
  final Pagination? pagination;

  BooksResponse({this.success, this.data, this.pagination});

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Data {
  final List<BookCollectionModel>? books;
  final AppliedFilters? appliedFilters;
  final AvailableFilters? availableFilters;
  final Summary? summary;

  Data({this.books, this.appliedFilters, this.availableFilters, this.summary});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      books: json['books'] != null
          ? (json['books'] as List)
              .map((e) => BookCollectionModel.fromJson(e))
              .toList()
          : null,
      appliedFilters: json['appliedFilters'] != null
          ? AppliedFilters.fromJson(json['appliedFilters'])
          : null,
      availableFilters: json['availableFilters'] != null
          ? AvailableFilters.fromJson(json['availableFilters'])
          : null,
      summary:
          json['summary'] != null ? Summary.fromJson(json['summary']) : null,
    );
  }
}

class BookCollectionModel {
  final String? bookId;
  final String? title;
  final String? subject;
  final String? grade;
  final String? author;
  final String? description;
  final String? coverImage;
  final int? totalChapters;
  final String? addedToCollection;
  final String? lastAccessed;
  final UserProgress? userProgress;
  final RecentActivity? recentActivity;
  final bool isHidden;

  BookCollectionModel({
    this.bookId,
    this.title,
    this.subject,
    this.grade,
    this.author,
    this.description,
    this.coverImage,
    this.totalChapters,
    this.addedToCollection,
    this.lastAccessed,
    this.userProgress,
    this.recentActivity,
    this.isHidden = false,
  });

  factory BookCollectionModel.fromJson(Map<String, dynamic> json) {
    return BookCollectionModel(
      bookId: json['bookId'],
      title: json['title'],
      subject: json['subject'],
      grade: json['grade'],
      author: json['author'],
      description: json['description'],
      coverImage: json['coverImage'],
      totalChapters: json['totalChapters'],
      addedToCollection: json['addedToCollection'],
      lastAccessed: json['lastAccessed'],
      userProgress: json['userProgress'] != null
          ? UserProgress.fromJson(json['userProgress'])
          : null,
      recentActivity: json['recentActivity'] != null
          ? RecentActivity.fromJson(json['recentActivity'])
          : null,
      isHidden: json['isHidden'] == true || json['isHidden'] == 1,
    );
  }
}

class UserProgress {
  final int? chaptersCompleted;
  final int? chaptersInProgress;
  final double? progressPercentage;
  final int? totalTimeSpent;
  final double? averageScore;
  final String? status;

  UserProgress(
      {this.chaptersCompleted,
      this.chaptersInProgress,
      this.progressPercentage,
      this.totalTimeSpent,
      this.averageScore,
      this.status});

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      chaptersCompleted: json['chaptersCompleted'],
      chaptersInProgress: json['chaptersInProgress'],
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble(),
      totalTimeSpent: json['totalTimeSpent'],
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      status: json['status'],
    );
  }
}

class RecentActivity {
  final String? lastChapterAccessed;
  final double? lastScore;
  final String? lastQuizDate;

  RecentActivity({this.lastChapterAccessed, this.lastScore, this.lastQuizDate});

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      lastChapterAccessed: json['lastChapterAccessed'],
      lastScore: (json['lastScore'] as num?)?.toDouble(),
      lastQuizDate: json['lastQuizDate'],
    );
  }
}

class AppliedFilters {
  final List<String>? subject;
  final List<String>? grade;
  final String? sortBy;
  final String? sortOrder;

  AppliedFilters({this.subject, this.grade, this.sortBy, this.sortOrder});

  factory AppliedFilters.fromJson(Map<String, dynamic> json) {
    return AppliedFilters(
      subject: (json['subject'] as List?)?.cast<String>(),
      grade: (json['grade'] as List?)?.cast<String>(),
      sortBy: json['sortBy'],
      sortOrder: json['sortOrder'],
    );
  }
}

class AvailableFilters {
  final List<FilterItem>? subjects;
  final List<FilterItem>? grades;
  final List<FilterItem>? authors;
  final List<FilterItem>? statuses;

  AvailableFilters({this.subjects, this.grades, this.authors, this.statuses});

  factory AvailableFilters.fromJson(Map<String, dynamic> json) {
    return AvailableFilters(
      subjects: (json['subjects'] as List?)
          ?.map((e) => FilterItem.fromJson(e))
          .toList(),
      grades: (json['grades'] as List?)
          ?.map((e) => FilterItem.fromJson(e))
          .toList(),
      authors: (json['authors'] as List?)
          ?.map((e) => FilterItem.fromJson(e))
          .toList(),
      statuses: (json['statuses'] as List?)
          ?.map((e) => FilterItem.fromJson(e))
          .toList(),
    );
  }
}

class FilterItem {
  final String? name;
  final int? count;

  FilterItem({this.name, this.count});

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      name: json['name'],
      count: json['count'],
    );
  }
}

class Summary {
  final int? totalBooks;
  final int? completedBooks;
  final int? inProgressBooks;
  final int? notStartedBooks;
  final double? averageProgress;
  final int? totalTimeSpent;

  Summary({
    this.totalBooks,
    this.completedBooks,
    this.inProgressBooks,
    this.notStartedBooks,
    this.averageProgress,
    this.totalTimeSpent,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalBooks: json['totalBooks'],
      completedBooks: json['completedBooks'],
      inProgressBooks: json['inProgressBooks'],
      notStartedBooks: json['notStartedBooks'],
      averageProgress: (json['averageProgress'] as num?)?.toDouble(),
      totalTimeSpent: json['totalTimeSpent'],
    );
  }
}


class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? limit;
  bool? hasNext;
  bool? hasPrev;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
    this.hasNext,
    this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      limit: json['limit'],
      hasNext: json['hasNext'],
      hasPrev: json['hasPrev'],
    );
  }
}
