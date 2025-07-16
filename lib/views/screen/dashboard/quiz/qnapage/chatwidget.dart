import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/models/qna_model/chatmessage_model.dart';
import 'package:test_your_learing/views/custom_widgets/typing_indicator.dart';

import '../../../../../controllers/qna_controller.dart';

class ChatWidget extends StatefulWidget {
  final String chapterId;
  final String chapterName;

  const ChatWidget({
    Key? key,
    required this.chapterId,
    required this.chapterName,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();

  final qnaController = Get.put(QnaController());

  bool isTyping = false;
  late final AnimationController _dotsController;
  late final Animation<int> _dotsAnimation;
  late final String token;
  late final String userId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    token = SharedPreferencesService.getAccessToken();
    userId = SharedPreferencesService.getUserId();

    qnaController.getChatHistoryCollection(
      token: token,
      context: context,
      chapterId: widget.chapterId,
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _dotsAnimation = StepTween(begin: 1, end: 3).animate(_dotsController);

    /*   WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }); */

    /*   ever(qnaController.chatMessageList, (_) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }); */

    // Scroll when chat list updates
    ever(qnaController.chatMessageList, (_) => _scrollToBottom());

    // Optional: Scroll when typing changes
    //ever(qnaController.isTyping.obs, (_) => _scrollToBottom());
    ever(qnaController.aiThinking, (_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    // 1 Add user message immediately to the chat list
    qnaController.chatMessageList.add(
      ChatMessageModel(
        role: 'user',
        content: text.trim(),
        isAudio: false,
        audioFileId: null,
        messageId: null,
        timestamp: DateTime.now().toIso8601String(),
        id: DateTime.now().toIso8601String(),
      ),
    );

    //  Call API to send the message and wait for response
    qnaController.sendChatMessage(
      token: token,
      context: context,
      chapterId: widget.chapterId,
      userId: userId,
      message: text,
    );

    setState(() {
      //chatMessages.add({'text': text, 'isUser': true});
      messageController.clear();
      isTyping = true;
    });

    /*   Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        chatMessages.add({
          'text': "This is a sample answer for Chapter ID: ${widget.chapterId}",
          'isUser': false,
        });
        isTyping = false;
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Stack(
          children: [
            Container(
              color: lightwhite4,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: whitecolor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      //'Q&A Chat ${qnaController.chatMessageList.length.toString()}',
                      widget.chapterName,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /*  Visibility(
                    visible: qnaController.aiThinking.value,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.redAccent,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 10,
                    ),
                  ), */

                  /*  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: chatMessages.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isTyping && index == chatMessages.length) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: AnimatedBuilder(
                                animation: _dotsController,
                                builder: (context, child) {
                                  String dots = '.' * _dotsAnimation.value;
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Typing$dots',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
              
                        final message = chatMessages[index];
                        return Align(
                          alignment:
                              message['isUser']
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  message['isUser']
                                      ? Colors.blueAccent
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message['text'],
                              style: TextStyle(
                                color:
                                    message['isUser'] ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  */
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            qnaController.chatMessageList.length +
                            (qnaController.aiThinking.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (qnaController.aiThinking.value &&
                              index == qnaController.chatMessageList.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: AnimatedBuilder(
                                  animation: _dotsController,
                                  builder: (context, child) {
                                    String dots = '.' * _dotsAnimation.value;
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: lightwhitetext,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: TypingIndicator(),
                                      /*  const Text(
                                        'AI Thinking...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ), */
                                    );
                                  },
                                ),
                              ),
                            );
                          }

                          final message = qnaController.chatMessageList[index];
                          bool isUser = message.role == 'user';

                          return Align(
                            alignment:
                                isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              constraints: const BoxConstraints(
                                maxWidth:
                                    300, // Limit max width to avoid too wide bubbles
                              ),
                              decoration: BoxDecoration(
                                color: isUser ? primarycolor : lightwhitetext,
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      isUser
                                          ? Radius.circular(16)
                                          : Radius.circular(0),
                                  topRight:
                                      isUser
                                          ? Radius.circular(0)
                                          : Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: MarkdownWidget(
                                data: message.content,
                                shrinkWrap:
                                    true, // Important: prevents infinite height
                                physics:
                                    const NeverScrollableScrollPhysics(), // no inner scroll
                                config: MarkdownConfig(
                                  configs: [
                                    PConfig(
                                      textStyle: TextStyle(
                                        color:
                                            isUser
                                                ? Colors.white
                                                : Colors
                                                    .black87, // 🔑 Your required color
                                        fontSize: 15,
                                      ),
                                    ),
                                    LinkConfig(
                                      style: TextStyle(
                                        color:
                                            isUser
                                                ? Colors.white
                                                : Colors.black87,
                                        decoration: TextDecoration.underline,
                                      ),
                                      onTap: (url) {
                                        // handle link
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.send, color: primarycolor),
                          onPressed: sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: qnaController.isLoading.value,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: primarycolor.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    color: whitecolor,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 4.5,
                    color: primarycolor.withOpacity(0.8),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
