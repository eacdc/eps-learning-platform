import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';



class PrimaryButton extends StatelessWidget {
  final Color buttonColor;
  final String textValue;
  final String? startIcon;
  final String? endIcon;
  final double? height;


  final Color textColor;
  final bool loading;
  final Function() onPressed;

  PrimaryButton({
    required this.buttonColor,
    required this.textValue,
    required this.textColor,
    required this.onPressed,
    this.loading = false,
    this.startIcon,
    this.endIcon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      //can add color here and remove from box decoration for ripple effect
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        splashColor: whitecolor.withAlpha(50), // Optional: adjust splash color
        child: Ink(
          decoration: BoxDecoration(
            color: buttonColor,
            /*  gradient: LinearGradient(
            colors: [primarycolor, primarycolor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), */
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            height: height??45,
            alignment: Alignment.center,
            child: loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
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
                          color: whitecolor,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        textValue,
                        style: heading6.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),

                      if (endIcon != null) ...[
                        const SizedBox(width: 5),
                        Image.asset(
                          endIcon!,
                          width: 14,
                          height: 14,
                          color: whitecolor,
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
