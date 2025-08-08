import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/utils/app_colors.dart';



class SecondaryButton extends StatelessWidget {
  final Color buttonColor;
  final String textValue;
  final Color textColor;
  final bool loading;
  final Function() onPressed;

  SecondaryButton({
    required this.buttonColor,
    required this.textValue,
    required this.textColor,
    required this.onPressed,
    this.loading = false,
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
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: primarycolor),
           /*  gradient: LinearGradient(
              colors: [
                primarycolor,
                primarycolor
              ], // Replace with your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), */
            color: Colors.transparent,
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
                : Text(
                    textValue,
                    style: heading6.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
          ),
        ),
      ),
    );
  }
}
