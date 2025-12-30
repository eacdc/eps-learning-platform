import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:test_your_learing/models/home_model/scoreboard_controller.dart';
import 'package:test_your_learing/models/profile_model/profile_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

import '../../helper/snackbar_helper.dart';
import '../../models/home_model/chapter_states_model.dart';
import '../../models/home_model/ranking_response_model.dart';
import '../../models/home_model/recent_activity_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var recent_activity = Rxn<RecentActivityModel>();
  var scoreboard = Rxn<ScoreboardModel>();
  var chapterStates = Rxn<ChapterStates>();
  var myRanking = Rxn<RankingResponse>();

  @override
  void onInit() {
    super.onInit();
    //fetchProfile(); // Example function
  }

  void getRecentActivity({
    required String token,
    required BuildContext context,
    required String userid,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.recentActivity(userid),
      method: "GET",
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            SnackBarHelper.showFailureSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            recent_activity.value = RecentActivityModel.fromJson(response.data);
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ?? response.data['message'],
          );
        } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Request failed: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void getScoreBoard({
    required String token,
    required BuildContext context,
    required String userid,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.scoreBoard(userid),
      method: "GET",
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            SnackBarHelper.showFailureSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            scoreboard.value = ScoreboardModel.fromJson(response.data);
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ?? response.data['message'],
          );
        } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Request failed: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void getChapterStats({
    required String token,
    required BuildContext context,
    required String userid,
    String? filter,
  }) async {
    isLoading.value = true;

    // Format date
    final dateFormat = DateFormat('yyyy-MM-dd');
    String? startDate;
    String? endDate;

    final today = DateTime.now();


    if (filter != null && filter.isNotEmpty) {
      if (filter.toLowerCase() == 'weekly') {
        startDate = dateFormat.format(today.subtract(const Duration(days: 7)));
        endDate = dateFormat.format(today);
      } else if (filter.toLowerCase() == 'monthly') {
        startDate = dateFormat.format(
          DateTime(today.year, today.month - 1, today.day),
        );
        endDate = dateFormat.format(today);
      } else if (filter.toLowerCase() == 'yearly') {
        startDate = dateFormat.format(
          DateTime(today.year - 1, today.month, today.day),
        );
        endDate = dateFormat.format(today);
      }
    }

    // Build endpoint with or without dates
    String endpoint = ApiManager.chapterStats(userid);
    if (startDate != null && endDate != null) {
      endpoint += '?startDate=$startDate&endDate=$endDate';
    }

    var response = await ApiManager.requestNew(
      endpoint: endpoint,
      method: "GET",
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
        } else if (response.data is Map) {
          if (response.data.containsKey('success') &&
              response.data['success']) {
            chapterStates.value = ChapterStates.fromJson(response.data);
          } else {
            //?????????????????
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ?? response.data['message'],
          );
        } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Request failed: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      print(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

void getMyRanking({
    required String token,
    required BuildContext context,
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.myRanking(),
      method: "GET",
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            SnackBarHelper.showFailureSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            myRanking.value = RankingResponse.fromJson(response.data);
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ?? response.data['message'],
          );
        } else {
          SnackBarHelper.showFailureSnackBarGetx(
            "Request failed: ${response.statusCode}",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

    
    } finally {
      isLoading.value = false;
    }
  }




}
