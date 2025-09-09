import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/snackbar_helper.dart';
import '../models/score_model/unified_score.dart';
import '../networks/api_manager.dart';

class ScoreController extends GetxController {
  var isLoading = false.obs;
  var unified_score = Rxn<UnifiedScore>();

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
}
