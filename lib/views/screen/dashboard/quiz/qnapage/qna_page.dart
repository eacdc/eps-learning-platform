import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/views/screen/dashboard/quiz/qnapage/chatwidget.dart';

import '../../../../../theme.dart';
import '../../../../custom_widgets/circular_back_button.dart';

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
 ;

     return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Container(
                  // color: Colors.yellow,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircularBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                       Text(
                        "Chapter ($chapterName)" ,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
              Spacer(),
              Divider(color: textWhiteGrey, height: 1),
            ],
          ),
        ),
        body: ChatWidget(chapterId: chapterId,chapterName:chapterName), ),
    );
  }
}
