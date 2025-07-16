import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';

class NottificationSettingPage extends StatefulWidget {
  const NottificationSettingPage({super.key});

  @override
  State<NottificationSettingPage> createState() =>
      _NottificationSettingPageState();
}

class _NottificationSettingPageState extends State<NottificationSettingPage> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
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
                      const Text(
                        'Notifications Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
              Divider(color: textWhiteGrey, height: 1),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "General",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textBlack,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      NotificationSwitchWidget(
                        title: 'New Book Add Alerts',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Popular Quizzes & Books',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      Divider(
                        color: lightGrayBg,
                        height: 48,
                        thickness: 8,
                        indent: 0,
                        endIndent: 0,
                      ),
                   
                     SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Badge Counter",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textBlack,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                       NotificationSwitchWidget(
                        title: 'Show Badge Icon',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Include Muted Chat',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                     
                      NotificationSwitchWidget(
                        title: 'Count Unread Message',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      Divider(
                        color: lightGrayBg,
                        height: 48,
                        thickness: 8,
                        indent: 0,
                        endIndent: 0,
                      ),
                        SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Notification",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textBlack,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      NotificationSwitchWidget(
                        title: 'Books Recommendations',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Announcements From Publisher',
                        value: _isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            _isNotificationEnabled = newValue;
                          });
                        },
                      ),
                     
                    
                    
                   
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationSwitchWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationSwitchWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Transform.scale(scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: whitecolor,
              activeTrackColor: primarycolor,
              inactiveThumbColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
