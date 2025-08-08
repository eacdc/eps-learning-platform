import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/dashboard_controller.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/custom_dashboard_switch.dart';
import 'package:test_your_learing/views/custom_widgets/custom_switch.dart';
import 'package:test_your_learing/views/screen/dashboard/collection/collectionpage.dart';
import 'package:test_your_learing/views/screen/dashboard/homepage/homepage.dart';
import 'package:test_your_learing/views/screen/dashboard/my_library/mysubscription.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profilepage.dart';
import 'package:test_your_learing/views/screen/dashboard/quiz/quizpage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final dashboardController = Get.put(DashboardController());

  //int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Center(child: Text("Home")),
    HomePage(),
    MySubscriptionPage(),
    QuizPage(),
    CollectionPage(),
    ProfilePage(),
  ];

  /* 
 Option 2: Use a getter instead of a field
 If you want _actionWidget to stay fresh based on the current state, use a getter:

List<Widget> get _actionWidget => [
  SizedBox.shrink(),
  SizedBox.shrink(),
  SizedBox.shrink(),
  ThemeSwitch(
    initialValue: dashboardController.isGrid.value,
    onChanged: (value) {
      dashboardController.changeGridType(value);
    },
  ),
  SizedBox.shrink(),
]; */

  /* final List<Widget> _actionWidget = [
    // Center(child: Text("Home")),
    SizedBox.shrink(),
    SizedBox.shrink(),
    SizedBox.shrink(),
    ThemeSwitch(
      //initialValue: false,
      initialValue: dashboardController.isGrid.value,
      onChanged: (value) {
       // print("Switch is now: $value");
        // You can toggle themes here
        dashboardController.changeGridType(value);
      },
    ),
    SizedBox.shrink(),
  ]; */

  late List<Widget> _actionWidget;

  final List<String> _pagesname = [
    // Center(child: Text("Home")),
    "Home",
    "My Library",
    "Quiz",
    "Collection",
    "My Profile",
  ];

  void _onItemTapped(int index) {
    /* setState(() {
      _selectedIndex = index;
    }); */
    dashboardController.changeIndex(index);
  }

  Widget _buildBottomNavItem({
    required String svgon,
    required String svgoff,
    required IconData icon,
    required String label,
    required int index,
  }) {
    return Obx(() {
      final _selectedIndex = dashboardController.selectedIndex.value;

      return Material(
        color: Colors.transparent,
        //borderRadius: BorderRadius.circular(30),
        shape: const CircleBorder(), // Ensures circular ripple
        child: InkWell(
          onTap: () => _onItemTapped(index),
          splashColor: primaryBlue.withAlpha(24), // Light blue ripple
          //  highlightColor: Colors.lightBlue.withOpacity(0.1), // Light tap color
          customBorder: const CircleBorder(),
          child: Container(
            //color: redcolor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*  Icon(
                icon,
                color: _selectedIndex == index ? primarycolor : Colors.grey,
              ),
           */
                /* SvgPicture.asset(
                _selectedIndex == index ? svgon : svgoff,
                semanticsLabel: 'My SVG Image',
                height: 18,
                width: 18,
              ), */
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  /* transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                }, */
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    final offsetAnimation = Tween<Offset>(
                      begin:
                          _selectedIndex == index
                              ? const Offset(0, -0.2)
                              : const Offset(0, 0), // from top
                      //begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },

                  child: SvgPicture.asset(
                    _selectedIndex == index ? svgon : svgoff,
                    key: ValueKey<bool>(_selectedIndex == index), // important!
                    semanticsLabel: 'My SVG Image',
                    height: 18,
                    width: 18,
                  ),
                ),

                SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: _selectedIndex == index ? primarycolor : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*  // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ); */

    _actionWidget = [
      SizedBox.shrink(),
      DashboardSwitch(onChanged: (value) {}),
      DashboardSwitch(onChanged: (value) {}),
      DashboardSwitch(
        //initialValue: dashboardController.isListStyle.value,
        onChanged: (value) {
          // dashboardController.changeListStyle(value);
        },
      ),
      SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _selectedIndex = dashboardController.selectedIndex.value;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor:
              _selectedIndex != 0
                  ? whitecolor
                  : Color(0xff6DC2C6), // Your desired status bar color
          statusBarIconBrightness: Brightness.dark, // Icons: light or dark
        ),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset:
                false, // for stop floting Fab button on keyboard
            body: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: _pages[_selectedIndex],
            ),
            appBar:
                _selectedIndex != 0
                    ? AppBar(
                      toolbarHeight: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(0),
                        ),
                      ),
                      elevation: 20,
                      backgroundColor: whitecolor,
                      surfaceTintColor: Colors.transparent,
                      //  title: const Text(Constants.appname),
                      automaticallyImplyLeading: false, //remove back button
                      flexibleSpace: Stack(
                        children: [
                          /* ClipRect(
                          // Clips the extra space
                          child: SvgPicture.asset(
                            "assets/icons/svg_bubbleicon2.svg",
                            height: 60,
                            fit: BoxFit.cover, // Ensures it stretches properly
                            clipBehavior: Clip.hardEdge, // Cuts unwanted padding
                          ),
                        ), */
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 8),
                                height: 50,
                                // color: redcolor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 20),
                                    /*  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      // color: whitecolor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.asset(
                                      "assets/icons/logo.png",
                                      height: 36,
                                      width: 36,
                                      // color: primarycolor,
                                    ),
                                  ), */
                                    SizedBox(width: 2),
                                    Text(
                                      _pagesname[_selectedIndex] ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: blacktext,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Spacer(),
                                    _actionWidget[_selectedIndex] ??
                                        SizedBox.shrink(),
                                    SizedBox(width: 12),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Divider(height: 1, color: textWhiteGrey),
                            ],
                          ),
                        ],
                      ),
                      /* actions: _selectedIndex == 2
                      ? [
                          InkWell(
                            onTap: () => oepnLogoutDialog(context),
                            /*  Improper onTap Method Invocation: In your InkWell widget, 
                     you are calling the oepnLogoutDialog method instead of passing it as a function reference.
                      This will execute the method immediately when the widget is built, 
                      rather than when the user taps on it. */
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: whitecolor),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.settings_power_outlined,
                                  color: primarycolor,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ]
                      : null, */
                    )
                    : null,
            bottomNavigationBar: BottomAppBar(
              height: 65,
              //shape: const CircularNotchedRectangle(),
              color: textWhiteGrey,
              padding: EdgeInsets.all(4),
              notchMargin: 0.0,
              child: Container(
                height: 20,
                // color: redcolor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildBottomNavItem(
                        svgon: "assets/icons/svg_home_on.svg",
                        svgoff: "assets/icons/svg_home_off.svg",
                        icon: Icons.home_outlined,
                        label: "Home",
                        index: 0,
                      ),
                    ),
                    Expanded(
                      child: _buildBottomNavItem(
                        svgon: "assets/icons/svg_bookmark_on.svg",
                        svgoff: "assets/icons/svg_bookmark_off.svg",
                        icon: Icons.bookmark_border,
                        label: "My Library",
                        index: 1,
                      ),
                    ),

                    Expanded(
                      child: _buildBottomNavItem(
                        svgon: "assets/icons/svg_circular_dot.svg",
                        svgoff: "assets/icons/svg_circular_dot.svg",
                        icon: Icons.circle,
                        label: "Quiz",
                        index: 2,
                      ),
                    ),
                    // SizedBox(width: 40), // Space for the center circular item
                    Expanded(
                      child: _buildBottomNavItem(
                        svgon: "assets/icons/svg_collection_on.svg",
                        svgoff: "assets/icons/svg_collection_off.svg",
                        icon: Icons.article_outlined,
                        label: "Collection",
                        index: 3,
                      ),
                    ),
                    Expanded(
                      child: _buildBottomNavItem(
                        svgon: "assets/icons/svg_profile_on.svg",
                        svgoff: "assets/icons/svg_profile_off.svg",
                        icon: Icons.person_outline,
                        label: "Profile",
                        index: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton:
            /* MediaQuery.of(context).viewInsets.bottom != 0
                    ? null
                    : FAB */
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                //color: blackmedium,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primarycolor,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow:
                            _selectedIndex == 2
                                ? [
                                  BoxShadow(
                                    color: primarycolor.withAlpha(50),
                                    blurRadius: 20,
                                    spreadRadius: 8,
                                  ),
                                ]
                                : [],
                      ),

                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin:
                                  _selectedIndex == 2
                                      ? const Offset(0, -0.2)
                                      : const Offset(0, 0), // from top
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child:
                            _selectedIndex == 2
                                ? SvgPicture.asset(
                                  "assets/icons/svg_message_white.svg",
                                  key: const ValueKey(
                                    'selected',
                                  ), // triggers the animation
                                  semanticsLabel: 'My SVG Image',
                                  height: 24,
                                  width: 24,
                                )
                                : SvgPicture.asset(
                                  "assets/icons/svg_message_white.svg",
                                  key: const ValueKey(
                                    'unselected',
                                  ), // static version
                                  semanticsLabel: 'My SVG Image',
                                  height: 24,
                                  width: 24,
                                ),
                      ),
                    ),
                    // SizedBox(height: 4),
                    /*         Text(
                    'Quiz',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _selectedIndex == 2 ? primarycolor : Colors.grey,
                    ),
                  ), */
                  ],
                ),
              ),
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        ),
      );
    });
  }
}
