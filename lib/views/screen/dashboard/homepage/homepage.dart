import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/homeController/home_controller.dart';
import 'package:test_your_learing/models/home_model/recent_activity_model.dart';
import 'package:test_your_learing/utils/app_colors.dart';
import 'package:test_your_learing/utils/getxtheme/theme_controller.dart';
import 'package:test_your_learing/views/custom_widgets/progressbar_widget.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';
import 'package:test_your_learing/views/screen/dashboard/homepage/notificationpage.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../controllers/my_subscription_controller.dart';
import '../../../../controllers/score_controller.dart';
import '../../../../helper/getx_helper.dart';
import '../../../../helper/sharedpreference_helper.dart'
    show SharedPreferencesService;
import '../../../../models/my_subscription_model/my_subscription_model.dart';
import '../../../custom_widgets/performance_overview_card.dart';
import '../quiz/qnapage/qna_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController homeController;
  late final String token;
  late final String userId;
  final dashboardController = findOrPut(() => DashboardController());
  final mysubscriptionController = findOrPut(() => MysubscriptionController());
  final scoreController = findOrPut(() => ScoreController());

  void _showChapterBottomsheet(
    context,
    MysubscriptionController mysubscriptionController,
    String bookId,
    Book bookData,
    String token,
  ) {
    //final TextEditingController searchTextController = TextEditingController();
    //mysubscriptionController.searchServices("");

    mysubscriptionController.getBookChapter(
      context: context,
      token: token,
      bookId: bookId,
    );

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              MediaQuery.of(
                context,
              ).viewInsets, // 👈 Pushes up when keyboard shows
          child: SafeArea(
            child: DraggableScrollableSheet(
              expand: false,

              /* .............. */
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              /* ............... */
              builder: (
                BuildContext context,
                ScrollController scrollController,
              ) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // 🔵 Fixed Header Section (non-scrollable)
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                              bottom: 1,
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: lightbluetext,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: Text(
                                    "Book Details",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(thickness: 1, color: lightbluetext),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Material(
                              color: lightbluetext,
                              elevation: 0,
                              borderRadius: BorderRadius.circular(32),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(32),
                                splashColor: primarycolor.withAlpha(50),
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    // color: lightbluetext, // insted added it in material color for ripple effect
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /* Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 50,
                      child: Stack(
                        children: [
                          Align(
                            child: Text(
                              "Chapters",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: blackmedium,
                              ),
                              // style: MyTextStyles.mediumSemiboldBlack(context),
                            ),
                          ),
                          /* Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                iconSize: 18,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ), */
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: bordercolor,
                      thickness: 0.5,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: 8),
                    // 🔍 Search Header */
                      const SizedBox(height: 10),

                      // book details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Book Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                bookData.bookCoverImgLink ?? "",
                                width: 70,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/logo.png', // Your local default image
                                    width: 80,
                                    height: 110,
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Right Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Book Name
                                  Text(
                                    bookData.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Subject - ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            //SizedBox(width: 10),

                                            //  Spacer(),
                                            Text(
                                              bookData.subject ?? "",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 2),
                                        /* Row(
                                        children: [
                                          Text(
                                            "Publisher - ",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: graytext,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          // SizedBox(width: 10),

                                          //  Spacer(),
                                          Text(
                                            bookData.publisher ?? "",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: graytext,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2), */
                                        Row(
                                          children: [
                                            Text(
                                              "Grade - ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            //SizedBox(width: 10),

                                            //  Spacer(),
                                            Text(
                                              bookData.grade ?? "",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Progress Bar
                                  /*  LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: progressColorLight.withAlpha(80),
                                      color: progressColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ), */
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chapters :",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Container(
                                width: 45,
                                height: 1.5,
                                decoration: BoxDecoration(
                                  color: lightGray,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 📃 chapter List
                      Expanded(
                        child: Obx(() {
                          final results =
                              mysubscriptionController.bookChapterList;

                          if (mysubscriptionController.isChapterLoading.value) {
                            return Center(
                              child: ProgressBarWidget(
                                visible:
                                    mysubscriptionController
                                        .isChapterLoading
                                        .value,
                              ),
                            );
                          }

                          if (results.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    //margin: EdgeInsets.only(top: 30),
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset(
                                      "assets/images/png_no_collection.png",
                                    ),
                                    //  child: Center(child: Text("No Category Found")),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "No Chapters Found",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: primarycolor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: results.length,
                            //  separatorBuilder: (context, _) => Divider(),
                            itemBuilder: (context, index) {
                              final chapterdata = results[index];

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withAlpha(150), //  Background color
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), //  Curved border
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withAlpha(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primarycolor.withAlpha(25),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: primarycolor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              chapterdata.title ?? "No Name",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                /* height:
                                                  1.4, */
                                                // improves readability for multi-line
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Get.to(
                                          () => const QnaPage(),
                                          arguments: {
                                            'chapterId': chapterdata.id ?? '',
                                            'chapterName':
                                                chapterdata.title ?? '',
                                            'bookId': chapterdata.bookId ?? '',
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primarycolor,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: const Text(
                                          'Start Quiz',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    homeController = findOrPut(() => HomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      token = SharedPreferencesService.getAccessToken() ?? '';
      userId = SharedPreferencesService.getUserId() ?? '';
      homeController.getRecentActivity(
        token: token,
        userid: userId,
        context: context,
      );

      /* homeController.getScoreBoard(
        token: token,
        userid: userId,
        context: context,
      ); */

      scoreController.getUnifiedScore(
        token: token,
        context: context,
        userId: userId,
      );

      homeController.getChapterStats(
        token: token,
        context: context,
        userid: userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return Obx(() {
      final recentBooks =
          homeController.recent_activity.value?.data?.recentBooks ?? [];

      /*    final scoreboard = homeController.scoreboard.value?.data?.summary;
     
      final String quizInProgress =
          (scoreboard?.totalQuizzesInProgress?.toString() ?? 'N/A');
      final String quizCompleted =
          (scoreboard?.totalCompletedQuizzes?.toString() ?? 'N/A');
      final String totalHours =
          (scoreboard?.totalHoursSpent?.toString() ?? 'N/A');
      final String pointsEarned =
          (scoreboard?.totalPointsEarned?.toString() ?? 'N/A'); */

      final unifiedscore = scoreController.unified_score.value?.data?.basic;

      final String quizInProgress =
          (unifiedscore?.chaptersInProgress?.toString() ?? 'N/A');
      final String quizCompleted =
          (unifiedscore?.chaptersCompleted?.toString() ?? 'N/A');
      final String totalHours =
          (unifiedscore?.totalTimeSpentHours?.toString() ?? 'N/A');
      final String pointsEarned =
          (unifiedscore?.totalPointsEarned?.toString() ?? 'N/A');

      return Container(
        // color: Theme.of(context).colorScheme.surface,
        color: themeColors.surface,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: homeGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),

                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image.asset(
                        "assets/images/png_vector_wave.png",
                        //width: 120,
                        height: 120,
                      ),
                      Container(
                        // height: 200,
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
                                  Shimmer.fromColors(
                                    baseColor: whitecolor,
                                    highlightColor: shimmerHighlightColor2,
                                    loop: 1,
                                    period: Duration(seconds: 3),
                                    child: Text(
                                      "Hello, user!",
                                      style: TextStyle(
                                        color: lightwhite1,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                // color: redcolor,
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: InkWell(
                                  onTap: () {
                                    //   print("Search Field Tapped");
                                    dashboardController.changeIndex(3);
                                  },
                                  child: SearchField(),
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                        InkWell(
                                          onTap: () {
                                            _showChapterBottomsheet(
                                              context,
                                              mysubscriptionController,
                                              books.bookId ?? "",
                                              books,
                                              token,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: whitecolor.withAlpha(50),
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                              child: Image.asset(
                                "assets/images/png_no_recentactivity.png",
                              ),
                              //  child: Center(child: Text("No Category Found")),
                            ),
                          ),
                ),

                SizedBox(height: 16),
                PerformanceOverviewCard(
                  chapterStats:
                      homeController.chapterStates.value?.data?.overall,
                  onChanged: (value) {
                    homeController.getChapterStats(
                      token: token,
                      context: context,
                      userid: userId,
                      filter: value,
                    );
                  },
                ),
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
