class ChatResponseModel {
  final String? message;
  final String? questionId;
  final FullQuestion? fullQuestion;
  final String? agentType;
  final String? previousQuestionId;
  final Score? score;
  final String? agentName;
  final ChatSession? chatSession;

  ChatResponseModel({
    this.message,
    this.questionId,
    this.fullQuestion,
    this.agentType,
    this.previousQuestionId,
    this.score,
    this.agentName,
    this.chatSession,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      message: json['message'],
      questionId: json['questionId'],
      fullQuestion:
          json['fullQuestion'] != null
              ? FullQuestion.fromJson(json['fullQuestion'])
              : null,
      agentType: json['agentType'],
      previousQuestionId: json['previousQuestionId'],
      score: json['score'] != null ? Score.fromJson(json['score']) : null,
      agentName: json['agentName'],
      chatSession:
          json['session'] != null
              ? ChatSession.fromJson(json['session'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'questionId': questionId,
      'fullQuestion': fullQuestion?.toJson(),
      'agentType': agentType,
      'previousQuestionId': previousQuestionId,
      'score': score?.toJson(),
      'agentName': agentName,
    };
  }
}

class FullQuestion {
  final String? questionId;
  final int? q;
  final String? question;
  final int? questionMarks;
  final String? subtopic;
  final String? questionType;
  final String? tentativeAnswer;
  final String? difficultyLevel;

  FullQuestion({
    this.questionId,
    this.q,
    this.question,
    this.questionMarks,
    this.subtopic,
    this.questionType,
    this.tentativeAnswer,
    this.difficultyLevel,
  });

  factory FullQuestion.fromJson(Map<String, dynamic> json) {
    return FullQuestion(
      questionId: json['questionId'],
      q: json['Q'],
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
      'Q': q,
      'question': question,
      'question_marks': questionMarks,
      'subtopic': subtopic,
      'question_type': questionType,
      'tentativeAnswer': tentativeAnswer,
      'difficultyLevel': difficultyLevel,
    };
  }
}

class Score {
  final num? marksAwarded;
  final num? maxMarks;
  final String? previousQuestion;

  Score({this.marksAwarded, this.maxMarks, this.previousQuestion});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      marksAwarded: json['marksAwarded'],
      maxMarks: json['maxMarks'],
      previousQuestion: json['previousQuestion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marksAwarded': marksAwarded,
      'maxMarks': maxMarks,
      'previousQuestion': previousQuestion,
    };
  }
}

class ChatSession { 
  final num? sessionId;
  final String? sessionStatus;
  final num? scorePercentage;
  final num? startSessionAfter;
  final bool? canStartNewSession;

  ChatSession({
    this.sessionId,
    this.sessionStatus,
    this.scorePercentage,
    this.startSessionAfter,
    this.canStartNewSession,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['sessionId'],
      sessionStatus: json['sessionStatus'],
      scorePercentage: json['scorePercentage'],
      startSessionAfter: json['startSessionAfter'],
      canStartNewSession: json['canStartNewSession'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionStatus': sessionStatus,
      'scorePercentage': scorePercentage,
      'startSessionAfter': startSessionAfter,
      'canStartNewSession': canStartNewSession,
    };
  }
}
