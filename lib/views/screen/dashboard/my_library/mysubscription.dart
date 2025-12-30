import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/dashboard_controller.dart';
import 'package:test_your_learing/controllers/my_subscription_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';

import '../../../../constants/grade_list.dart';
import '../../../../constants/master_list.dart';
import '../../../../models/my_subscription_model/mycollection_model.dart';
import '../../../custom_widgets/primary_button.dart';
import '../../../custom_widgets/progressbar_widget.dart';
import '../../../custom_widgets/search_input_field.dart';
import '../../../custom_widgets/secondary_button.dart';
import '../../../dialogsheet/book_subscribe_sheet.dart';
import '../ask_learn/ask_ai_page.dart';
import '../quiz/qnapage/qna_page.dart';

class MySubscriptionPage extends StatefulWidget {
  const MySubscriptionPage({super.key});

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage> {
  final mysubscriptionController = findOrPut(() => MysubscriptionController());
  final dashboardController = findOrPut(() => DashboardController());
  final searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  ScrollController scrollController = ScrollController();
  bool _showFilterBar = true;
  Timer? _scrollTimer;
  Timer? _debounce;

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
          color:
              isSelected ? primarycolor : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
          ),
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
                  color:
                      isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSubscribeDialog(BookCollectionModel bookData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SubscribeBookSheet(
          title: bookData.title ?? "",
          desc: 'Do you want to unsubscribe this book?',
          bookImage: bookData.coverImage ?? "",
          positiveText: 'Unsubscribe',
          negativeText: "Cancel",
          onPositiveCallback: () {
            mysubscriptionController.unsubscribeBook(
              token: token,
              context: context,
              bookId: bookData.bookId ?? "",
            );
          },
          onNegativeCallback: () {},
          isLoading: mysubscriptionController.isSubscribeLoading,
        );
      },
    );
  }

  void searchUnfocus() {
    if (searchFocus.hasFocus) {
      searchFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();

    token = SharedPreferencesService.getAccessToken();

    mysubscriptionController.searchString.value = "";

    /*  mysubscriptionController.getSubscriptionListFilter(
      token: token,
      context: context,
      reloadpage: true,
    ); */

    mysubscriptionController.getMyBooksCollectionFilter(
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
        mysubscriptionController.getMyBooksCollectionFilter(
          token: token,
          context: context,
          pageNumber: mysubscriptionController.pageNo.value,
        );

        //get More Task
      }

      // Scroll control for filter
      /*  if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // scrolling down
        if (_showFilterBar) setState(() => _showFilterBar = false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // scrolling up
        if (!_showFilterBar) setState(() => _showFilterBar = true);
      } */

      // Always hide filter bar while scrolling
      if (_showFilterBar) {
        setState(() {
          _showFilterBar = false;
        });
      }

      // Cancel any previous timer
      _scrollTimer?.cancel();

      // Start a timer to show the filter bar after scrolling stops
      _scrollTimer = Timer(const Duration(milliseconds: 500), () {
        if (!_showFilterBar) {
          setState(() {
            _showFilterBar = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // scrollController.dispose();
    scrollController.removeListener(() {});
    _scrollTimer?.cancel();
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild cvv");
    return Obx(
      () => Container(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          // fit: StackFit.loose,
          //  alignment: AlignmentDirectional.center,
          //  fit: StackFit.expand,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment:CrossAxisAlignment.start, // Align items to the start
              //  mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 1),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                    left: 16,
                    right: 16,
                  ),
                  padding: EdgeInsets.all(0),
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
                            // _showModal(context, mysubscriptionController);
                          },
                          //  child: SearchField(),
                          child: SearchInputField(
                            controller: searchController,
                            focusNode: searchFocus,
                            onTextChanged: (text) {
                              // Cancel previous timer if still running
                              if (_debounce?.isActive ?? false)
                                _debounce!.cancel();

                              _debounce = Timer(
                                const Duration(milliseconds: 300),
                                () {
                                  print("Search input: $text");
                                  mysubscriptionController.searchString.value =
                                      text;

                                  mysubscriptionController
                                      .getMyBooksCollectionFilter(
                                        context: context,
                                        token: token,
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      /*  SizedBox(height: 4),
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
                              true,
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

                    */

                      //SizedBox(height: 4),
                    ],
                  ),
                ),

                mysubscriptionController.bookCollectionList.value.isNotEmpty
                    ? Expanded(
                      // height: 200,
                      //   color: blackcolor,
                      child:
                          dashboardController.isListStyle.value
                              ? ListView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: 50,
                                ), // adjust as needed
                                controller: scrollController,

                                //physics: NeverScrollableScrollPhysics(),
                                //  shrinkWrap: true,
                                itemCount:
                                    mysubscriptionController
                                        .bookCollectionList
                                        .length,
                                itemBuilder: (context, index) {
                                  final bookData =
                                      mysubscriptionController
                                          .bookCollectionList
                                          .value[index];
                                  return bookListItem(
                                    imageUrl: bookData.coverImage ?? "",
                                    title: bookData.title ?? "",
                                    progress: 0.0,
                                    isSubscribed: true,

                                    onViewChapter: () {
                                      searchUnfocus();
                                      _showChapterBottomsheet(
                                        context,
                                        mysubscriptionController,
                                        bookData.bookId ?? "",
                                        bookData,
                                        token,
                                      );
                                    },
                                    onSubscribe: () {
                                      searchUnfocus();
                                      showSubscribeDialog(bookData);
                                    },

                                    context: context,
                                  );
                                },
                              )
                              : GridView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 8,
                                  bottom: 50,
                                ),

                                /*  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,                // 2 columns
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.4,            // Adjust as per your design
                            ), */
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          250, // Max width of each item
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio:
                                          0.46, // Optional: can remove or tweak
                                    ),
                                itemCount:
                                    mysubscriptionController
                                        .bookCollectionList
                                        .length,
                                itemBuilder: (context, index) {
                                  final bookData =
                                      mysubscriptionController
                                          .bookCollectionList[index];

                                  return bookGridItem(
                                    imageUrl: bookData.coverImage ?? "",
                                    title:
                                        bookData.title ??
                                        "", // Corrected field name to `bookTitle`
                                    progress: 0.0,
                                    isSubscribed: true,
                                    onViewChapter: () {
                                      searchUnfocus();
                                      _showChapterBottomsheet(
                                        context,
                                        mysubscriptionController,
                                        bookData.bookId ??
                                            "", // Corrected field name to `bookId`
                                        bookData,
                                        token,
                                      );
                                    },
                                    onSubscribe: () {
                                      searchUnfocus();
                                      showSubscribeDialog(bookData);
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
                      //child:Text(mysubscriptionController.mySubscriptionList.value.length.toString()),
                    ),

                //   SizedBox(height: 16,)
              ],
            ),

            // Positioned.fill (
            Positioned(
              // Makes the child fill the entire stack
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                /* AnimatedSlide(
                  duration: Duration(milliseconds: 300),
                  offset: _showFilterBar ? Offset(0, 0) : Offset(0, 1), // slide in/out vertically
                  child: YourFilterWidget(),
                  ) */
                child: AnimatedOpacity(
                  opacity: _showFilterBar ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    // height: 50,
                    //width: 150,
                    // alignment: Alignment.bottomCenter, dont use this!!!!!!!!!!!!
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: primarycolor.withAlpha(100),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            searchUnfocus();
                            _showFilterBottomsheet(
                              context,
                              mysubscriptionController,
                              token,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/icons/png_filter.png",
                                    height: 16,
                                    width: 16,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  Visibility(
                                    visible:
                                        mysubscriptionController
                                            .isFilterApplied
                                            .value,
                                    child: Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color: redcolor,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 8),
                              Text(
                                "Filter",

                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 14),
                          height: 24,
                          width: 1,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        /*   VerticalDivider(
                          color: redcolor,
                          thickness: 10,
                          width: 24,
                          //indent: 8,
                          // endIndent: 8,
                        ), */
                        InkWell(
                          onTap: () {
                            searchUnfocus();
                            _showSortBottomsheet(
                              context,
                              mysubscriptionController,
                              token,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/icons/png_sort.png",
                                    height: 16,
                                    width: 16,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  Visibility(
                                    visible:
                                        mysubscriptionController
                                            .isSortApplied
                                            .value,
                                    child: Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 6,
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color: redcolor,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Sorting",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

Widget bookGridItem({
  required String imageUrl,
  required String title,
  required double progress, // from 0.0 to 1.0
  required bool isSubscribed, // from 0.0 to 1.0
  required VoidCallback onViewChapter,
  required VoidCallback onSubscribe,
  required BuildContext context,
}) {
  return Container(
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top: Book Image
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            imageUrl,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/logo.png',
                height: 140,
                fit: BoxFit.contain,
              );
            },
          ),
        ),

        // Content Below Image
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Book Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: progressColorLight.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 10),

              // View Chapter Button
              GestureDetector(
                onTap: onViewChapter,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: primarycolor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "View Chapter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Subscribe Text
              GestureDetector(
                onTap: onSubscribe,
                child: Center(
                  child: Text(
                    isSubscribed ? "Unsubscribe" : "Subscribe",
                    style: TextStyle(
                      color: primarycolor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget bookListItem({
  required String imageUrl,
  required String title,
  required double progress, // from 0.0 to 1.0
  required bool isSubscribed, // from 0.0 to 1.0

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

              GestureDetector(
                onTap: onSubscribe,
                child: Center(
                  child: Text(
                    isSubscribed ? "Unsubscribe" : "Subscribe",

                    style: TextStyle(
                      color: primarycolor,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
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

void _showSortBottomsheet(
  context,
  MysubscriptionController mysubscriptionController,

  String token,
) {
  //final TextEditingController searchTextController = TextEditingController();
  //mysubscriptionController.searchServices("");

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
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            /* ............... */
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Sort",
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

                        // 🔵 Scrollable Content Section
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sort By
                                Text(
                                  "Sort By :",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      sortOptions.map((option) {
                                        return Obx(() {
                                          final isSelected =
                                              mysubscriptionController
                                                  .sortBy
                                                  .value ==
                                              option.value;
                                          return ChoiceChip(
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                            selectedColor: primarycolor,
                                            label: Text(option.label),
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide.none,
                                              /*  side: BorderSide(
                                                color:
                                                    isSelected
                                                        ? primarycolor
                                                        : blackmedium,
                                              ), */
                                            ),
                                            labelStyle: TextStyle(
                                              color:
                                                  isSelected
                                                      ? whitecolor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                            ),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              mysubscriptionController
                                                  .sortBy
                                                  .value = option.value;
                                              mysubscriptionController
                                                  .updateIsSortApplied();
                                              mysubscriptionController
                                                  .getMyBooksCollectionFilter(
                                                    context: context,
                                                    token: token,
                                                  );
                                            },
                                            showCheckmark: false,
                                          );
                                        });
                                      }).toList(),
                                ),

                                SizedBox(height: 24),

                                // Sort Order
                                Text(
                                  "Sort Order :",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      sortOrderOptions.map((option) {
                                        return Obx(() {
                                          final isSelected =
                                              mysubscriptionController
                                                  .sortOrder
                                                  .value ==
                                              option.value;
                                          return ChoiceChip(
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                            selectedColor: primarycolor,
                                            label: Text(option.label),
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide.none,
                                            ),
                                            labelStyle: TextStyle(
                                              color:
                                                  isSelected
                                                      ? whitecolor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                            ),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              mysubscriptionController
                                                  .sortOrder
                                                  .value = option.value;
                                              mysubscriptionController
                                                  .updateIsSortApplied();
                                              mysubscriptionController
                                                  .getMyBooksCollectionFilter(
                                                    context: context,
                                                    token: token,
                                                  );
                                            },
                                            showCheckmark: false,
                                          );
                                        });
                                      }).toList(),
                                ),
                                SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),

                        // 🔵 Bottom Fixed Buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(color: lightbluetext),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      buttonColor: primarycolor,
                                      textValue: "Clear",
                                      textColor: primarycolor,
                                      onPressed: () {
                                        mysubscriptionController.clearSorts();
                                        mysubscriptionController
                                            .getMyBooksCollectionFilter(
                                              context: context,
                                              token: token,
                                            );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),

                                  Expanded(
                                    child: PrimaryButton(
                                      buttonColor: primarycolor,
                                      textValue: "Apply",
                                      textColor: whitecolor,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Or your sort function
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void _showFilterBottomsheet(
  context,
  MysubscriptionController mysubscriptionController,

  String token,
) {
  //final TextEditingController searchTextController = TextEditingController();
  //mysubscriptionController.searchServices("");

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Filter",
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

                        // 🔵 Scrollable Content Section
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sort By
                                Text(
                                  "Subject :",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      subjectOptions.map((option) {
                                        return Obx(() {
                                          final isSelected =
                                              mysubscriptionController
                                                  .subjectFilter
                                                  .value ==
                                              option.value;
                                          return ChoiceChip(
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                            selectedColor: primarycolor,
                                            label: Text(option.label),
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide.none,
                                              /*  side: BorderSide(
                                                color:
                                                    isSelected
                                                        ? primarycolor
                                                        : blackmedium,
                                              ), */
                                            ),
                                            labelStyle: TextStyle(
                                              color:
                                                  isSelected
                                                      ? whitecolor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                            ),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              mysubscriptionController
                                                  .subjectFilter
                                                  .value = option.value;

                                              mysubscriptionController
                                                  .updateIsFilterApplied();

                                              mysubscriptionController
                                                  .getMyBooksCollectionFilter(
                                                    context: context,
                                                    token: token,
                                                  );
                                            },
                                            showCheckmark: false,
                                          );
                                        });
                                      }).toList(),
                                ),

                                SizedBox(height: 24),

                                // Sort Order
                                Text(
                                  "Grade :",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      gradeList.map((option) {
                                        return Obx(() {
                                          final isSelected =
                                              mysubscriptionController
                                                  .gradeFilter
                                                  .value ==
                                              option.value.toString();
                                          return ChoiceChip(
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                            selectedColor: primarycolor,
                                            label: Text(
                                              option.value.toString(),
                                            ),
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide.none,
                                            ),
                                            labelStyle: TextStyle(
                                              color:
                                                  isSelected
                                                      ? whitecolor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer,
                                            ),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              mysubscriptionController
                                                      .gradeFilter
                                                      .value =
                                                  option.value.toString();
                                              mysubscriptionController
                                                  .updateIsFilterApplied();

                                              mysubscriptionController
                                                  .getMyBooksCollectionFilter(
                                                    context: context,
                                                    token: token,
                                                  );
                                            },
                                            showCheckmark: false,
                                          );
                                        });
                                      }).toList(),
                                ),
                                SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),

                        // 🔵 Bottom Fixed Buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(color: lightbluetext),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      buttonColor: primarycolor,
                                      textValue: "Clear",
                                      textColor: primarycolor,
                                      onPressed: () {
                                        mysubscriptionController.clearFilters();
                                        mysubscriptionController
                                            .getMyBooksCollectionFilter(
                                              context: context,
                                              token: token,
                                            );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),

                                  Expanded(
                                    child: PrimaryButton(
                                      buttonColor: primarycolor,
                                      textValue: "Apply",
                                      textColor: whitecolor,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Or your sort function
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
