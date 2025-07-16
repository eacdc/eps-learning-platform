import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';

class InputDescField extends StatelessWidget {
  final String hintText;
  final String? title;
  final int minline;
  final bool obscureText;
  final Widget suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController controller;

  const InputDescField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.minline = 2,
    this.prefixIcon,
    this.title,
    required this.suffixIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                title ?? "",
                style: TextStyle(fontSize: 12, color: textcol_medium,fontWeight: FontWeight.w500),
              ),
            )),
        SizedBox(
          height: 6,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            // color: textWhiteGrey,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            controller: controller,
            minLines: minline,
            maxLines: 20,
            obscureText: obscureText,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: heading6.copyWith(color: textGrey),
                border: customBorder(color: bordercolor),
                enabledBorder: customBorder(color: bordercolor),
                focusedBorder: customBorder(color: primarycolor),
                errorBorder: customBorder(color: Colors.red),
                disabledBorder: customBorder(color: bordercolor),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // suffixIcon: suffixIcon,
                prefixIcon: prefixIcon ?? prefixIcon),
          ),
        ),
      ],
    );
  }
}

InputBorder customBorder({
  Color color = Colors.grey,
  double width = 1,
  double radius = 10.0,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: width),
  );
}
