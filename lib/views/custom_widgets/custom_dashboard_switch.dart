import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/controllers/dashboard_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';

import '../../constants/colors.dart';

class DashboardSwitch extends StatefulWidget {
  // final bool initialValue;
  final ValueChanged<bool> onChanged;

  const DashboardSwitch({
    Key? key,
    // this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DashboardSwitchState createState() => _DashboardSwitchState();
}

class _DashboardSwitchState extends State<DashboardSwitch> {
  final dashboardController = findOrPut(() => DashboardController());
  late bool switchStatus;
  //late IconData knobIcon;
  //late Alignment knobAlignment;

  final IconData gridIcon = Icons.grid_view;
  final IconData listIcon = Icons.menu_rounded;
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
      var switchStatus = dashboardController.isListStyle.value;
      return GestureDetector(
        onTap: () {
          //toggle
          dashboardController.isListStyle.value = !switchStatus;
        },
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
                    child: Icon(gridIcon, size: 16, color: blackmedium),
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
                    child: Icon(listIcon, size: 16, color: blackmedium),
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
                      switchStatus ? listIcon : gridIcon,
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
