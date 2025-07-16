import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/views/screen/dashboard/quiz/qnapage/chatwidget.dart';

class QnaPage extends StatefulWidget {
  const QnaPage({Key? key}) : super(key: key);

  @override
  State<QnaPage> createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  late String chapterId;
  late String bookId;
  late String chapterName;

  @override
  void initState() {
    super.initState();

    // Fetch arguments safely
    final arguments = Get.arguments as Map<String, String>?;

    chapterId = arguments?['chapterId'] ?? "";
    bookId = arguments?['bookId'] ?? "";
    chapterName = arguments?['chapterName'] ?? "";

 /*    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    )); */
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QnA'),
          foregroundColor: blacktext,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: ChatWidget(chapterId: chapterId,chapterName:chapterName),
      ),
    );
  }
}
