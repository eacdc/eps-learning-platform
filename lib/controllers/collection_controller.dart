import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/my_subscription_model/my_subscription_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

import '../models/collection_model/books_collection_filter..dart';

class CollectionController extends GetxController
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

  //var selectedDepartment = Rxn<Department>(); // Holds the selected department

  ScrollController scrollController = ScrollController();

  //var incidentDataList = <Incident>[].obs; // List to store paginated data
  // var hasNextPage = true.obs; // Tracks if more pages are available

  var isMoreDataAvailable = true.obs; // Tracks if more pages are available

  var bookCollectionList = List<BookList>.empty().obs;
  var bookChapterList = List<BookChapterModel>.empty().obs;

  var mySubscriptionList = List<SubscribedBookModel>.empty().obs;

  CollectionController() {}

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
    final baseUrl = ApiManager.bookCollectionFilterSearch;
    final queryParams = <String>[];

    queryParams.add("limit=${limit.value}");
    queryParams.add("page=${pageNo.value}");

    if (searchString.value.isNotEmpty) {
      queryParams.add("q=${searchString.value}");
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

  void getBookListCollectionFilterSearch({
    required String token,
    required BuildContext context,
    int pageSize = 20, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      //  bookCollectionList.value = [];
      //clear
      pageNo.value = 1;
      isMoreDataAvailable.value = true;
    }
    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
      /// SnackBarHelper.showNormalSnackBar(context, "No More Books...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    print(
      "qqqqqqqqqqqqq " +
          "${ApiManager.bookCollectionFilterSearch}?q=${searchString.value}&sortOrder=${sortOrder.value}&sortBy=${sortBy.value}&subject=${subjectFilter.value}&grade=${gradeFilter.value}",
    );

    /* if (reloadpage) {
      pageNumber = 1;
      //  selectedDepartment.value = null;
      //  selectedSeverity.value = null;
      /* ********* refresh page no*/
      pageNo.value = 1;
    } */

    final url = buildFilterUrl();

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
          BookResponseModel bookData = BookResponseModel.fromJson(
            response.data,
          );

          final newData = bookData.data?.books ?? [];
          if (newData.isNotEmpty) {
            (pageNumber == 1)
                ? (bookCollectionList
                  ..clear()
                  ..addAll(newData))
                : bookCollectionList.addAll(newData);
          } else {
            isMoreDataAvailable.value = false;
            if (pageNumber > 1) {
              SnackBarHelper.showFailureSnackBar(context, "No more books...");
            } else {
              bookCollectionList.clear();
            }
          }

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

  void getBookListCollection({
    required String token,
    required BuildContext context,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      ///  bookCollectionList.value = [];
      //clear
      pageNo.value = 1;
      isMoreDataAvailable.value = true;
    }
    if (
    // isLoading.value ||
    !isMoreDataAvailable.value) {
      /// SnackBarHelper.showNormalSnackBar(context, "No more items...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    if (reloadpage) {
      pageNumber = 1;

      searchString.value = "";
      //  selectedDepartment.value = null;
      //  selectedSeverity.value = null;

      /* ********* refresh page no*/

      pageNo.value = 1;
    }

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.bookCollectionList,
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
        getSubscriptionList(token: token, context: context);
        if (response.data is List) {
          List<BookList> books =
              (response.data as List)
                  .map((item) => BookList.fromJson(item))
                  .toList();
          // use books
          bookCollectionList.value = books;
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

  void getSubscriptionList({
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
      /// SnackBarHelper.showNormalSnackBar(context, "No more items...");

      return;
    } // Prevent multiple calls

    isLoading.value = true;

    if (reloadpage) {
      pageNumber = 1;

      // dateToFilter.value = "";
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
          List<SubscribedBookModel> subscribebooks =
              (response.data as List)
                  .map((item) => SubscribedBookModel.fromJson(item))
                  .toList();
          // use books
          mySubscriptionList.value = subscribebooks;

          List<BookList> allBooks = bookCollectionList.value;
          List<String> subscribedIds =
              subscribebooks.map((e) => e.bookId.toString()).toList();

          ///  updateSubscribedStatus(allBooks, subscribedIds);
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
        getBookListCollectionFilterSearch(context: context, token: token);
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

            SnackBarHelper.showSuccessSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            BookList book = BookList.fromJson(response.data);
            // use single book
          }
        } else {
          print("Unhandled response format");
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ??
                response.data['message'] ??
                "Something Went Wrong",
          );
        }
      } else {
        print("Request failed: ${response.statusCode}");
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isSubscribeLoading.value = false;
      // Close BottomSheet only if it's still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void subscribeBook({
    required String token,
    required BuildContext context,
    required String bookId,
    required String couponCode,

    // Default to false , Clear all data and filter value
  }) async {
    isSubscribeLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.subscribe,
      method: "POST",
      body: {"bookId": bookId, "couponCode": couponCode},
      token: token,
    );

    try {
      if (response.isSuccess) {
        getBookListCollectionFilterSearch(context: context, token: token);

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

            SnackBarHelper.showSuccessSnackBarGetx(
              response.data['error'] ?? response.data['message'],
            );
          } else {
            BookList book = BookList.fromJson(response.data);
            // use single book
          }
        } else {
          print("Unhandled response format");
          SnackBarHelper.showFailureSnackBarGetx(
            response.data['error'] ??
                response.data['message'] ??
                "Something Went Wrong",
          );
        }
      } else {
        print("Request failed: ${response.statusCode}");
        SnackBarHelper.showFailureSnackBarGetx(
          response.data['error'] ??
              response.data['message'] ??
              "Failed to subscribe",
        );
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isSubscribeLoading.value = false;
      // Close BottomSheet only if it's still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  /* void updateSubscribedStatus(
    List<BookList> allBooks,
    List<String> subscribedBookIds,
  ) {
    print(subscribedBookIds.length.toString() + "xxx");
    for (var book in bookCollectionList) {
      if (subscribedBookIds.contains(book.id)) {
        book.subscribed = true;
      }
    }
    bookCollectionList.refresh();
  } */
}
