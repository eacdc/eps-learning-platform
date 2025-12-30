import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/utils/app_colors.dart';


class SecondaryButton extends StatelessWidget {
  final Color buttonColor;
  final String textValue;
   final String? startIcon;
  final String? endIcon;
  final Color? bgColor;
  final double? height;

  final Color textColor;
  final bool loading;
  final Function() onPressed;

  SecondaryButton({
    required this.buttonColor,
    required this.textValue,
    required this.textColor,
    required this.onPressed,
    this.loading = false,
     this.startIcon,
    this.endIcon,
    this.bgColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
       color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        splashColor: primarycolor.withAlpha(30),
        child: Container(
          height: height??45,
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor),
           /*  gradient: LinearGradient(
              colors: [
                primarycolor,
                primarycolor
              ], // Replace with your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), */
            color:bgColor?? Colors.transparent,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Center(
            child: loading
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: primarycolor,
                      ),
                    ),
                  )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (startIcon != null) ...[
                        Image.asset(
                          startIcon!,
                          width: 14,
                          height: 14,
                          color: textColor,
                        ),
                        const SizedBox(width: 5),
                      ],Text(
                        textValue,
                        style: heading6.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),

                        if (endIcon != null) ...[
                        const SizedBox(width: 5),
                        Image.asset(
                          endIcon!,
                          width: 14,
                          height: 14,
                          color: textColor,
                        ),
                      ],
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
