import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';

class ThemeSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const ThemeSwitch({
    Key? key,
    this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  late bool switchStatus;
  late IconData knobIcon;
  late Alignment knobAlignment;

  final IconData darkThemeIcon = Icons.grid_view;
  final IconData lightThemeIcon = Icons.menu_rounded;
  //final IconData lightThemeIcon = Icons.dehaze;

  @override
  void initState() {
    super.initState();
    switchStatus = widget.initialValue;
    knobIcon = switchStatus ? lightThemeIcon : darkThemeIcon;
    knobAlignment = switchStatus ? Alignment.centerRight : Alignment.centerLeft;
  }

  void toggleSwitch() {
    setState(() {
      switchStatus = !switchStatus;
      knobIcon = switchStatus ? lightThemeIcon : darkThemeIcon;
      knobAlignment =
          switchStatus ? Alignment.centerRight : Alignment.centerLeft;
    });

    widget.onChanged(switchStatus);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 75,
        height: 36,
        curve: Curves.decelerate,
        decoration: BoxDecoration(
          color: lightGraytext.withAlpha(40),
          border: Border.all(color: lightGraytext.withAlpha(30)!, width: 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 28,
                  width: 28,
                  child: Icon(darkThemeIcon, size: 16, color: blackmedium),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 28,
                  width: 28,
                  child: Icon(lightThemeIcon, size: 16, color: blackmedium),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: knobAlignment,
              curve: Curves.decelerate,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: whitecolor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(knobIcon, size: 16, color: primarycolor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




 /* ThemeSwitch(
      initialValue: dashboardController.isListStyle.value,
      onChanged: (value) {
        dashboardController.changeListStyle(value);
      },
    ), */