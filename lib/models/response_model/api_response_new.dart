class ApiResponseNew {
  final int statusCode;
  final dynamic data; // Can be Map, List, or String

  ApiResponseNew({
    required this.statusCode,
    required this.data,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}