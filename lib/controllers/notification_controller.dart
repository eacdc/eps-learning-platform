import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/snackbar_helper.dart';
import '../models/notification_model/all_notification_model.dart';
import '../networks/api_manager.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  var isChapterLoading = false.obs;
  var isSubscribeLoading = false.obs;

  var pageNo = 1.obs;
  var limit = 20.obs;
  var searchString = "".obs;
  var sortBy = "".obs;
  var sortOrder = "".obs;
  var gradeFilter = "".obs;
  var subjectFilter = "".obs;
  var gridStyle = true.obs;
  var isFilterApplied = false.obs;
  var isSortApplied = false.obs;

  ScrollController scrollController = ScrollController();

  var isMoreDataAvailable = true.obs; // Tracks if more pages are available


  var allNotificationList = List<AllNotificationModel>.empty().obs; // new book

  MysubscriptionController() {}

  @override
  onInit() async {
    super.onInit();
    //call api if data required initially
    //getUserToken()
    //fetch data

    //paginate task
    // paginateTask();
  }

  void clearFilters() {
    gradeFilter.value = "";
    subjectFilter.value = "";

    updateIsFilterApplied(); // Update the status of applied filters
  }

  void updateIsFilterApplied() {
    isFilterApplied.value = gradeFilter.isNotEmpty || subjectFilter.isNotEmpty;
  }

  void clearSorts() {
    sortBy.value = "";
    sortOrder.value = "";

    updateIsSortApplied(); // Update the status of applied filters
  }

  void updateIsSortApplied() {
    isSortApplied.value = sortBy.isNotEmpty || sortOrder.isNotEmpty;
  }


  String buildAllNotificationUrl() {
    final baseUrl = ApiManager.allNotification;
    final queryParams = <String>[];

    queryParams.add("limit=${limit.value}");
    queryParams.add("page=${pageNo.value}");

    if (searchString.value.isNotEmpty) {
      queryParams.add("search=${searchString.value}");
    }
    if (sortOrder.value.isNotEmpty) {
      queryParams.add("sortOrder=${sortOrder.value}");
    }
    if (sortBy.value.isNotEmpty) {
      queryParams.add("sortBy=${sortBy.value}");
    }
    if (subjectFilter.value.isNotEmpty) {
      queryParams.add("subject=${subjectFilter.value}");
    }
    if (gradeFilter.value.isNotEmpty) {
      queryParams.add("grade=${gradeFilter.value}");
    }

    // Combine all params with '&'
    final queryString = queryParams.join("&");

    return "$baseUrl?$queryString";
  }

  //used
  void getAllNotificationFilter({
    required String token,
    required BuildContext context,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      //bookCollectionList.value = [];
     /// bookCollectionList.clear();
      //clear
      pageNo.value = 1;
      isMoreDataAvailable.value = true;

    }

    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
      SnackBarHelper.showNormalSnackBar(context, "No more Books...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    final url = buildAllNotificationUrl();

    print("url" + url);

    var response = await ApiManager.requestNew(
      endpoint: url,
      method: "GET",
      /* body: {
          "page": pageNumber,
         // "department_id": selectedDepartment?.value?.id ?? "",
        //  "severity": selectedSeverity.value?.title ?? "",
          "start_date": datefromFilter.value,
          "end_date": dateToFilter.value,
          "search": searchString.value,
          // "page": 1,
          "page_size": pageSize,
        }, */
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
          List<AllNotificationModel> notificationList =
              (response.data as List)
                  .map((item) => AllNotificationModel.fromJson(item))
                  .toList();
          // use books
          // mySubscriptionList.value = books;

          if (notificationList.isNotEmpty) {
            (pageNumber == 1)
                ? (allNotificationList
                  ..clear()
                  ..addAll(notificationList))
                : allNotificationList.addAll(notificationList);

          } else {
            isMoreDataAvailable.value = false;
            if (pageNumber > 1) {
              SnackBarHelper.showFailureSnackBar(context, "No more books...");
            }else{
              allNotificationList.clear();
            }
          }
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

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }


  void seenNotification({
    required String token,
    required BuildContext context,
    required String notificationId,

    // Default to false , Clear all data and filter value
  }) async {
    isSubscribeLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.notificationSeen(notificationId),
      method: "PUT",

      token: token,
    );

    try {
      if (response.isSuccess) {
        getAllNotificationFilter(context: context, token: token);

        if (response.data is List) {
         
        } else if (response.data is Map) {
        
        } else {
          print("Unhandled response format");
          SnackBarHelper.showFailureSnackBar(
            context,
            response.data['error'] ??
                response.data['message'] ??
                "Something Went Wrong",
          );
        }
      } else {
        print("Request failed: ${response.statusCode}");
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isSubscribeLoading.value = false;
    /*   if (context != null && Navigator.canPop(context)) {
        Navigator.pop(context);
      } */
    }
  }
 
  
  

}
