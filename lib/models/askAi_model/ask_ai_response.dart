class AskAiResponse {
  final String? response;
  final List<Source>? sources;
  final int? totalResults;

  AskAiResponse({
    this.response,
    this.sources,
    this.totalResults,
  });

  factory AskAiResponse.fromJson(Map<String, dynamic> json) {
    return AskAiResponse(
      response: json['response'],
      sources: (json['sources'] as List?)
          ?.map((e) => Source.fromJson(e))
          .toList(),
      totalResults: json['totalResults'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'sources': sources?.map((e) => e.toJson()).toList(),
      'totalResults': totalResults,
    };
  }
}

  class Source {
  final double? score;
  final String? text;

  Source({
    this.score,
    this.text,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      score: (json['score'] as num?)?.toDouble(),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'text': text,
    };
  }
}
