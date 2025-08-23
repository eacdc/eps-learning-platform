import 'dart:io';
import 'dart:math' as math;

import 'package:glow_container/glow_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/helper/snackbar_helper.dart';
import 'package:test_your_learing/models/qna_model/chatmessage_model.dart';
import 'package:test_your_learing/utils/selector.dart';
import 'package:test_your_learing/views/custom_widgets/typing_indicator.dart';

import '../../../../../controllers/qna_controller.dart';
import '../../../../custom_widgets/chat_tringle.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:waveform_recorder/waveform_recorder.dart';
//import 'package:audioplayers/audioplayers.dart' hide AudioPlayer;
import 'package:audioplayers/audioplayers.dart' as AP;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waved_audio_player/waved_audio_player.dart';

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
  //late final AnimationController _dotsController;
  //late final Animation<int> _dotsAnimation;
  late final String token;
  late final String userId;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false, isPlaying = false;
  String? recordingPath;

  bool isVoiceRecording = false, isVoicePlaying = false;

  final _textController = TextEditingController();
  final _waveController = WaveformRecorderController();

  @override
  void initState() {
    super.initState();

    token = SharedPreferencesService.getAccessToken();
    userId = SharedPreferencesService.getUserId();

    /* _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _dotsAnimation = StepTween(begin: 1, end: 3).animate(_dotsController);
 */
    // After the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qnaController.getChatHistoryCollection(
        token: token,
        context: context,
        chapterId: widget.chapterId,
      );

      _focusNode.addListener(() async {
        if (_focusNode.hasFocus) {
          // If you remove the delay sometimes the scroll doesnt animate completely at the end
          await Future.delayed(const Duration(milliseconds: 150));
          _scrollToBottom();
        }
      });
      // This is if you want to automatically toggle the keyboard when visitting the screen
      // _focusNode.requestFocus();
    });

    // Scroll when chat list updates
    ever(qnaController.chatMessageList, (_) => _scrollToBottom());

    // Optional: Scroll when typing changes
    //ever(qnaController.isTyping.obs, (_) => _scrollToBottom());
    ever(qnaController.aiThinking, (_) => _scrollToBottom());

    /* _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    }); */
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 1501), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1700),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    //_dotsController.dispose();
    _waveController.dispose();
    messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    qnaController.dispose();
    super.dispose();
  }

  void sendMessage(String text) {
    // String text = messageController.text.trim();
    if (text.isEmpty) return;

    // 1 Add user message immediately to the chat list

    qnaController.addMessageToList(
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
    /* qnaController.chatMessageList.add(
      ChatMessageModel(
        role: 'user',
        content: text.trim(),
        isAudio: false,
        audioFileId: null,
        messageId: null,
        timestamp: DateTime.now().toIso8601String(),
        id: DateTime.now().toIso8601String(),
      ),
    ); */

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

              /*    decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/chat_background.jpg"),
                  opacity: 1,
                  fit: BoxFit.cover, 
                ),
              ), */
              child: Column(
                children: [
                  /*  InkWell(
                    onTap: () {
                      //_scrollToBottom();
                      if (recordingPath != null) {
                        // Play the audio file
                        //_audioRecorder.play(recordingPath!);
                        if (_audioPlayer.playing) {
                          _audioPlayer.stop();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          _audioPlayer
                              .setFilePath(recordingPath!)
                              .then((_) {
                                _audioPlayer.play();
                                setState(() {
                                  isPlaying = true;
                                });
                              })
                              .catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error playing recording: $error",
                                    ),
                                  ),
                                );
                              });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No recording available to play."),
                          ),
                        );
                      }
                    },
                    child: Text(
                      recordingPath == null
                          ? "No Recording"
                          : isPlaying
                          ? "Stop Playing"
                          : "Play Recording",

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
 */
                  Expanded(
                    child: Obx(
                      () =>
                          qnaController.chatMessageList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      //margin: EdgeInsets.only(top: 30),
                                      padding: EdgeInsets.all(5),
                                      child: Image.asset(
                                        "assets/images/png_no_collection.png",
                                      ),
                                      //  child: Center(child: Text("No Category Found")),
                                    ),
                                    SizedBox(height: 2),
                                    (qnaController.isLoading.value)
                                        ? SizedBox.shrink()
                                        : InkWell(
                                          onTap: () {
                                            sendMessage("Let's Start");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: primarycolor.withAlpha(20),
                                            ),
                                            child: Text(
                                              "Start Test",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: primarycolor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,

                                controller: qnaController.scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                itemCount: qnaController.chatMessageList.length,
                                /* +(qnaController.aiThinking.value ? 1 : 0) */
                                itemBuilder: (context, index) {
                                  final reversedIndex =
                                      qnaController.chatMessageList.length -
                                      1 -
                                      index;

                                  final message =
                                      qnaController
                                          .chatMessageList[reversedIndex];
                                  bool isUser = message.role == 'user';

                                  if (message.aiLoading
                                  /*  qnaController.aiThinking.value &&
                              reversedIndex ==
                                  qnaController.chatMessageList.length */
                                  ) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        key: message.key,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: _AiThink(
                                          avatar:
                                              "assets/icons/png_ai_avtar.png",
                                          message: "Ai Thinking...",
                                        ),
                                      ),
                                    );
                                  }

                                  return _itemChat(
                                    isUser: isUser,
                                    avatar:
                                        isUser
                                            ? 'assets/images/user_avatar.png'
                                            : 'assets/icons/png_ai_avtar.png',
                                    message: message.content,
                                    time: message.timestamp,
                                    globalkey: message.key,
                                  );
                                },
                              ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        // Optional styling
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            isVoiceRecording
                                ? recorderWidget()
                                : textInputWidget(),
                      ),
                    ),
                  ),

                  /*  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: 8,
                      right: 8,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child:
                          isVoiceRecording
                              ? KeyedSubtree(
                                key: const ValueKey('recorder'),
                                child: recorderWidget(),
                              )
                              : KeyedSubtree(
                                key: const ValueKey('textInput'),
                                child: textInputWidget(),
                              ),
                    ),
                  ),
 */

                  //Container(key: const ValueKey('recorder'), child: recorderWidget())
                ],
              ),
            ),

            Positioned(
              bottom: 90,
              right: 20,
              child:
                  qnaController.scoreCardOpacity != 0.0
                      ? SizedBox.shrink()
                      : AnimatedOpacity(
                        opacity: 1.0,
                        //  opacity: qnaController.scoreCardOpacity.value,
                        duration: const Duration(milliseconds: 300),

                        child: Center(
                          child: GlowContainer(
                            glowRadius: 16,
                            gradientColors: [
                              Colors.blue,
                              Colors.purple,
                              Colors.pink,
                            ],
                            rotationDuration: Duration(seconds: 2),
                            glowLocation: GlowLocation.both,
                            containerOptions: ContainerOptions(
                              width: 120,
                              height: 100,
                              borderRadius: 16,
                              backgroundColor: lightGrayBg,
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            transitionDuration: Duration(milliseconds: 200),
                            showAnimatedBorder: true,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              // width: 50,
                              // height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: whitecolor,
                              ),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    "Curent Score",

                                    style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 6),

                                  Shimmer.fromColors(
                                    baseColor: primarycolor,
                                    highlightColor: primarycolor.withAlpha(50),
                                    loop: 0,
                                    period: Duration(seconds: 2),
                                    child: Text(
                                      " 0/00",
                                      // qnaController.scoreValue.value
                                      style: TextStyle(
                                        color: primarycolor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Total Question",

                                    style: TextStyle(
                                      color: primarycolor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
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

  _itemChat({
    required bool isUser,
    required GlobalKey globalkey,
    String? avatar,
    message,
    String? time,
  }) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        avatar != null
            ? isUser
                ? SizedBox(width: 16)
                : Avatar(image: avatar, size: 24)
            : Text('$time', style: TextStyle(color: Colors.grey.shade400)),

        // Use spread operator for conditional widgets
        /*   ...isUser
            ? [SizedBox(width: 5)]
            : [
              SizedBox(width: 4),
              CustomPaint(painter: Triangle(whitecolor)),
            ], */
        isUser
            ? SizedBox(width: 16)
            : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5),
                CustomPaint(painter: Triangle(whitecolor)),
              ],
            ),

        Flexible(
          child: Container(
            key: globalkey,
            margin: EdgeInsets.only(left: 0, right: 0, top: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser ? primarycolor : whitecolor,

              borderRadius:
                  isUser
                      ? BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                      : BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
            ),
            // child: Text('$message'),
            child:
                isUser
                    ? Text(
                      '$message',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MarkdownWidget(
                          data: message,
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
                                  fontSize: 16,
                                ),
                              ),
                              LinkConfig(
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black87,
                                  decoration: TextDecoration.underline,
                                ),
                                onTap: (url) {
                                  // handle link
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            isUser ? SizedBox.shrink() : Spacer(),
                            Text(
                              formatDateTimeString(time) ?? '',
                              style: TextStyle(
                                color:
                                    isUser
                                        ? Colors.white.withAlpha(50)
                                        : Colors.black87.withAlpha(50),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            isUser ? Spacer() : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
          ),
        ),

        isUser
            ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(painter: Triangle(primarycolor)),
                SizedBox(width: 5),
              ],
            )
            : SizedBox(width: 5),

        isUser
            //? Text('$time', style: TextStyle(color: Colors.grey.shade400))
            //?Avatar(image: avatar, size: 24)
            ? SizedBox(width: 8)
            : SizedBox(width: 16),
      ],
    );
  }

  _AiThink({required String avatar, message}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Avatar(image: avatar, size: 20),
        SizedBox(width: 5),
        CustomPaint(painter: Triangle(whitecolor)),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 0, right: 12, top: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whitecolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            // child: Text('$message'),
            child: TypingIndicator(),
          ),
        ),
      ],
    );
  }

  Widget textInputWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 3, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gray.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              if (isVoiceRecording) {
                return;
              } else {
                var status = await Permission.microphone.status;

                if (status.isGranted) {
                  // Permission granted, start recording

                  await _waveController.startRecording();
                  setState(() {
                    isVoiceRecording = true;
                  });
                } else {
                  // Ask for permission
                  var result = await Permission.microphone.request();
                  if (result.isGranted) {
                    // Permission granted after request, start recording

                    await _waveController.startRecording();
                    setState(() {
                      isVoiceRecording = true;
                    });
                  } else {
                    // Permission denied – you may show a message
                    SnackBarHelper.showFailureSnackBarGetx(
                      "Microphone permission not granted.",
                    );
                  }
                }
              }

              /*   setState(() {
                                      isVoiceRecording= true;
                                    }); */

              /*   if (isRecording) {
                                      /* String? filePath =
                                          await _audioRecorder.stop(); */
                                      await _audioRecorder.stop().then((
                                        filePath,
                                      ) {
                                        if (filePath != null) {
                                          /*  qnaController.sendAudioMessage(
                                            token: token,
                                            context: context,
                                            chapterId: widget.chapterId,
                                            userId: userId,
                                            audioFilePath: filePath,
                                          ); */
                            
                                          recordingPath = filePath;
                                        }
                                        setState(() {
                                          isRecording = false;
                                        });
                                      });
                                    } else {
                                      if (await _audioRecorder
                                          .hasPermission()) {
                                        final Directory appDucumentDirectory =
                                            await getApplicationDocumentsDirectory();
                            
                                        final String filePath = p.join(
                                          appDucumentDirectory.path,
                                          "recording.wav",
                                        );
                                        // Start recording
                            
                                        await _audioRecorder
                                            .start(
                                              const RecordConfig(),
                                              path: filePath,
                                            )
                                            .then((_) {
                                              setState(() {
                                                isRecording = true;
                                                recordingPath = null;
                                              });
                                            });
                                      }
                                    } */
            },
            child: Container(
              decoration: BoxDecoration(
                color: primarycolor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                isRecording
                    ? "assets/icons/svg_send_message.svg"
                    : "assets/icons/svg_microphone.svg",
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(whitecolor, BlendMode.srcIn),
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,

              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: gray, fontSize: 14),
                /* border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        
                                      ), */
                border: InputBorder.none,

                //  filled: true,
                fillColor: whitecolor,
                labelStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            color: primarycolor,
            icon: SvgPicture.asset(
              "assets/icons/svg_send_message.svg",
              height: 20,
              width: 20,
              // colorFilter: ColorFilter.mode(primarycolor, BlendMode.srcIn)
            ),
            onPressed: () => sendMessage(messageController.text.trim()),
            style: IconButton.styleFrom(
              backgroundColor: lightGrayBg,
              foregroundColor: primarycolor,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget recorderWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gray.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListenableBuilder(
        listenable: _waveController,
        builder:
            (context, _) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            color: lightGrayBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              _waveController.isRecording
                                  ? WaveformRecorder(
                                    height: 48,
                                    controller: _waveController,
                                    onRecordingStopped: _onRecordingStopped,
                                  )
                                  : Center(
                                    child: SizedBox(
                                      height: 48,
                                      child: WavedAudioPlayer(
                                        source:
                                            kIsWeb
                                                ? AP.UrlSource(
                                                  _waveController.file!.path,
                                                )
                                                : AP.DeviceFileSource(
                                                  _waveController.file!.path,
                                                ),
                                        // source: AssetSource('assets/sample.mp3'),
                                        iconColor: primarycolor,
                                        iconBackgoundColor: Colors.transparent,
                                        playedColor: primarycolor.withAlpha(
                                          150,
                                        ),
                                        unplayedColor: Colors.grey,
                                        waveWidth: 100,
                                        barWidth: 2,
                                        buttonSize: 40,
                                        showTiming: true,
                                        onError: (error) {
                                          print(
                                            'Error occurred: $error.message',
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                          /* TextField(
                                    controller: _textController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                  ) */
                        ),
                      ),

                      //  const Gap(8),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed:
                          _waveController.isRecording
                              ? () {
                                _waveController.stopRecording();
                                setState(() {
                                  isVoiceRecording = false;
                                });
                              }
                              : () {
                                _waveController.clear();
                                _textController.clear();
                                setState(() {
                                  isVoiceRecording = false;
                                });
                              },
                    ),

                    IconButton(
                      icon: Icon(
                        _waveController.isRecording ? Icons.stop : Icons.mic,
                        color:
                            _waveController.isRecording
                                ? Colors.orange
                                : primarycolor,
                      ),
                      onPressed: _toggleRecording,

                      /*  !_waveController.isRecording &&
                                  _waveController.file != null
                              ? _playRecording
                              : _toggleRecording, */
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        qnaController.sendAudioFile(
                          token: token,
                          context: context,
                          chapterId: widget.chapterId,
                          userId: userId,
                          file: File(_waveController.file!.path),
                        );
                        setState(() {
                          isVoiceRecording = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }

  Future<void> _toggleRecording() => switch (_waveController.isRecording) {
    true => _waveController.stopRecording(),
    false => _waveController.startRecording(),
  };

  Future<void> _onRecordingStopped() async {
    final file = _waveController.file;
    if (file == null) return;

    _textController.text =
        ''
        '${file.name}: '
        '${_waveController.length.inMilliseconds / 1000} seconds';

    debugPrint('XFile properties:');
    debugPrint('  path: ${file.path}');
    debugPrint('  name: ${file.name}');
    debugPrint('  mimeType: ${file.mimeType}');
  }

  Future<void> _playRecording() async {
    final file = _waveController.file;
    if (file == null) return;
    final source =
        kIsWeb ? AP.UrlSource(file.path) : AP.DeviceFileSource(file.path);
    await AP.AudioPlayer().play(source);
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 24, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(3),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
          /* image: new DecorationImage(
            image: AssetImage(image),
          ), */
        ),
        child: Image.asset(image),
      ),
    );
  }
}



//Preveous recording code #record

  /* final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false, isPlaying = false;
  String? recordingPath; */


/* 
 Row(
     children: [
                                InkWell(
                                  onTap: () async {
                                    if (isRecording) {
                                      /* String? filePath =
                                          await _audioRecorder.stop(); */
                                      await _audioRecorder.stop().then((
                                        filePath,
                                      ) {
                                        if (filePath != null) {
                                          /*  qnaController.sendAudioMessage(
                                            token: token,
                                            context: context,
                                            chapterId: widget.chapterId,
                                            userId: userId,
                                            audioFilePath: filePath,
                                          ); */

                                          recordingPath = filePath;
                                        }
                                        setState(() {
                                          isRecording = false;
                                        });
                                      });
                                    } else {
                                      if (await _audioRecorder
                                          .hasPermission()) {
                                        final Directory appDucumentDirectory =
                                            await getApplicationDocumentsDirectory();

                                        final String filePath = p.join(
                                          appDucumentDirectory.path,
                                          "recording.wav",
                                        );
                                        // Start recording

                                        await _audioRecorder
                                            .start(
                                              const RecordConfig(),
                                              path: filePath,
                                            )
                                            .then((_) {
                                              setState(() {
                                                isRecording = true;
                                                recordingPath = null;
                                              });
                                            });
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primarycolor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      isRecording
                                          ? "assets/icons/svg_send_message.svg"
                                          : "assets/icons/svg_microphone.svg",
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        whitecolor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    focusNode: _focusNode,
                                    minLines: 1,
                                    maxLines: 10,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,

                                    decoration: InputDecoration(
                                      hintText: 'Type your message...',
                                      hintStyle: TextStyle(
                                        color: gray,
                                        fontSize: 14,
                                      ),
                                      /* border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        
                                      ), */
                                      border: InputBorder.none,

                                      //  filled: true,
                                      fillColor: whitecolor,
                                      labelStyle: TextStyle(fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  color: primarycolor,
                                  icon: SvgPicture.asset(
                                    "assets/icons/svg_send_message.svg",
                                    height: 20,
                                    width: 20,
                                    // colorFilter: ColorFilter.mode(primarycolor, BlendMode.srcIn)
                                  ),
                                  onPressed: sendMessage,
                                  style: IconButton.styleFrom(
                                    backgroundColor: lightGrayBg,
                                    foregroundColor: primarycolor,
                                    shape: CircleBorder(),
                                  ),
                                ),
                              ],
                            ), */


 // Just Audio Play Player
 //
/* InkWell(
      
      
                    onTap: () {
                      //_scrollToBottom();
                      if (recordingPath != null) {
                        // Play the audio file
                        //_audioRecorder.play(recordingPath!);
                        if (_audioPlayer.playing) {
                          _audioPlayer.stop();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          _audioPlayer
                              .setFilePath(recordingPath!)
                              .then((_) {
                                _audioPlayer.play();
                                setState(() {
                                  isPlaying = true;
                                });
                              })
                              .catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error playing recording: $error",
                                    ),
                                  ),
                                );
                              });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No recording available to play."),
                          ),
                        );
                      }
                    },
                    child: Text(
                      recordingPath == null
                          ? "No Recording"
                          : isPlaying
                          ? "Stop Playing"
                          : "Play Recording",

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ), */
                         


 /*   2. Storage/File Permission — Depends on where you store the file
❓ Where are you saving the recorded file?
✅ If you save it to the app’s internal directory (like using getApplicationDocumentsDirectory()), then you do NOT need storage permission.

❌ If you save it to external storage or custom folders, you do need:

xml
Copy
Edit
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />  */                     