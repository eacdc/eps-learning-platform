import 'package:test_your_learing/models/collection_model/books_collection_list.dart';

class BookResponseModel {
  bool? success;
  BookData? data;
  Pagination? pagination;

  BookResponseModel({this.success, this.data, this.pagination});

  factory BookResponseModel.fromJson(Map<String, dynamic> json) {
    return BookResponseModel(
      success: json['success'],
      data: json['data'] != null ? BookData.fromJson(json['data']) : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class BookData {
  List<BookList>? books;
  int? totalResults;
  String? searchQuery;
  List<dynamic>? suggestions;
  AppliedFilters? appliedFilters;

  BookData({
    this.books,
    this.totalResults,
    this.searchQuery,
    this.suggestions,
    this.appliedFilters,
  });

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      books: (json['books'] as List<dynamic>?)
          ?.map((e) => BookList.fromJson(e))
          .toList(),
      totalResults: json['totalResults'],
      searchQuery: json['searchQuery'],
      suggestions: json['suggestions'],
      appliedFilters: json['appliedFilters'] != null
          ? AppliedFilters.fromJson(json['appliedFilters'])
          : null,
    );
  }
}

class Book {
  String? id;
  String? title;
  String? publisher;
  String? subject;
  String? language;
  String? grade;
  String? bookCoverImgLink;
  String? createdAt;
  String? updatedAt;
  String? bookId;
  int? v;
  bool? isSubscribed;

  Book({
    this.id,
    this.title,
    this.publisher,
    this.subject,
    this.language,
    this.grade,
    this.bookCoverImgLink,
    this.createdAt,
    this.updatedAt,
    this.bookId,
    this.v,
    this.isSubscribed,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      publisher: json['publisher'],
      subject: json['subject'],
      language: json['language'],
      grade: json['grade'],
      bookCoverImgLink: json['bookCoverImgLink'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      bookId: json['bookId'],
      v: json['__v'],
      isSubscribed: json['isSubscribed'],
    );
  }
}

class AppliedFilters {
  String? sortBy;
  String? sortOrder;

  AppliedFilters({this.sortBy, this.sortOrder});

  factory AppliedFilters.fromJson(Map<String, dynamic> json) {
    return AppliedFilters(
      sortBy: json['sortBy'],
      sortOrder: json['sortOrder'],
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
