class BookChapterModel {
  final String id;
  final String bookId;
  final String title;
  final String prompt; // raw prompt string, could be parsed if needed
  final List<double> embedding;
  final List<QuestionPrompt> questionPrompt;
  final String createdAt;
  final String updatedAt;
  final String chapterId;
  final int v;

  BookChapterModel({
    required this.id,
    required this.bookId,
    required this.title,
    required this.prompt,
    required this.embedding,
    required this.questionPrompt,
    required this.createdAt,
    required this.updatedAt,
    required this.chapterId,
    required this.v,
  });

  factory BookChapterModel.fromJson(Map<String, dynamic> json) {
    return BookChapterModel(
      id: json['_id'],
      bookId: json['bookId'],
      title: json['title'],
      prompt: json['prompt'],
      embedding: List<double>.from(json['embedding'].map((e) => e.toDouble())),
      questionPrompt: List<QuestionPrompt>.from(
        json['questionPrompt'].map((e) => QuestionPrompt.fromJson(e)),
      ),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      chapterId: json['chapterId'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bookId': bookId,
      'title': title,
      'prompt': prompt,
      'embedding': embedding,
      'questionPrompt': questionPrompt.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'chapterId': chapterId,
      '__v': v,
    };
  }
}


class QuestionPrompt {
  final String questionId;
  final int Q;
  final String question;
  final int questionMarks;
  final String subtopic;
  final String questionType;
  final String tentativeAnswer;
  final String difficultyLevel;

  QuestionPrompt({
    required this.questionId,
    required this.Q,
    required this.question,
    required this.questionMarks,
    required this.subtopic,
    required this.questionType,
    required this.tentativeAnswer,
    required this.difficultyLevel,
  });

  factory QuestionPrompt.fromJson(Map<String, dynamic> json) {
    return QuestionPrompt(
      questionId: json['questionId'],
      Q: json['Q'],
      question: json['question'],
      questionMarks: json['question_marks'],
      subtopic: json['subtopic'],
      questionType: json['question_type'],
      tentativeAnswer: json['tentativeAnswer'],
      difficultyLevel: json['difficultyLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'Q': Q,
      'question': question,
      'question_marks': questionMarks,
      'subtopic': subtopic,
      'question_type': questionType,
      'tentativeAnswer': tentativeAnswer,
      'difficultyLevel': difficultyLevel,
    };
  }
}
