import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/chapter_model/chapter_model.dart';
import 'package:test_your_learing/models/collection_model/books_collection_list.dart';
import 'package:test_your_learing/models/qna_model/chat_response_nodel.dart';
import 'package:test_your_learing/models/askAi_model/ask_message_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';

import '../models/askAi_model/ask_ai_response.dart';

class AskAiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  var aiThinking = false.obs;

  var pageNo = 1.obs;

  //var selectedDepartment = Rxn<Department>(); // Holds the selected department
  //var selectedSeverity = Rxn<Severity>(); // Holds the selected department

  ScrollController scrollController = ScrollController();

  //var incidentDataList = <Incident>[].obs; // List to store paginated data
  // var hasNextPage = true.obs; // Tracks if more pages are available

  var isMoreDataAvailable = true.obs; // Tracks if more pages are available

  var chatMessageList = List<AskAiMessageModel>.empty().obs;

  void _handleScrollForReverseList(AskAiMessageModel message) {
    if (!scrollController.hasClients) return;

    final context = message.key.currentContext;
    if (context == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final messageHeight = renderBox.size.height;
    final viewportHeight = scrollController.position.viewportDimension;

    if (messageHeight <= viewportHeight) {
      // Short message → show bottom (default behavior)

      print("lesss");
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    } else {
      // Tall message → show top of message
      // In reverse mode, top means scrolling down by messageHeight - viewportHeight
      final offset = (messageHeight - viewportHeight).clamp(0, double.infinity);
      scrollController.jumpTo(offset.toDouble());
      /*  scrollController.animateTo(
        offset.toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ); */
    }
  }

  void addMessageToList(AskAiMessageModel newChatModel) {
    chatMessageList.add(newChatModel);

    // Wait for the UI to build so we can measure
    Future.delayed(const Duration(milliseconds: 50), () {
      _handleScrollForReverseList(newChatModel);
    });
  }

  AskAiController() {}

  @override
  onInit() async {
    super.onInit();
    //call api if data required initially
    //getUserToken()
    //fetch data

    //paginate task
    // paginateTask();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void getAskHistoryCollection({
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

      //  selectedDepartment.value = null;
      //  selectedSeverity.value = null;

      /* ********* refresh page no*/

      pageNo.value = 1;
    }

    var response = await ApiManager.requestNew(
      endpoint: ApiManager.askHistoryList(chapterId),
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
          List<AskAiMessageModel> chatList =
              (response.data as List)
                  .map((item) => AskAiMessageModel.fromJson(item))
                  .toList();
          // use books
          chatMessageList.value = chatList;


          /*   // Scroll to top of the new message if needed
          Future.delayed(const Duration(milliseconds: 50), () {
            if (scrollController.hasClients) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            }
          }); */
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
            AskAiMessageModel chatList = AskAiMessageModel.fromJson(
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

  void sendAskMessage({
    required String token,
    required BuildContext context,
    required String chapterId,
    required String userId,
    required String message,
  }) async {
    aiThinking.value = true;

    final aiLoadingModel = AskAiMessageModel(
      role: 'assistant',
      content: "Ai Thinking...",
      isAudio: false,
      audioFileId: null,
      messageId: null,
      timestamp: DateTime.now().toIso8601String(),
      id: DateTime.now().toIso8601String(),
      aiLoading: true, // Set aiLoading to true for the new message
    );

    addMessageToList(aiLoadingModel);

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
      endpoint: ApiManager.askChat,
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
            AskAiResponse chatResponseModel = AskAiResponse.fromJson(
              response.data,
            );

            print("xxx3");
            // use single book

            final chatModel = AskAiMessageModel(
              id: DateTime.now().toIso8601String(),
              role: 'assistant',
              content: chatResponseModel.response ?? "Something Went Wrong",
              isAudio: false,
              audioFileId: null,
              messageId: null,
              timestamp: DateTime.now().toIso8601String(),
            );

            addMessageToList(chatModel);

            // visible Score Graphics

            /* final num? markAwarded =
                chatResponseModel.score?.marksAwarded;
            final num? markMax =
                chatResponseModel.score?.maxMarks;

           // if (markAwarded != null && markMax != null) {
            if (true) {
              scoreCardOpacity.value = 1.0;
              scoreValue.value = " $markAwarded / $markMax";
              Future.delayed(const Duration(seconds: 10), () {
                scoreCardOpacity.value = 0.0;
                scoreValue.value ="";
              });
            } */
          }
        } else {
          print("Unhandled response format");
        }
      } else {
        print("Request failed: ${response.statusCode}");

        if (response.data.containsKey('error')) {
          /*   final chatXModel = ChatMessageModel(
            id: DateTime.now().toIso8601String(),
            role: 'assistant',
            content:
                //"ttttttttttttttttttt",
                "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum(The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham",
            isAudio: false,
            audioFileId: null,
            messageId: null,
            timestamp: DateTime.now().toIso8601String(),
          );

          addMessageToList(chatXModel); */

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
      chatMessageList.remove(aiLoadingModel);
    }
  }

  Future<File> loadAssetFileToTemp(String assetPath, String filename) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  void sendAudioFile({
    required String token,
    required BuildContext context,
    required File file,
    required String userId,
    required String chapterId,
  }) async {
    isLoading.value = true;

    final uri = Uri.parse(ApiManager.baseUrl + ApiManager.sendAudio);

    final request = http.MultipartRequest("POST", uri);

    // Add headers
    // request.headers['Authorization'] = 'Bearer $token';
    request.headers.addAll({'Authorization': 'Bearer $token'});

    // Add form fields
    request.fields['userId'] = userId;
    request.fields['chapterId'] = chapterId;

    // Get file extension
    String extension = path.extension(file.path).replaceFirst('.', '');

    // Add image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio', // <-- field name used in backend
        file.path,
        filename: basename(file.path),
        contentType: MediaType(
          'audio',
          extension ?? "mp3",
        ), // Optional if required by backend
      ),
    );

    /* // Usage:
    final file = await loadAssetFileToTemp(
      'assets/audio/hello.mp3',
      'hello.mp3',
    );
    print('File exists: ${file.existsSync()}');
    print('File size: ${file.lengthSync()} bytes');
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        file.path,
        filename: 'hello.mp3',
        contentType: MediaType('audio', 'mp3'),
      ),
    );

    print("jkl" + request.files.toString()); */
    // Send request
    final response = await request.send();

    try {
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> data = json.decode(responseData.body);

        if (data is Map) {
          if (data.containsKey('transcription') &&
              data.containsKey('redirect')) {
            //SnackBarHelper.showSuccessSnackBarGetx(data['transcription']);
            chatMessageList.add(
              AskAiMessageModel(
                id: DateTime.now().toIso8601String(),
                role: 'user',
                content: data['transcription'] ?? "",
                isAudio: true,
                audioFileId: null,
                messageId: null,
                timestamp: DateTime.now().toIso8601String(),
              ),
            );

            sendAskMessage(
              token: token,
              context: context,
              chapterId: chapterId,
              userId: userId,
              message: data['transcription'] ?? "",
            );
          }
        } else {
          print("Unhandled response format");
          SnackBarHelper.showFailureSnackBarGetx(
            "Something went wrong: ${response.toString()}",
          );
        }
      } else {
        SnackBarHelper.showFailureSnackBarGetx(
          "Something went wrong: ${response.toString()}",
        );
      }
    } catch (e) {
      SnackBarHelper.showFailureSnackBarGetx(e.toString());

      /*       isMoreDataAvailable.value = false; // No more pages to load
      SnackBarHelper.showNormalSnackBar(context, "No more items..."); */
    } finally {
      isLoading.value = false;
      // Close BottomSheet only if it's still open
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
