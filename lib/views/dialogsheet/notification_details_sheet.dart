import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';
import 'package:test_your_learing/views/custom_widgets/secondary_button.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

import '../../models/notification_model/all_notification_model.dart';

class NotificationDetailsSheet extends StatelessWidget {
  final AllNotificationModel? notificationData;
  final VoidCallback? onReadMore;

  const NotificationDetailsSheet({
    Key? key,
    this.notificationData,
    this.onReadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                        "Notification Details",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationData?.title ?? "",

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          (notificationData?.seenStatus == "no")
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 1),
                    decoration: BoxDecoration(
                      //color: lightGrayBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notificationData?.message ?? "",
                    
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      
                      formatDate(notificationData?.createdAt),
                    
                      softWrap: false,
                    
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      return dateStr; // fallback
    }
  }
}
