import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/response_model/api_response_new.dart';

import '../helper/sharedpreference_helper.dart';
import '../views/screen/authentication/login.dart';

class ApiManager {
  static const String baseUrl = "https://chatbot-backend-v-4.onrender.com";
  static const Duration _requestTimeout = Duration(seconds: 45);
  static const int _maxRetries = 2;

  // API Endpoints
  static const String login = "/api/users/login";
  static const String register = "/api/users/register";
  static const String registerGoogleVerified =
      "/api/users/register-google-verified";
  static const String accountsByGoogleToken =
      "/api/users/accounts-by-google-token";
  // Mobile-native Google Sign-In endpoints (accept Google SDK idToken directly)
  static const String accountsByGoogleIdToken =
      "/api/users/accounts-by-google-idtoken";
  static const String registerGoogleIdToken =
      "/api/users/register-google-idtoken";
  static const String checkUsername = "/api/users/check-username";
  // Secure 2-step forgot password (new)
  static const String forgotPasswordGoogleVerify =
      "/api/users/forgot-password/google-verify";
  static const String forgotPasswordComplete =
      "/api/users/forgot-password/complete";
  // Deprecated (backend returns 410)
  static const String forgotPassword = "/api/users/forgot-password";
  static const String resetPassword = "/api/users/reset-password";
  static const String googleAuthStart = "/api/social-auth/google";
  static const String changePassword = "/api/users/change-password";
  static const String bookCollectionList = "/api/books";
  static const String bookCollectionFilterSearch =
      "/api/books/search-with-status";
  static const String sendChat = "/api/chat/send";
  static const String sendAudio = "/api/chat/transcribe";
  static const String mySubscriptionList =
      "/api/subscriptions/my-subscriptions"; // not Used
  static const String myBooksCollection =
      "/api/subscriptions/collection"; // new
  static const String subscribe = "/api/subscriptions";
  static String unsubscribe(String bookId) {
    return "/api/subscriptions/$bookId";
  }

  //static const String bookChapterList = "/api/books/$bookId/chapters";
  // Function to get chapters list endpoint by bookId
  static String bookChapterList(String bookId) {
    return "/api/books/$bookId/chapters";
  }

  static String chatHistoryList(String chapterId) {
    return "/api/chat/chapter-history/$chapterId";
  }

  static String askHistoryList(String chapterId) {
    return "/api/chapters/chat_ask-history/$chapterId";
  }

  static const String askChat = "/api/chapters/chat_ask";

  static String getChatStats(String chapterId) {
    return "/api/chat/chapter-stats/$chapterId";
  }

  static const String userProfile = "/api/users/me";
  static const String updateProfile = "/api/users/profile";
  static const String updateProfilePic = "/api/users/upload-profile-picture";

  static const String privacyPolicy = "/api/static/privacy-policy";
  static const String faq = "/api/static/faq";
  static const String termsService = "/api/static/terms-of-service";
  static const String allNotification = "/api/notifications";
  static String notificationSeen(String notificationId) {
    return "/api/notifications/$notificationId/mark-seen";
  }

  static String recentActivity(String userId) {
    return "/api/scores/recent-activity/$userId";
  }

  static String scoreBoard(String userId) {
    return "/api/scores/scoreboard/$userId";
  }

  static String scoreProgressDetails(String userId) {
    return "/api/scores/progress-details/$userId";
  }

  static String assesmentData(String userId) {
    return "/api/scores/assessment-data/$userId";
  }

  static String performanceOverview(String userId) {
    return "/api/scores/performance-overview/$userId";
  }

  static String chapterStats(String userId) {
    return "/api/scores/chapter-stats/$userId";
  }

  static String unifiedScores(String userId) {
    return "/api/unified-scores/$userId";
  }

   static String myRanking() {
    return "/api/ranking/my-ranking";
  }

  static String getPerformanceOverview(String userId) {
    return "/api/unified-scores/$userId?include=scoreboard";
  }

  //-----------------------------------------\\



