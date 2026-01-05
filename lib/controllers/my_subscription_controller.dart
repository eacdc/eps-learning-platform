import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/my_subscription_model/my_subscription_model.dart';
import 'package:test_your_learing/models/my_subscription_model/mycollection_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class MysubscriptionController extends GetxController
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

  var mySubscriptionList = List<SubscribedBookModel>.empty().obs;
  var bookChapterList = List<BookChapterModel>.empty().obs;
  var bookCollectionList = List<BookCollectionModel>.empty().obs; // new book

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

  String buildFilterUrl() {
    final baseUrl = ApiManager.mySubscriptionList;
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

  String buildCollectionUrl() {
    final baseUrl = ApiManager.myBooksCollection;
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
  void getMyBooksCollectionFilter({
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

      print("zxc " + bookCollectionList.length.toString());
      print("zxc " + searchString.value.toString());
    }

    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
     /// SnackBarHelper.showNormalSnackBar(context, "No more Books...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    final url = buildCollectionUrl();

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
        if (response.data["success"]) {
          List<BookCollectionModel> booksCollection =
              (response.data["data"]["books"] as List)
                  .map((item) => BookCollectionModel.fromJson(item))
                  .toList();
          // use books
          // mySubscriptionList.value = books;

          if (booksCollection.isNotEmpty) {
            (pageNumber == 1)
                ? (bookCollectionList
                  ..clear()
                  ..addAll(booksCollection))
                : bookCollectionList.addAll(booksCollection);

            print("zxc api " + bookCollectionList.length.toString());
          } else {
            isMoreDataAvailable.value = false;
            if (pageNumber > 1) {
              SnackBarHelper.showFailureSnackBar(context, "No more books...");
            }else{
              bookCollectionList.clear();
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

  //not used
  void getSubscriptionListFilter({
    required String token,
    required BuildContext context,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      mySubscriptionList.value = [];
      //clear
      pageNo.value = 1;
      isMoreDataAvailable.value = true;
    }
    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
      ///SnackBarHelper.showNormalSnackBar(context, "No more Books...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    /*  if (reloadpage) {
      pageNumber = 1;

      //  selectedDepartment.value = null;
      //  selectedSeverity.value = null;

      /* ********* refresh page no*/

      pageNo.value = 1;
    } */

    final url = buildFilterUrl();

    print("urll" + url);

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
          List<SubscribedBookModel> books =
              (response.data as List)
                  .map((item) => SubscribedBookModel.fromJson(item))
                  .toList();
          // use books
          // mySubscriptionList.value = books;

          if (books.isNotEmpty) {
            mySubscriptionList.addAll(books);
          } else {
            isMoreDataAvailable.value = false;
            if (pageNumber > 1) {
              SnackBarHelper.showFailureSnackBar(context, "No more books...");
            }
          }
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

  //not used
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
     // SnackBarHelper.showNormalSnackBar(context, "No more items...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    if (reloadpage) {
      pageNumber = 1;

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

    isChapterLoading.value = true;

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
      isChapterLoading.value = false;
    }
  }

  void unsubscribeBook({
    required String token,
    required BuildContext context,
    required String bookId,

    // Default to false , Clear all data and filter value
  }) async {
    isSubscribeLoading.value = true;

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
      isSubscribeLoading.value = false;
      if (context != null && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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
