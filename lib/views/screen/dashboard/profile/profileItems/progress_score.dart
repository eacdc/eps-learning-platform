import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/profile/scoreand_progress_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/assesment_data.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';

import '../../../../../controllers/homeController/home_controller.dart';
import '../../../../../controllers/score_controller.dart';
import '../../../../../helper/sharedpreference_helper.dart'
    show SharedPreferencesService;
import '../../../../custom_widgets/progressbar_widget.dart';

class ProgressScorePage extends StatefulWidget {
  const ProgressScorePage({super.key});

  @override
  State<ProgressScorePage> createState() => _ProgressScorePageState();
}

class _ProgressScorePageState extends State<ProgressScorePage> {
  late final ScoreAndProgressController scoreand_progress_controller;
  late final ScoreController scoreController;

  @override
  void initState() {
    super.initState();

    scoreand_progress_controller = findOrPut(
      () => ScoreAndProgressController(),
    );
    scoreController = findOrPut(() => ScoreController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      final userId = SharedPreferencesService.getUserId() ?? '';

      /* scoreand_progress_controller.getScoreAndProgress(
        token: token,
        userid: userId,
        context: context,
      ); */

      scoreController.getAllUnifiedScore(
        token: token,
        context: context,
        userId: userId,
      );

      scoreController.getUnifiedScore(
        token: token,
        context: context,
        userId: userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Container(
                  // color: Colors.yellow,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircularBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        'Scores & Progress',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
              Divider(color: Theme.of(context).dividerColor, height: 1),
            ],
          ),
        ),
        body: Obx(() {
          /* final scoreboard =
              scoreController.all_unified_score.value?.data; */

               final unified_scoreboard =
          scoreController.all_unified_score.value?.data?.scoreboard;
             final unified_basic =
          scoreController.all_unified_score.value?.data?.basic;


          

          final String booksStarted =
              (unified_basic?.booksStarted?.toString() ?? 'N/A');
          final String chaptersCompleted =
               (unified_basic?.chaptersCompleted?.toString() ?? 'N/A');
          final String quizzesTaken =
              (unified_basic?.quizzesTaken?.toString() ?? 'N/A');
          final String overallScore =
              (unified_basic?.overallScore?.toString() ?? 'N/A');

          final assesment_data =
              scoreController.unified_score.value?.data?.assessmentData;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  SizedBox(height: 16),
                            GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.4,
                                  ),
                              children: [
                                buildDashboardItem(
                                  topColor: spcard1,
                                  bottomColor: spcard1,
                                  value: booksStarted,
                                  iconPath:
                                      'assets/icons/score_progress/png_sp_books_started.png',
                                  description: 'Books Started',
                                  onTap: () => print('Tapped Total Sales'),
                                ),
                                buildDashboardItem(
                                  topColor: spcard2,
                                  bottomColor: spcard2,
                                  value: chaptersCompleted,
                                  iconPath:
                                      'assets/icons/score_progress/png_sp_completed_chapter.png',
                                  description: 'Completed Chapters',
                                  onTap: () => print('Tapped New Users'),
                                ),
                                buildDashboardItem(
                                  topColor: spcard3,
                                  bottomColor: spcard3,
                                  value: quizzesTaken,
                                  iconPath:
                                      'assets/icons/score_progress/png_sp_message.png',
                                  description: 'Quizzes Taken',
                                  onTap: () => print('Tapped New Users'),
                                ),
                                buildDashboardItem(
                                  topColor: spcard4,
                                  bottomColor: spcard4,
                                  value: overallScore,
                                  iconPath:
                                      'assets/icons/score_progress/png_sp_overalscore.png',
                                  description: 'Overall Score',
                                  onTap: () => print('Tapped New Users'),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Assesment Data",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Text("View all", style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),

                            (assesment_data == null)
                                ? Center(
                                  child: SizedBox(
                                    height: 110,

                                    child: Image.asset(
                                      "assets/icons/score_progress/png_sp_no_assesment.png",
                                    ),
                                  ),
                                )
                                : AssesmentDataCard(
                                  assesmentData: assesment_data,
                                ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
                ProgressBarWidget(
                  visible: scoreand_progress_controller.isLoading.value,
                ),
              ],
            ),
          );
        }),
      ),
    );
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
    child: Stack(
      children: [
        Container(
          height: 100,
          width: double.maxFinite,
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

              // Value Text
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -1,
          right: 2,
          child: Image.asset(
            iconPath,
            width: 50,
            height: 50,
            //color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