  // Dynamic Headers with Token
  static Map<String, String> headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept-Language": "fr",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> _executeRequest({
    required Uri url,
    required String method,
    required Map<String, String> headersMap,
    Map<String, dynamic>? body,
  }) async {
    Future<http.Response> send() {
      switch (method) {
        case "POST":
          return http.post(
            url,
            headers: headersMap,
            body: jsonEncode(body),
          );
        case "PUT":
          return http.put(
            url,
            headers: headersMap,
            body: body != null ? jsonEncode(body) : null,
          );
        case "DELETE":
          return http.delete(url, headers: headersMap);
        default:
          return http.get(url, headers: headersMap);
      }
    }

    Object? lastError;
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await send().timeout(_requestTimeout);
      } on TimeoutException catch (e) {
        lastError = e;
      } on http.ClientException catch (e) {
        lastError = e;
      } catch (e) {
        lastError = e;
        break;
      }

      if (attempt < _maxRetries) {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }

    throw lastError ?? Exception('Request failed');
  }

  static dynamic _decodeBody(String body) {
    if (body.isEmpty) return {};
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"message": "Invalid server response"};
    }
  }

  static bool _isNetworkError(Object error) {
    return error is TimeoutException ||
        error is http.ClientException ||
        error.toString().contains('Failed to fetch') ||
        error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused');
  }

  static ApiResponseNew _networkErrorResponse(Object error) {
    if (kDebugMode) {
      print("Network error: $error");
    }

    final wakingUp = error is TimeoutException ||
        error.toString().contains('Failed to fetch');

    return ApiResponseNew(
      statusCode: 0,
      data: {
        "message": wakingUp
            ? "Server is waking up or unreachable. Please wait a moment and try again."
            : "Network error. Please check your internet connection.",
        "error": error.toString(),
      },
    );
  }

  // Generic API Call Method

  static Future<ApiResponse> request({
    required String endpoint,
    String method = "GET",
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = Uri.parse(baseUrl + endpoint);
      final headersMap = headers(token: token);
      final response = await _executeRequest(
        url: url,
        method: method,
        headersMap: headersMap,
        body: body,
      );

      final decoded = _decodeBody(response.body);

      return ApiResponse(
        statusCode: response.statusCode,
        data: decoded is Map<String, dynamic>
            ? decoded
            : Map<String, dynamic>.from(decoded as Map),
      );
    } catch (e) {
      if (_isNetworkError(e)) {
        return ApiResponse(
          statusCode: 0,
          data: {
            "message":
                "Server is waking up or unreachable. Please wait a moment and try again.",
          },
        );
      }
      return ApiResponse(
        statusCode: 500,
        data: {"message": "Something went wrong: $e"},
      );
    }
  }

  //new Generic API CALL

  static Future<ApiResponseNew> requestNew({
    required String endpoint,
    String method = "GET",
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = Uri.parse(baseUrl + endpoint);
      final headersMap = headers(token: token);
      final response = await _executeRequest(
        url: url,
        method: method,
        headersMap: headersMap,
        body: body,
      );

      final dynamic decoded = _decodeBody(response.body);

      /// TOKEN EXPIRED HANDLING
      if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleTokenExpired();
        return ApiResponseNew(
          statusCode: response.statusCode,
          data: {"message": "Session expired"},
        );
      }

      return ApiResponseNew(statusCode: response.statusCode, data: decoded);
    } catch (e) {
      if (_isNetworkError(e)) {
        return _networkErrorResponse(e);
      }
      if (kDebugMode) {
        print("API error on $endpoint: $e");
      }
      return ApiResponseNew(
        statusCode: 500,
        data: {"message": "Something went wrong: $e"},
      );
    }
  }

  static Future<void> _handleTokenExpired() async {
    SharedPreferencesService.clearAllPreferences();
    SharedPreferencesService.setFirstTimeStatus(
      false,
    ); // for not showing onboard screen
    SharedPreferencesService.setHasSeenDashboardWalkthrough(true);
    Get.offAll(() => LoginPage());
 //   Get.snackbar("Session Expired", "Please login again");
  }



}
