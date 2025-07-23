import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/homeController/home_controller.dart';
import 'package:test_your_learing/utils/app_colors.dart';
import 'package:test_your_learing/views/custom_widgets/progressbar_widget.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';
import 'package:test_your_learing/views/screen/dashboard/homepage/notificationpage.dart';

import '../../../../helper/getx_helper.dart';
import '../../../../helper/sharedpreference_helper.dart'
    show SharedPreferencesService;
import '../../../custom_widgets/performance_overview_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();

    homeController = findOrPut(() => HomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      final userId = SharedPreferencesService.getUserId() ?? '';
      homeController.getRecentActivity(
        token: token,
        userid: userId,
        context: context,
      );

      homeController.getScoreBoard(
        token: token,
        userid: userId,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recentBooks =
          homeController.recent_activity.value?.data?.recentBooks ?? [];
      final scoreboard = homeController.scoreboard.value?.data?.summary;

      final String quizInProgress =
          (scoreboard?.totalQuizzesInProgress?.toString() ?? 'N/A');
      final String quizCompleted =
          (scoreboard?.totalCompletedQuizzes?.toString() ?? 'N/A');
      final String totalHours =
          (scoreboard?.totalHoursSpent?.toString() ?? 'N/A');
      final String pointsEarned =
          (scoreboard?.totalPointsEarned?.toString() ?? 'N/A');

      return Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      // height: 200,
                      decoration: BoxDecoration(
                        gradient: homeGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      50, // Adjust the width to accommodate the border
                                  height:
                                      50, // Adjust the height to accommodate the border
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: lightwhite1, // Border color
                                      width: 1.0, // Border width
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      "assets/images/logo.png",
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(NotificationPage());
                                  },
                                  child: Container(
                                    width:
                                        45, // Adjust the width to accommodate the border
                                    height:
                                        45, // Adjust the height to accommodate the border
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: lightwhite1, // Border color
                                        width: 1.0, // Border width
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/icons/png_notification.png",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Container(
                                  width:
                                      32, // Adjust the width to accommodate the border
                                  height:
                                      32, // Adjust the height to accommodate the border
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whitecolor.withAlpha(40),
                                  ),
                                  child: Image.asset(
                                    "assets/icons/png_user.png",
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Hello, user!",
                                  style: TextStyle(
                                    color: lightwhite1,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Let’s learn something new today!",
                              style: TextStyle(
                                color: lightwhite1,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 24),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                onTap: () {
                                  // _showModal(context, serviceController);
                                },
                                child: SearchField(),
                              ),
                            ),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/png_vector_wave.png",
                      //width: 120,
                      height: 120,
                    ),
                  ],
                ),

                /*   GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  padding: const EdgeInsets.all(16),
                  children: [
                    buildDashboardItem(
                      topColor: const Color(0xff0B7ED7),
                      bottomColor: const Color(0xff069CDD),
                      value: 'n/a',
                      iconPath: 'assets/icons/png_dash_progressquiz.png',
                      description: 'Quizzes In progress',
                      onTap: () => print('Tapped Total Sales'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff5C9602),
                      bottomColor: const Color(0xff8DC900),
                      value: 'n/a',
                      iconPath: 'assets/icons/png_dash_compltedquiz.png',
                      description: 'Completed Quizzes',
                      onTap: () => print('Tapped New Users'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff9962DE),
                      bottomColor: const Color(0xff948DFF),
                      value: 'n/a',
                      iconPath: 'assets/icons/png_dash_totalhour.png',
                      description: 'Total Hours spent',
                      onTap: () => print('Tapped New Users'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff3A9F9F),
                      bottomColor: const Color(0xff00D5AA),
                      value: 'n/a',
                      iconPath: 'assets/icons/png_dash_pointearn.png',
                      description: 'Points earned',
                      onTap: () => print('Tapped New Users'),
                    ),
                  ],
                ),
               */
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,

                    ///crossAxisCount: 2, // Adjust the number of columns as needed
                  ),
                  children: [
                    buildDashboardItem(
                      topColor: const Color(0xff0B7ED7),
                      bottomColor: const Color(0xff069CDD),
                      value: quizInProgress,
                      iconPath: 'assets/icons/png_dash_progressquiz.png',
                      description: 'Quizzes In progress',
                      onTap: () => print('Tapped Total Sales'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff5C9602),
                      bottomColor: const Color(0xff8DC900),
                      value: quizCompleted,
                      iconPath: 'assets/icons/png_dash_compltedquiz.png',
                      description: 'Completed Quizzes',
                      onTap: () => print('Tapped New Users'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff9962DE),
                      bottomColor: const Color(0xff948DFF),
                      value: totalHours,
                      iconPath: 'assets/icons/png_dash_totalhour.png',
                      description: 'Total Hours spent',
                      onTap: () => print('Tapped New Users'),
                    ),
                    buildDashboardItem(
                      topColor: const Color(0xff3A9F9F),
                      bottomColor: const Color(0xff00D5AA),
                      value: pointsEarned,
                      iconPath: 'assets/icons/png_dash_pointearn.png',
                      description: 'Points earned',
                      onTap: () => print('Tapped New Users'),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      // Text("View all", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 150,

                  // child: Image.asset("assets/images/png_no_recentactivity.png"),
                  child:
                      recentBooks.isNotEmpty
                          ? ListView.builder(
                            //physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            shrinkWrap: true,
                            itemCount: recentBooks.length,
                            itemBuilder: (context, index) {
                              final Gradient randomGradient =
                                  getGradientByIndex(index);

                              final books = recentBooks[index];
                              final progressPercentage =
                                  books.progressPercentage ?? 0.0;
                              return Container(
                                width: 270,
                                margin: EdgeInsets.only(right: 1, left: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: randomGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  /*  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(
                                        0,
                                        3,
                                      ), // changes position of shadow
                                    ),
                                  ], */
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Book Image with curved corners
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.network(
                                            books.bookCoverImgLink ?? "",
                                            height: 55,
                                            width: 45,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 24,
                                                  ),
                                                ),
                                          ),
                                        ),

                                        SizedBox(width: 8),

                                        // Title Text with overflow fix
                                        Expanded(
                                          child: Text(
                                            books.title ?? "",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: whitecolor,
                                            ),
                                            textAlign: TextAlign.end,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Center(
                                          child: Text(
                                            "${books.chaptersCompleted ?? 0}/${books.chaptersAttempted ?? 0} Chapters",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: whitecolor,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          //"${books.chaptersCompleted ?? 0}/${books.chaptersAttempted ?? 0} Chapters",
                                          "$progressPercentage% Completed",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: whitecolor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    TweenAnimationBuilder(
                                      tween: Tween<double>(
                                        begin: 0,
                                        end: progressPercentage / 100,
                                      ),
                                      duration: Duration(seconds: 1),
                                      builder: (context, value, child) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: value,
                                            backgroundColor: whitecolor
                                                .withAlpha(50),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  whitecolor,
                                                ),
                                            minHeight: 5,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 8),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Quiz in-Progress",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: whitecolor.withAlpha(200),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: whitecolor.withAlpha(50),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Text(
                                            //"${books.chaptersCompleted ?? 0}/${books.chaptersAttempted ?? 0} Chapters",
                                            "Continue Quiz",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: whitecolor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          : Center(
                            child: Container(
                              //margin: EdgeInsets.only(top: 30),
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text("No Category Found")),
                            ),
                          ),
                ),

                SizedBox(height: 16),
                PerformanceOverviewCard(),
                SizedBox(height: 36),
              ],
            ),

            ProgressBarWidget(visible: homeController.isLoading.value),
          ],
        ),
      );
    });
  }
}

Widget buildDashboardItem({
  required Color topColor,
  required Color bottomColor,
  required String value,
  required String iconPath,
  required String description,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [topColor, bottomColor],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Value Text
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              // Icon
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.asset(
                  iconPath,
                  width: 16,
                  height: 16,
                  //color: Colors.white,
                ),
              ),
            ],
          ),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
