import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/collection_controller.dart';
import 'package:test_your_learing/controllers/my_subscription_controller.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';

import 'qnapage/qna_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<QuizPage> {
  final mysubscriptionController = Get.put(MysubscriptionController());
  //final EventSubmitController eventSubmitController = Get.find();
  //final ProfileController profileController = Get.find();

  ScrollController scrollController = ScrollController();

  late int employee_id;
  late String token;

  Widget _buildFilterItem(
    String label,
    bool hasIcon,
    String iconpath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,

      /* () {
        // setState(() {
        //   selectedFilter = label;
        // });
        // if (hasIcon) _showBottomSheet(label);
      } */
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? primarycolor : whitecolor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: lightgreytext),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIcon) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                decoration: BoxDecoration(
                  color: isSelected ? whitecolor : primarycolor.withAlpha(25),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Image.asset(
                  iconpath,
                  height: 12,
                  width: 12,
                  color: primarycolor,
                  //color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: 4),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : blacktext,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    employee_id = 0;
    //SharedPreferencesService.getEmployeeId();
    token = SharedPreferencesService.getAccessToken();
    //SharedPreferencesService.getAccessToken();

    mysubscriptionController.getSubscriptionList(
      token: token,
      context: context,
      reloadpage: true,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reach end");
        mysubscriptionController.pageNo.value =
            mysubscriptionController.pageNo.value + 1;
        /*   mysubscriptionController.getIncidentFilterSearch(
          token: token,
          context: context,
          pageNumber: mysubscriptionController.pageNo.value,
        ); */

        //get More Task
      }
    });

    // profileController.getEmployeeProfile(employee_id, token, context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: lightwhitetext,
        child: Stack(
          // fit: StackFit.loose,
          //  alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment:CrossAxisAlignment.start, // Align items to the start
              //  mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 1),
              /*   Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    // color: redcolor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: InkWell(
                          onTap: () {
                            // _showModal(context, collectionController);
                          },
                          child: SearchField(),
                        ),
                      ),
                      SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween, // Evenly distribute items
                          children: [
                            _buildFilterItem(
                              "All",
                              true,
                              "assets/icons/png_all_category.png",
                              mysubscriptionController.allfilter.value,
                              () {},
                            ),
                            SizedBox(width: 8),
                            _buildFilterItem(
                              "Science",
                              true,
                              "assets/icons/png_science_category.png",
                              false,
                              () {},
                            ),
                            SizedBox(width: 8),
                            _buildFilterItem(
                              "Mathematics",
                              true,
                              "assets/icons/png_math_category.png",
                              false,
                              () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
 */
                
                
                /*  (dashboardController.incidentdata.value?.data ?? [])
                              .isNotEmpty */
                mysubscriptionController.mySubscriptionList.value.isNotEmpty
                    ? Expanded(
                      // height: 200,
                      //   color: blackcolor,
                      child: ListView.builder(
                        controller: scrollController,

                        /*  controller: ScrollController()
                                  ..addListener(() {
                                    
                                  /*   if (dashboardController.isLoading.isFalse &&
                                        dashboardController.hasNextPage.isTrue &&
                                        dashboardController
                                            .incidentDataList.isNotEmpty) {
                                      dashboardController.getIncidentFilterSearch(
                                        token: token, // Add your token here
                                        context: context,
                                        pageNumber:
                                            dashboardController.pageNo.value,
                                      );
                                    } */
                                  }), */
                        //physics: NeverScrollableScrollPhysics(),
                        //  shrinkWrap: true,
                        itemCount:
                            mysubscriptionController.mySubscriptionList.length,
                        itemBuilder: (context, index) {
                          final bookData =
                              mysubscriptionController
                                  .mySubscriptionList
                                  .value[index];
                          return bookListItem(
                            imageUrl: bookData.bookCoverImgLink ?? "",
                            title: bookData.bookTitle ?? "",
                            progress: 0.0,
                            // onViewChapter: () => print("View chapter tapped"),
                            onViewChapter: () {
                              _showChapterBottomsheet(
                                context,
                                mysubscriptionController,
                                bookData.bookId ?? "",
                                token,
                              );
                            },
                            onSubscribe: () {
                              Get.defaultDialog(
                                title: bookData.bookTitle ?? "",
                                middleText: 'Do you want to unsubscribe?',
                                textCancel: 'Cancel',
                                textConfirm: 'Unsubscribe',
                                confirmTextColor: Colors.white,
                                buttonColor: primarycolor,
                                onConfirm: () {
                                  Get.back(); // Close the dialog
                                  // TODO: Call your unsubscribe function here
                                  print('User confirmed unsubscribe');
                                  mysubscriptionController.unsubscribeBook(
                                    token: token,
                                    context: context,
                                    bookId: bookData.bookId ?? "",
                                  );
                                },
                                onCancel: () {
                                  Get.back();
                                  // Optional: Handle cancel action
                                  print('User canceled');
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.all(80),
                      child: Image.asset("assets/images/png_no_collection.png"),
                      //child:Text(dashboardController.bookCollectionList.value.length.toString()),
                    ),
              ],
            ),
            Visibility(
              visible: mysubscriptionController.isLoading.value,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: primarycolor.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    color: whitecolor,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 4.5,
                    color: primarycolor.withOpacity(0.8),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Report {
  final String severity;
  final String department;
  final String description;
  final String date;
  final String time;
  final int imageCount;

  Report({
    required this.severity,
    required this.department,
    required this.description,
    required this.date,
    required this.time,
    required this.imageCount,
  });
}

Widget bookListItem({
  required String imageUrl,
  required String title,
  required double progress, // from 0.0 to 1.0
  required VoidCallback onViewChapter,
  required VoidCallback onSubscribe,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Book Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 80,
            height: 110,
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
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: progressColorLight.withAlpha(80),
                color: progressColor,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
              // View Chapter + Subscribe
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // View Chapter
                  Expanded(
                    child: GestureDetector(
                      onTap: onViewChapter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: const Text(
                            "View Chapter",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Subscribe Text
                ],
              ),
              const SizedBox(height: 10),

              /* GestureDetector(
                onTap: onSubscribe,
                child: Center(
                  child: Text(
                    "Unsubscribe",
                    style: TextStyle(
                      color: primarycolor,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ), */
            ],
          ),
        ),
      ],
    ),
  );
}

