import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';


class CommonDropdownButton<T> extends StatelessWidget {
  final T? chosenValue;
  final String? hintText;
  final String? title;
  final List<T>? itemsList;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? displayField; // Function to extract display text

  CommonDropdownButton({
    Key? key,
    this.chosenValue,
    this.hintText,
    this.title,
    this.itemsList,
    this.onChanged,
    this.validator,
    required this.displayField, // Required function to extract the display text
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
              style:TextStyle(
                    fontSize: 12.5,
                    color: textBlack,
                    fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(
              hintText: hintText,
              fillColor: Colors.transparent,
              hintStyle: heading6.copyWith(color: textGrey),
              focusColor: Colors.transparent,
              filled: true,
              border: customBorder(color: bordercolor),
              enabledBorder: customBorder(color: bordercolor),
              focusedBorder: customBorder(color: primarycolor),
              errorBorder: customBorder(color: Colors.red),
              disabledBorder: customBorder(color: bordercolor),
              // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              //  isDense: false, // Reduces extra vertical space
            ),
            isExpanded: true,
            validator: validator,
            //icon: SvgPicture.asset("assets/icons/svg_dropdown.svg",height: 10,width: 10,),

            icon: const Icon(Icons.arrow_drop_down,
                size: 11, color: Colors.black),
            // iconSize: 10,
            value: chosenValue,
            items: itemsList?.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayField!(item), // Extract display text dynamically
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              );
            }).toList(),
            onChanged: onChanged,
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
