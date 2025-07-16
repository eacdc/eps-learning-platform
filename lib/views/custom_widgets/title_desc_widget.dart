import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';

class TitleDescWidget extends StatelessWidget {
  final String title;
  final String desc;
  final Color? descColor;

  const TitleDescWidget({
    Key? key,
    required this.title,
    required this.desc,
    this.descColor, 
   // this.descColor=Colors.amber, // Optional color without default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding:EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
      decoration: BoxDecoration(
        color: lightGrayBg.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
       
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:  TextStyle(
              fontSize: 12,
              color:  graytext,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            desc,
            style: TextStyle(
              fontSize: 14,
              color: blacktext,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
