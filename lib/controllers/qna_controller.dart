import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/qna_model/chat_response_nodel.dart';
import 'package:test_your_learing/models/qna_model/chatmessage_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

class QnaController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  var aiThinking = false.obs;

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

  var isMoreDataAvailable = true.obs; // Tracks if more pages are available

  var chatMessageList = List<ChatMessageModel>.empty().obs;

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

  void getChatHistoryCollection({
    required String token,
    required BuildContext context,
    required String chapterId,
    int pageSize = 10, // Default page size is 10
    int pageNumber = 1, // Default page number is 1
    bool reloadpage =
        false, // Default to false , Clear all data and filter value
  }) async {
    if (pageNumber == 1) {
      chatMessageList.value = [];
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

    chatMessageList.clear();

    /*   print(
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
    ); */

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
      endpoint: ApiManager.chatHistoryList(chapterId),
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
          List<ChatMessageModel> chatList =
              (response.data as List)
                  .map((item) => ChatMessageModel.fromJson(item))
                  .toList();
          // use books
          chatMessageList.value = chatList;
        } else if (response.data is Map) {
          if (response.data.containsKey('error') ||
              response.data.containsKey('message')) {
            print(
              "Error: ${response.data['error'] ?? response.data['message']}",
            );

            SnackBarHelper.showFailureSnackBar(
              context,
              response.data['error'] ?? response.data['message'],
            );
          } else {
            ChatMessageModel chatList = ChatMessageModel.fromJson(
              response.data,
            );
            // use single book
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");

        if (response.data.containsKey('error') ||
            response.data.containsKey('message')) {
          print("Error: ${response.data['error'] ?? response.data['message']}");

          SnackBarHelper.showFailureSnackBar(
            context,
            response.data['error'] ?? response.data['message'],
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
    }
  }

  void sendChatMessage({
    required String token,
    required BuildContext context,
    required String chapterId,
    required String userId,
    required String message,
  }) async {
    aiThinking.value = true;

    /*   print(
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
    ); */

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.sendChat,
      method: "POST",
      body: {
        "userId": userId,
        "message": message,
        "chapterId": chapterId, // Optional - for chapter-specific chat
      },
      token: token,
    );

    try {
      if (response.isSuccess) {
        if (response.data is List) {
          /*  List<ChatMessageModel> chatList =
              (response.data as List)
                  .map((item) => ChatMessageModel.fromJson(item))
                  .toList();
          // use books
          chatMessageList.value = chatList; */

          print("xxx1");
        } else if (response.data is Map) {
          if (response.data.containsKey('error')) {
            print(
              "Error: ${response.data['error'] ?? response.data['message']}",
            );
            print("xxx2");
          } else {
            ChatResponseModel chatResponseModel = ChatResponseModel.fromJson(
              response.data,
            );

            print("xxx3");
            // use single book

            chatMessageList.add(
              ChatMessageModel(
                id: DateTime.now().toIso8601String(),
                role: 'assistant',
                content: chatResponseModel.message ?? "Something Went Wrong",
                isAudio: false,
                audioFileId: null,
                messageId: null,
                timestamp: DateTime.now().toIso8601String(),
              ),
            );

            print("xxx4");
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");

          if (response.data.containsKey('error')
           ) {

          SnackBarHelper.showFailureSnackBar(
            context,
            response.data['error'] ?? "Something Went Wrong!",
          );
        }
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBar(context, e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      aiThinking.value = false;
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
