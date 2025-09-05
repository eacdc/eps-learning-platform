import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';

class CircularBackButton extends StatelessWidget {
  final String? iconPath;
  final Function() onPressed;

  CircularBackButton({this.iconPath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      //borderRadius: BorderRadius.circular(50.0),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        splashColor: lightwhitetext,
        child: Container(
          height: 38,
          width: 38,
          padding: EdgeInsets.all(11),
          decoration: BoxDecoration(
           //color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100), width: 1),
          ),
          child: SvgPicture.asset(
            "assets/icons/svg_back_arrow.svg",
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn),
            width: 15,
            height: 15,
          ),
        ),
      ),
    );
  }
}
