import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';

class TitleDescWidget extends StatelessWidget {
  final String title;
  final String desc;
  final Color? descColor;
  final bool? isLoading;

  const TitleDescWidget({
    Key? key,
    required this.title,
    required this.desc,
    this.descColor,
    this.isLoading = false,
    // this.descColor=Colors.amber, // Optional color without default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final halfWidth = Constants.screenWidthPercentage(context, 0.5);
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: lightGrayBg.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: graytext,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          isLoading!
              ? Shimmer.fromColors(
                baseColor: shimmerBaseColor2,
                highlightColor:shimmerHighlightColor2,
                child: Container(
                  width: double.maxFinite,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              )
              : Text(
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
