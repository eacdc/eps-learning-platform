import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';

class SearchInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode; // ✅ Add this line
  final ValueChanged<String>? onTextChanged;

  const SearchInputField({
    super.key,
    this.hintText = 'Search books & quizzes',
    this.controller,
    this.focusNode, // ✅ Initialize here
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: lightgreytext),
        borderRadius: BorderRadius.circular(10.0),
        color: whitecolor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode, // ✅ Use the passed focusNode
              onChanged: onTextChanged,
              style: TextStyle(
                color: blackmedium,
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: lightgreytext2,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Image.asset(
            "assets/icons/png_search_black.png",
            height: 18,
            width: 18,
            color: gray,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
