import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/notification_controller.dart';
import 'package:test_your_learing/models/notification_model/all_notification_model.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/input_field.dart';
import 'package:test_your_learing/views/custom_widgets/progressbar_widget.dart';

import '../../../../helper/sharedpreference_helper.dart';
import '../../../dialogsheet/notification_details_sheet.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ScrollController scrollController = ScrollController();

  late NotificationController notificationController;
  late String token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //SharedPreferencesService.getEmployeeId();
    notificationController = Get.put(NotificationController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      token = SharedPreferencesService.getAccessToken();
      //SharedPreferencesService.getAccessToken();

      /* mysubscriptionController.getSubscriptionList(
        token: token,
        context: context,
        reloadpage: true,
      ); */

      notificationController.getAllNotificationFilter(
        token: token,
        context: context,
        reloadpage: true,
      );

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print("reach end");
          notificationController.pageNo.value =
              notificationController.pageNo.value + 1;
          notificationController.getAllNotificationFilter(
            token: token,
            context: context,
            pageNumber: notificationController.pageNo.value,
          );

          //get More Task
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor:
              Theme.of(
                context,
              ).colorScheme.surface, // Your desired status bar color
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark, // Icons: light or dark
        ),
        child: Scaffold(
          //backgroundColor: Colors.red,
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
                          'Notifications',
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
                Divider(color:  Theme.of(context).dividerColor, height: 1),
              ],
            ),
          ),
          body: Obx(
            () => Container(
              color: Theme.of(context).colorScheme.surface,
              child: Stack(
                // fit: StackFit.loose,
                //  alignment: AlignmentDirectional.center,
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 1),

                      notificationController
                              .allNotificationList
                              .value
                              .isNotEmpty
                          ? Expanded(
                            // height: 200,
                            //   color: blackcolor,
                            child: ListView.builder(
                              controller: scrollController,

                              itemCount:
                                  notificationController
                                      .allNotificationList
                                      .length,
                              itemBuilder: (context, index) {
                                final notificationdata =
                                    notificationController
                                        .allNotificationList
                                        .value[index];
                                return NotificationItem(
                                  data: notificationdata,

                                  onClick: () {
                                    if (notificationdata?.seenStatus == "no") {
                                      notificationController.seenNotification(
                                        context: context,
                                        token: token,
                                        notificationId:
                                            notificationdata.id.toString(),
                                      );
                                    }

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return NotificationDetailsSheet(
                                          notificationData: notificationdata,
                                        );
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
                            child: Image.asset(
                              "assets/images/png_no_collection.png",
                            ),
                            //child:Text(dashboardController.bookCollectionList.value.length.toString()),
                          ),
                    ],
                  ),

                  ProgressBarWidget(visible: notificationController.isLoading.value)



                 ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final AllNotificationModel data;
  final VoidCallback onClick;

  const NotificationItem({Key? key, required this.data, required this.onClick})
    : super(key: key);

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      return dateStr; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withAlpha(50), width: 0.8),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular seen/unseen indicator
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (data.seenStatus == "no")
                        ? primarycolor
                        : Colors.grey, // green = unseen, grey = seen
              ),
            ),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          (data.seenStatus == "no")
                              ? Theme.of(
                              context,
                            ).colorScheme.onSurface
                              : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.message ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(fontSize: 14, color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                  ) ),
                  const SizedBox(height: 6),
                  Text(
                    formatDate(data.createdAt),

                    style: TextStyle(fontSize: 12, color:  Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withAlpha(150)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
