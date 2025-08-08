import 'package:flutter/material.dart';
import 'package:test_your_learing/views/screen/dashboard/quiz/qnapage/chatwidget.dart';

class VoiceChatPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<VoiceChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: ChatWidget(chapterId: "fghjk",chapterName: "yuio",),
      ),
    );
  }}