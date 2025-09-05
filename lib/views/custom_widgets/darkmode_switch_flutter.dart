import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/controllers/dashboard_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/utils/getxtheme/theme_controller.dart';

import '../../constants/colors.dart';

class DarkModeSwitch extends StatefulWidget {
  // final bool initialValue;
  final ValueChanged<bool> onChanged;

  const DarkModeSwitch({
    Key? key,
    // this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DashboardSwitchState createState() => _DashboardSwitchState();
}

class _DashboardSwitchState extends State<DarkModeSwitch> {
  final themeController = findOrPut(() => ThemeController());
  late bool switchStatus;
  //late IconData knobIcon;
  //late Alignment knobAlignment;

  final IconData darkIcon = Icons.dark_mode_outlined;
  final IconData lightIcon = Icons.light_mode_outlined;
  //final IconData lightThemeIcon = Icons.dehaze;

  @override
  void initState() {
    super.initState();
    //switchStatus = dashboardController.isListStyle.value;
    //  knobIcon = switchStatus ? listIcon : gridIcon;
    // knobAlignment = switchStatus ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var switchStatus = themeController.isDarkMode.value;
      return GestureDetector(
        onTap: () {
          //toggle
          //dashboardController.isListStyle.value = !switchStatus;
          themeController.toggleTheme();
        // / widget.onChanged(switchStatus);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 75,
          height: 36,
          curve: Curves.decelerate,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            border: Border.all(color:  Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80), width: 1),
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
                    child: Icon(lightIcon, size: 16, color: Theme.of(context).colorScheme.onSecondaryContainer),
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
                    child: Icon(darkIcon, size: 16, color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    switchStatus ? Alignment.centerRight : Alignment.centerLeft,
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
                    child: Icon(
                      switchStatus ? darkIcon : lightIcon,
                      size: 16,
                      color: primarycolor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
