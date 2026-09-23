
class BookList {
  final String id;
  final String title;
  final String publisher;
  final String subject;
  final String language;
  final String grade;
  final String bookCoverImgLink;
  final String createdAt;
  final String updatedAt;
  final String bookId;
  //bool subscribed; // 🔑 New field (mutable)
  final bool isSubscribed;
  final bool isHidden;

  BookList({
    required this.id,
    required this.title,
    required this.publisher,
    required this.subject,
    required this.language,
    required this.grade,
    required this.bookCoverImgLink,
    required this.createdAt,
    required this.updatedAt,
    required this.bookId,
    required this.isSubscribed,
    this.isHidden = false,
   // this.subscribed = false, // 🔑 Default false
  });

  factory BookList.fromJson(Map<String, dynamic> json) {
    return BookList(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      publisher: json['publisher'] ?? '',
      subject: json['subject'] ?? '',
      language: json['language'] ?? '',
      grade: json['grade'] ?? '',
      bookCoverImgLink: json['bookCoverImgLink'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bookId: json['bookId'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      isHidden: json['isHidden'] == true || json['isHidden'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'publisher': publisher,
      'subject': subject,
      'language': language,
      'grade': grade,
      'bookCoverImgLink': bookCoverImgLink,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bookId': bookId,
      'isSubscribed': isSubscribed,
      'isHidden': isHidden,
      //'subscribed': subscribed,
    };
  }

  static List<BookList> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BookList.fromJson(json)).toList();
  }
}

