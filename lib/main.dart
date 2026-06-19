import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';
import 'package:test_your_learing/views/screen/splashpage/splashscreen.dart';
import 'utils/getxtheme/app_theme.dart';
import 'utils/getxtheme/theme_controller.dart';
import 'views/screen/authentication/onboarding/onboarding_screen.dart';
import 'views/screen/authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get.put(InternetController(), permanent: true);
  await GetStorage.init();

  Get.put(ThemeController()); // inject before runApp

  await SharedPreferencesService.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: whitecolor,
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
      // 👇 Bottom navigation bar
      systemNavigationBarColor: whitecolor, // Background color
      systemNavigationBarIconBrightness: Brightness.dark, // Icon color
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        /*    theme: ThemeData(
        fontFamily: Constants.fontFamily,
        primaryColor: primarycolor,
        cardColor: primarycolor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: primarycolor,
          foregroundColor: Colors.white,
         // backgroundColor: whitecolor 
          /* systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                  ) */
          
        ),
      ), */
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode:
            Get.find<ThemeController>().isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        getPages: [
          // GetPage(name: "/login", page: () => LoginPage()),
          /*  GetPage(
              name: "/home", page: () => HomePage(),  ), */
          GetPage(name: "/splash", page: () => SplashScreenPage()),
          GetPage(name: "/onboard", page: () => OnboardingScreen()),
          GetPage(name: "/dashboard", page: () => DashboardPage()),
          GetPage(name: "/login", page: () => LoginPage()),
          /*   GetPage(
              name: "/reportDetails",
              page: () => ReportDetailsPage(),
              transition: Transition.leftToRight), */
        ],
        initialRoute: "/splash",
      ),
    );
  }
}
