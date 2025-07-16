import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/my_subscription_model/my_subscription_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class CollectionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;

  var incidentdata = Rxn<IncidentFormResponse>(); // Holds LoginResponse object

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

  var incidentDataList =
      List<Incident>.empty(growable: true).obs; // List to store paginated data
  var isMoreDataAvailable = true.obs; // Tracks if more pages are available

  var bookCollectionList = List<BookList>.empty().obs;
  var bookChapterList = List<BookChapterModel>.empty().obs;

  var mySubscriptionList = List<SubscribedBookModel>.empty().obs;

  DashboardController() {}

  @override
  onInit() async {
    super.onInit();
    //call api if data required initially
    //getUserToken()
    //fetch data

    //paginate task
    // paginateTask();
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
          List<SubscribedBookModel> subscribebooks =
              (response.data as List)
                  .map((item) => SubscribedBookModel.fromJson(item))
                  .toList();
          // use books
          mySubscriptionList.value = subscribebooks;

          List<BookList> allBooks = bookCollectionList.value;
          List<String> subscribedIds =
              subscribebooks.map((e) => e.bookId.toString()).toList();

          updateSubscribedStatus(allBooks, subscribedIds);
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
        getBookListCollection(context: context, token: token);
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

  void subscribeBook({
    required String token,
    required BuildContext context,
    required String bookId,

    // Default to false , Clear all data and filter value
  }) async {
    isLoading.value = true;

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.subscribe,
      method: "POST",
      body: {"bookId": bookId},
      token: token,
    );

    try {
      if (response.isSuccess) {
        getBookListCollection(context: context, token: token);

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

  void getIncidentFilterSearch({
    required String token,
    required BuildContext context,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      incidentDataList.value = [];
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

    var response = await ApiManager.request(
      endpoint: ApiManager.getIncidentFilterSearch,
      method: "POST",
      body: {
        "page": pageNumber,
        // "department_id": selectedDepartment?.value?.id ?? "",
        //  "severity": selectedSeverity.value?.title ?? "",
        "start_date": datefromFilter.value,
        "end_date": dateToFilter.value,
        "search": searchString.value,
        // "page": 1,
        "page_size": pageSize,
      },
      token: token,
    );

    try {
      if (response.statusCode == 200) {
        incidentdata.value = IncidentFormResponse.fromJson(
          response as Map<String, dynamic>,
        );

        print("xres" + response.toString());

        final newData = incidentdata.value?.data ?? [];
        if (newData.isNotEmpty) {
          incidentDataList.addAll(newData);
          // pageNo.value++;
        } else {
          isMoreDataAvailable.value = false; // No more pages to load
          SnackBarHelper.showNormalSnackBar(context, "No more items...");
        }

        // Get.snackbar("Success", "Login Successful");

        //  SnackBarHelper.showSuccessSnackBar(context, "Profile Fetched");

        print("hii" + incidentdata.value!.data.length.toString());
      } else {
        // Get.snackbar("Login Failed", response["message"] ?? "Error occurred");
        SnackBarHelper.showFailureSnackBar(context, "Error occurred");
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

  void updateSubscribedStatus(
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
  }
}
