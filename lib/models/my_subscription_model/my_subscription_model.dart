class SubscribedBookModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? bookId;
  final String? bookTitle;
  final String? publisher;
  final String? bookCoverImgLink;
  final String? subscribedAt;

  SubscribedBookModel({
    this.id,
    this.userId,
    this.userName,
    this.bookId,
    this.bookTitle,
    this.publisher,
    this.bookCoverImgLink,
    this.subscribedAt,
  });

  factory SubscribedBookModel.fromJson(Map<String, dynamic> json) {
    return SubscribedBookModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      bookId: json['bookId'] as String?,
      bookTitle: json['bookTitle'] as String?,
      publisher: json['publisher'] as String?,
      bookCoverImgLink: json['bookCoverImgLink'] as String?,
      subscribedAt: json['subscribedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'userName': userName,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'publisher': publisher,
      'bookCoverImgLink': bookCoverImgLink,
      'subscribedAt': subscribedAt,
    };
  }
}
