import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/snackbar_helper.dart';
import '../models/score_model/all_unified_score.dart';
import '../models/score_model/unified_score.dart';
import '../networks/api_manager.dart';

class ScoreController extends GetxController {
  var isLoading = false.obs;
  var unified_score = Rxn<UnifiedScore>();
  var all_unified_score = Rxn<UnifiedScoreAll>();
  var performance_overview_new = Rxn<Scoreboard>();

  String buildFilterUrl(String userId) {
    final baseUrl = ApiManager.unifiedScores(userId);
    final queryParams = <String>[];

    queryParams.add("include=all");
    //queryParams.add("page=${pageNo.value}");

    /*  if (searchString.value.isNotEmpty) {
      queryParams.add("q=${searchString.value}");
    }
    if (sortOrder.value.isNotEmpty) {
      queryParams.add("sortOrder=${sortOrder.value}");
    } */

    // Combine all params with '&'
    final queryString = queryParams.join("&");

    return "$baseUrl?$queryString";
  }

  void getUnifiedScore({
    required String token,
    required BuildContext context,
    required String userId,
  }) async {
    isLoading.value = true;

    final url = buildFilterUrl(userId);

    var response = await ApiManager.requestNew(
      endpoint: url,
      method: "GET",
      /* body: {
          "search": searchString.value,
          // "page": 1,
          "page_size": pageSize,
        }, */
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is Map) {
          UnifiedScore _unifiedscore = UnifiedScore.fromJson(response.data);

          if (_unifiedscore.success == true) {
            unified_score.value = _unifiedscore;
          } else {}

          ///  bookCollectionList.value = bookData.data?.books ?? [];
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        SnackBarHelper.showFailureSnackBar(
          context,
          response.data['error'] ??
              response.data['message'] ??
              "Something Went Wrong",
        );
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      print(e.toString());
      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void getAllUnifiedScore({
    required String token,
    required BuildContext context,
    required String userId,
  }) async {
    isLoading.value = true;

    final url = buildFilterUrl(userId);

    var response = await ApiManager.requestNew(
      endpoint: url,
      method: "GET",
      /* body: {
          "search": searchString.value,
          // "page": 1,
          "page_size": pageSize,
        }, */
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is Map) {
          UnifiedScoreAll _unifiedscoreall = UnifiedScoreAll.fromJson(
            response.data,
          );

          if (_unifiedscoreall.success == true) {
            all_unified_score.value = _unifiedscoreall;
          } else {}

          ///  bookCollectionList.value = bookData.data?.books ?? [];
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
        SnackBarHelper.showFailureSnackBar(
          context,
          response.data['error'] ??
              response.data['message'] ??
              "Something Went Wrong",
        );
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      print(e.toString());
      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void getPerformanceOverview({
    required String token,
    required BuildContext context,
    required String userid,
    String? filter,
  }) async {
    isLoading.value = true;

    try {
      // ---------- Date filter ----------
      final dateFormat = DateFormat('yyyy-MM-dd');
      final today = DateTime.now();

      String? startDate;
      String? endDate;

      /*  if (filter != null && filter.isNotEmpty) {
        switch (filter.toLowerCase()) {
          case 'weekly':
            startDate = dateFormat.format(
              today.subtract(const Duration(days: 7)),
            );
            endDate = dateFormat.format(today);
            break;

          case 'monthly':
            startDate = dateFormat.format(
              DateTime(today.year, today.month - 1, today.day),
            );
            endDate = dateFormat.format(today);
            break;

          case 'yearly':
            startDate = dateFormat.format(
              DateTime(today.year - 1, today.month, today.day),
            );
            endDate = dateFormat.format(today);
            break;
        }
      } */

      if (filter != null && filter.isNotEmpty) {
        int days;

        switch (filter) {
          case '7 derniers jours':
            days = 7;
            break;
          case '30 derniers jours':
            days = 30;
            break;
          case '90 derniers jours':
            days = 90;
            break;
          default:
            days = 7;
        }

        startDate = dateFormat.format(today.subtract(Duration(days: days)));
        endDate = dateFormat.format(today);
      }

      // ---------- Endpoint ----------
      String endpoint = ApiManager.getPerformanceOverview(userid);

      if (startDate != null && endDate != null) {
        endpoint += '&startDate=$startDate&endDate=$endDate';
      }

      // ---------- API Call ----------
      final response = await ApiManager.requestNew(
        endpoint: endpoint,
        method: "GET",
        token: token,
      );

      // ---------- Response Handling ----------
      if (response.isSuccess &&
          response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final data = response.data['data'];

        if (data != null && data['scoreboard'] != null) {
          performance_overview_new.value = Scoreboard.fromJson(
            data['scoreboard'],
          );
        } else {
          performance_overview_new.value = null;
        }
      } else {
        final errorMessage =
            response.data?['error'] ??
            response.data?['message'] ??
            "Failed to load performance overview";
        SnackBarHelper.showFailureSnackBarGetx(errorMessage);
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
