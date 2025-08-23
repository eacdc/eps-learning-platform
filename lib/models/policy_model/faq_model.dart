class FaqResponseModel {
  final bool? success;
  final FaqData? data;

  FaqResponseModel({this.success, this.data});

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqResponseModel(
      success: json['success'] as bool?,
      data: json['data'] != null ? FaqData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class FaqData {
  final String? title;
  final String? lastUpdated;
  final Map<String, FaqCategory>? categories;

  FaqData({this.title, this.lastUpdated, this.categories});

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      title: json['title'] as String?,
      lastUpdated: json['lastUpdated'] as String?,
      categories: (json['categories'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, FaqCategory.fromJson(value))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'lastUpdated': lastUpdated,
      'categories': categories?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class FaqCategory {
  final String? title;
  final List<FaqQuestion>? questions;

  FaqCategory({this.title, this.questions});

  factory FaqCategory.fromJson(Map<String, dynamic> json) {
    return FaqCategory(
      title: json['title'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => FaqQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}

class FaqQuestion {
  final String? question;
  final String? answer;

  FaqQuestion({this.question, this.answer});

  factory FaqQuestion.fromJson(Map<String, dynamic> json) {
    return FaqQuestion(
      question: json['question'] as String?,
      answer: json['answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
