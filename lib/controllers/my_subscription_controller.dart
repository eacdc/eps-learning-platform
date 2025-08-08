import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/my_subscription_model/my_subscription_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class MysubscriptionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  var allfilter = true.obs;
  var departmentfilter = "".obs;
  var severityFIlter = "".obs;
  var datefromFilter = "".obs;
  var dateToFilter = "".obs;
  var pageNo = 1.obs;
  var searchString = "".obs;

  //var selectedDepartment = Rxn<Department>(); // Holds the selected department
  //var selectedSeverity = Rxn<Severity>(); // Holds the selected department

  // for pagination

  ScrollController scrollController = ScrollController();

  //var incidentDataList = <Incident>[].obs; // List to store paginated data
  // var hasNextPage = true.obs; // Tracks if more pages are available

  
  var isMoreDataAvailable = true.obs; // Tracks if more pages are available

  var mySubscriptionList = List<SubscribedBookModel>.empty().obs;
  var bookChapterList = List<BookChapterModel>.empty().obs;

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

  void getSubscriptionList({
    required String token,
    required BuildContext context,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
     /// mySubscriptionList.value = [];
      //clear
      pageNo.value = 1;
      isMoreDataAvailable.value = true;
    }
    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
      SnackBarHelper.showNormalSnackBar(context, "No more items...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    print(
      "xreq ${{
        "page": pageNumber,
        // "department_id": selectedDepartment?.value?.id ?? "",
        // "severity": selectedSeverity.value?.title ?? "",
        "start_date": datefromFilter.value,
        "end_date": dateToFilter.value,
        "search": searchString.value,
        // "page": 1,
        "page_size": pageSize,
      }}",
    );

    if (reloadpage) {
      pageNumber = 1;

      allfilter.value = true;
      departmentfilter.value = "";
      severityFIlter.value = "";
      datefromFilter.value = "";
      dateToFilter.value = "";
      searchString.value = "";
      //  selectedDepartment.value = null;
      //  selectedSeverity.value = null;

      /* ********* refresh page no*/

      pageNo.value = 1;
    }

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.mySubscriptionList,
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
          List<SubscribedBookModel> books =
              (response.data as List)
                  .map((item) => SubscribedBookModel.fromJson(item))
                  .toList();
          // use books
          mySubscriptionList.value = books;
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            print(
              "Error: ${response.data['error'] ?? response.data['message']}",
            );
          } else {
            BookList book = BookList.fromJson(response.data);
            // use single book
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

  void getBookChapter({
    required String token,
    required BuildContext context,
    required String bookId,
  }) async {
    bookChapterList.clear();

    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.bookChapterList(bookId),
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
          List<BookChapterModel> books =
              (response.data as List)
                  .map((item) => BookChapterModel.fromJson(item))
                  .toList();
          // use books
          bookChapterList.value = books;
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            print(
              "Error: ${response.data['error'] ?? response.data['message']}",
            );
          } else {
            BookList book = BookList.fromJson(response.data);
            // use single book
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void unsubscribeBook({
    required String token,
    required BuildContext context,
    required String bookId,

    // Default to false , Clear all data and filter value
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.unsubscribe(bookId),
      method: "DELETE",
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
        getSubscriptionList(context: context, token: token);

        if (response.data is List) {
          List<SubscribedBookModel> books =
              (response.data as List)
                  .map((item) => SubscribedBookModel.fromJson(item))
                  .toList();
          // use books
          mySubscriptionList.value = books;
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            print(
              "Error: ${response.data['error'] ?? response.data['message']}",
            );

            SnackBarHelper.showSuccessSnackBar(
              context,
              response.data['error'] ?? response.data['message'],
            );
          } else {
            BookList book = BookList.fromJson(response.data);
            // use single book
          }
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
      isLoading.value = false;
    }
  }

  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reach end");
        pageNo.value = pageNo.value + 1;

        //get More Task
      }
    });
  }
}
