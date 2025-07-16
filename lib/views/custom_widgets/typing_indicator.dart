import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';

class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  String dots = '';
// late Timer _timer;

  @override
  void initState() {
    super.initState();
  /*   _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (dots.length == 3) {
          dots = '';
        } else {
          dots += '.';
        }
      });
    }); */
  }

  @override
  void dispose() {
   // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          //'AI Thinking$dots',
          'AI Thinking',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8),
        Image.asset(
          "assets/icons/aigif.gif",
          height: 24.0,
          width: 24.0,
          color: primarycolor,
        )
      ],
    );
  }
}
