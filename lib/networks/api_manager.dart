import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:test_your_learing/models/response_model/api_response.dart';
import 'package:test_your_learing/models/response_model/api_response_new.dart';

class ApiManager {
  static const String baseUrl = "https://chatbot-backend-v-4.onrender.com";

  // API Endpoints
  static const String login = "/api/users/login";
  static const String sendSignupOTP = "/api/users/send-otp";
  static const String verifySignupOTP = "/api/users/verify-otp";
  static const String resendSignupOTP = "/api/users/resend-otp";
  static const String checkUsername = "/api/users/check-username";
  static const String forgotPasswordOtp = "/api/users/forgot-password";
  static const String verifyOtpResetPassword = "/api/users/reset-password";
  static const String verifyGoogleLogin = "/api/social-auth/google-login";
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





  //-----------------------------------------\\

  static const String loginwithplno = "/api/loginusingplno/";
  static const String profile = "/api/employee/employeedetailsbyid";
  static const String sendOTP = "/api/send-otp/";
  static const String verifyOTP = "/api/verify-otp/";
  static const String getAllIncident = "/api/incident/getallincident/";
  static const String getAllDepartment = "/api/department/getalldepartment/";
  static const String getAllDesignation = "/api/designation/getalldesignation/";
  static const String getAllNearmisscause =
      "/api/nearmisscause/getallnearmisscause/";
  static const String s3Upload = "/api/s3/upload/";
  static const String getAllShift = "/api/shift/getallshift/";
  static const String submitEvents = "/api/incident/createincident/";
  static const String getIncidentFilterSearch = "/api/incident/filtersSearch/";

  static const String getIncidentDetails = "/api/incident/incidentdetailsbyid/";
  static const String deleteAccount = "/api/employee/checkdeleteemployee/";

  // Dynamic Headers with Token
  static Map<String, String> headers({String? token}) {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
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

      http.Response response;

      switch (method) {
        case "POST":
          response = await http.post(
            url,
            headers: headersMap,
            body: jsonEncode(body),
          );
          break;
        case "PUT":
          response = await http.put(
            url,
            headers: headersMap,
            body: jsonEncode(body),
          );
          break;
        case "DELETE":
          response = await http.delete(url, headers: headersMap);
          break;
        default:
          response = await http.get(url, headers: headersMap);
      }

      final decoded = jsonDecode(response.body);

      return ApiResponse(
        statusCode: response.statusCode,
        data: Map<String, dynamic>.from(decoded),
      );
    } catch (e) {
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

      http.Response response;

      switch (method) {
        case "POST":
          response = await http.post(
            url,
            headers: headersMap,
            body: jsonEncode(body),
          );
          break;
        case "PUT":
          response = await http.put(
            url,
            headers: headersMap,
            body:
                body != null
                    ? jsonEncode(body)
                    : null, // don’t send "null",//create problem  during PUT
          );
          break;
        case "DELETE":
          response = await http.delete(url, headers: headersMap);
          break;
        default:
          response = await http.get(url, headers: headersMap);
      }

      final dynamic decoded = jsonDecode(response.body);

      return ApiResponseNew(statusCode: response.statusCode, data: decoded);
    } catch (e) {
      print("XCV " + endpoint + " " + e.toString());
      return ApiResponseNew(
        statusCode: 500,
        data: {"message": "Something went wrong: $e"},
      );
    }
  }

  /*   static Future<dynamic> request({
    required String endpoint,
    String method = "GET",
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = Uri.parse(baseUrl + endpoint);
      final headersMap = headers(token: token);

      http.Response response;
      switch (method) {
        case "POST":
          response = await http.post(
            url,
            headers: headersMap,
            body: jsonEncode(body), // Convert parameters to JSON
          );
          break;
        case "PUT":
          response =
              await http.put(url, headers: headersMap, body: jsonEncode(body));
          break;
        case "DELETE":
          response = await http.delete(url, headers: headersMap);
          break;
        default:
          response = await http.get(url, headers: headersMap);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": "Failed with status ${response.statusCode}",
          "response": response.body
        };
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

 */
}