void _showChapterBottomsheet(
  context,
  MysubscriptionController mySubscriptionController,
  String bookId,
  String token,
) {
  //final TextEditingController searchTextController = TextEditingController();
  //collectionController.searchServices("");

  mySubscriptionController.getBookChapter(
    context: context,
    token: token,
    bookId: bookId,
  );

  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
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
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  Container(
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
                  // 🔍 Search Header

                  // 📃 Result List
                  Expanded(
                    child: Obx(() {
                      final results = mySubscriptionController.bookChapterList;

                      if (mySubscriptionController.isLoading.value) {
                        return Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: primarycolor.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                    0,
                                    2,
                                  ), // changes position of shadow
                                ),
                              ],
                              color: whitecolor,
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 4.5,
                              color: primarycolor.withOpacity(0.8),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        );
                      }

                      if (results.isEmpty) {
                        return Center(
                          child: Text(
                            "No Chapters Found",
                            style: TextStyle(
                              fontSize: 16,
                              color: primarycolor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        itemCount: results.length,
                        separatorBuilder: (context, _) => Divider(),
                        itemBuilder: (context, index) {
                          final chapterdata = results[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100, //  Background color
                              borderRadius: BorderRadius.circular(
                                16,
                              ), //  Curved border
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          color: primarycolor.withAlpha(30),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 16,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
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
                                        'chapterName': chapterdata.title ?? '',
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
                                      borderRadius: BorderRadius.circular(50),
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
              );
            },
          ),
        ),
      );
    },
  );
}
