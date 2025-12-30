import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/collection_controller.dart';
import 'package:test_your_learing/controllers/my_subscription_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';
import 'package:test_your_learing/views/custom_widgets/secondary_button.dart';
import 'package:test_your_learing/views/screen/dashboard/ask_learn/ask_ai_page.dart';

import '../../../../models/collection_model/books_collection_list.dart';
import '../../../../models/my_subscription_model/my_subscription_model.dart';
import '../../../../models/my_subscription_model/mycollection_model.dart';
import '../../../custom_widgets/progressbar_widget.dart';
import 'qnapage/qna_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<QuizPage> {
  //final mysubscriptionController = Get.put(MysubscriptionController());
  late MysubscriptionController mysubscriptionController;
  //final EventSubmitController eventSubmitController = Get.find();
  //final ProfileController profileController = Get.find();

  ScrollController scrollController = ScrollController();

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

    //SharedPreferencesService.getEmployeeId();
    mysubscriptionController = findOrPut(() => MysubscriptionController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      token = SharedPreferencesService.getAccessToken();
      //SharedPreferencesService.getAccessToken();

      /* mysubscriptionController.getSubscriptionList(
        token: token,
        context: context,
        reloadpage: true,
      ); */

      mysubscriptionController.getMyBooksCollectionFilter(
        token: token,
        context: context,
        reloadpage: true,
      );
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reach end");
        mysubscriptionController.pageNo.value =
            mysubscriptionController.pageNo.value + 1;
        mysubscriptionController.getMyBooksCollectionFilter(
          token: token,
          context: context,
          pageNumber: mysubscriptionController.pageNo.value,
        );

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
        color: Theme.of(context).colorScheme.surface,
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

                mysubscriptionController.bookCollectionList.value.isNotEmpty
                    ? Expanded(
                      // height: 200,
                      //   color: blackcolor,
                      child: ListView.builder(
                        controller: scrollController,

                        itemCount:
                            mysubscriptionController.bookCollectionList.length,
                        itemBuilder: (context, index) {
                          final bookData =
                              mysubscriptionController
                                  .bookCollectionList
                                  .value[index];
                          return bookListItem(
                            imageUrl: bookData.coverImage ?? "",
                            title: bookData.title ?? "",
                            progress: 0.0,
                            // onViewChapter: () => print("View chapter tapped"),
                            onViewChapter: () {
                              _showChapterBottomsheet(
                                context,
                                mysubscriptionController,
                                bookData.bookId ?? "",
                                bookData,
                                token,
                              );
                            },
                            onSubscribe: () {
                              Get.defaultDialog(
                                title: bookData.title ?? "",
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
                            context: context,
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

            ProgressBarWidget(
              visible: mysubscriptionController.isLoading.value,
            ),
          ],
        ),
      ),
    );
  }
}

Widget bookListItem({
  required String imageUrl,
  required String title,
  required double progress, // from 0.0 to 1.0
  required VoidCallback onViewChapter,
  required VoidCallback onSubscribe,
  required BuildContext context,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(40),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
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
  MysubscriptionController mysubscriptionController,
  String bookId,
  BookCollectionModel bookData,
  String token,
) {
  //final TextEditingController searchTextController = TextEditingController();
  //collectionController.searchServices("");

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
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                        Theme.of(context).colorScheme.onSurface,
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
                              bookData.coverImage ?? "",
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
                                      Row(
                                        children: [
                                          Text(
                                            "Publisher - ",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          // SizedBox(width: 10),

                                          //  Spacer(),
                                          Text(
                                            bookData.author ?? "",
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
                                color: Theme.of(context).colorScheme.onSurface,
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
                              child: Column(
                                children: [
                                  Row(
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
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
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
                                            fontSize: 15,
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

                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: SecondaryButton(
                                          buttonColor: primarycolor,
                                          textValue: "Learn",
                                          textColor: primarycolor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Get.to(
                                              () => const AskAiPage(),
                                              arguments: {
                                                'chapterId':
                                                    chapterdata.id ?? '',
                                                'chapterName':
                                                    chapterdata.title ?? '',
                                                'bookId':
                                                    chapterdata.bookId ?? '',
                                              },
                                            );
                                          },
                                          height: 34,
                                          startIcon: "assets/images/learn.png",
                                        ),
                                      ),
                                      SizedBox(width: 24),
                                      Expanded(
                                        child: PrimaryButton(
                                          buttonColor: primarycolor,
                                          textValue: "Start Quiz",
                                          textColor: whitecolor,
                                          startIcon: "assets/images/quiz.png",
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Get.to(
                                              () => const QnaPage(),
                                              arguments: {
                                                'chapterId':
                                                    chapterdata.id ?? '',
                                                'chapterName':
                                                    chapterdata.title ?? '',
                                                'bookId':
                                                    chapterdata.bookId ?? '',
                                              },
                                            );
                                          },
                                          height: 34,
                                        ),
                                      ),
                                    ],
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
