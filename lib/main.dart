import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/screen/dashboard/dashboardpage.dart';
import 'package:test_your_learing/views/screen/splashpage/splashscreen.dart';
import 'views/screen/authentication/onboarding/onboarding_screen.dart';
import 'views/screen/authentication/getstartedscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get.put(InternetController(), permanent: true);

  await SharedPreferencesService.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: whitecolor,
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      theme: ThemeData(
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
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        // GetPage(name: "/login", page: () => LoginPage()),
        /*  GetPage(
              name: "/home", page: () => HomePage(),  ), */
        GetPage(name: "/splash", page: () => SplashScreenPage()),
        GetPage(name: "/onboard", page: () => OnboardingScreen()),
        GetPage(name: "/dashboard", page: () => DashboardPage()),
        GetPage(name: "/getStarted", page: () => GateStatrtedScreen()),
        // GetPage(name: "/splash", page: () => GateStatrtedScreen()),
        /*   GetPage(
              name: "/reportDetails",
              page: () => ReportDetailsPage(),
              transition: Transition.leftToRight), */
      ],
      initialRoute: "/splash",
    );
  }
}
