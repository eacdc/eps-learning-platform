import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final String title;
  final bool obscureText;
  final bool mandatory;
  final Widget suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator; // Validator function
  final int? maxLength;  //  new parameter
  final TextInputType? keyboardType;  // new parameter
  final TextInputFormatter? inputFormatter; //  new parameter

  const InputField({
    Key? key,
    required this.hintText,
    required this.title,
    this.obscureText = false,
    this.mandatory = false,

    this.prefixIcon,
    required this.suffixIcon,
    required this.controller,
    this.onChanged,
    this.onSaved,
    this.validator, // Initialize validator
    this.maxLength, // new
    this.keyboardType, // new
    this.inputFormatter, // new
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Visibility(visible: mandatory, child: SizedBox(width: 3)),
              Visibility(
                visible: mandatory,
                child: Text(
                  "*",
                  style: TextStyle(
                    fontSize: 15,
                    color: redcolor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
             maxLength: maxLength, //  limit input length
            keyboardType: keyboardType, //  set keyboard type
           // inputFormatters: (inputFormatter!=null)?[inputFormatter!]:null,
            inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: heading6.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer.withAlpha(150),
              ),
              border: customBorder(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer.withAlpha(80),
              ),
              enabledBorder: customBorder(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer.withAlpha(80),
              ),
              focusedBorder: customBorder(color: primarycolor),
              errorBorder: customBorder(color: Colors.red),
              disabledBorder: customBorder(color: bordercolor),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

InputBorder customBorder({
  Color color = Colors.grey,
  double width = 1,
  double radius = 32.0,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: width),
  );
}
