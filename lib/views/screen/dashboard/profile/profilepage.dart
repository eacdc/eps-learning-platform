import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/dialogsheet/logout_sheet.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/account_security.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/detailedprofile.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/helpcenter_support.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/notification_setting.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/privacy_policy.dart';
import 'package:test_your_learing/views/screen/dashboard/profile/profileItems/progress_score.dart';

import '../../../../helper/sharedpreference_helper.dart'
    show SharedPreferencesService;
import '../../authentication/login.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final List<Widget> itemWidgets = [
    InfoItem(
      iconPath: 'assets/icons/profileicon/png_profile_logo.png',
      title: 'Detailed Profile',
      description: 'Information account',
      onTap: () {
        print('User Profile clicked');
        Get.to(DetailedProfilePage(),
        
       );
      },
    ),
    InfoItem(
      iconPath: 'assets/icons/profileicon/png_account_security_logo.png',
      title: 'Account & Security',
      description: 'Information about your account',
      onTap: () {
        print('Settings clicked');
         Get.to(AccountSecurityPage() );
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_progress_score.png',
      title: 'Progress & Scores',
      description: 'Check current progress & scores',
      onTap: () {
        print('Settings clicked');
        Get.to(ProgressScorePage()); // Navigate to ProgressScorePage
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_notification_setting.png',
      title: 'Notifications Settings',
      description: 'check notifications & updates ',
      onTap: () {
        print('Settings clicked');
         Get.to(NottificationSettingPage() );
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_helpcenter_logo.png',
      title: 'Help Center & Support',
      description: 'Get support from experts',
      onTap: () {
        print('Settings clicked');
         Get.to(HelpCenterPage() );
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_privacy_policy_logo.png',
      title: 'Privacy Policy',
      description: 'Our privacy policy',
      onTap: () {
        print('Settings clicked');
         Get.to(PrivacyPolicyPage() );
      },
    ),
    // Add more InfoItem widgets here...

    /*    SingleChildScrollView(
  child: Column(
    children: [
      InfoItem(...),
      InfoItem(...),
      InfoItem(...),
    ],
  ),
) */
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whitecolor,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circular Image
                /*  ClipOval(
                  child: Image.asset(
                    'assets/icons/png_user.png',
                    
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ), */
                Container(
                  padding: EdgeInsets.all(16),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: graylight,
                    shape: BoxShape.circle,
                    /*  image: DecorationImage(
                      image: AssetImage('assets/icons/png_user.png'),
                      fit: BoxFit.contain,
                    ), */
                  ),
                  child: Image.asset(
                    'assets/icons/png_user.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 16), // Spacing between image and text
                // Title & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hii, Username',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'username@gmail.com',
                        style: TextStyle(fontSize: 14, color: graytext),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: itemWidgets.length,
              itemBuilder: (context, index) {
                return itemWidgets[index];
              },
            ),
          ),
           SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(
              top: 2,
              left: 12,
              right: 12,
              bottom: 12,

            ),
            child: SizedBox(
              width: double.infinity, // ➔ Full width
              child: OutlinedButton(
                onPressed: () {
                 // oepnLogoutDialog(context);

                   showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return LogoutSheet();
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,

                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: textBlack), // ➔ Black border
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: textBlack),
                ),
              ),
            ),
          ),

          /* GestureDetector(
            onTap: () {
              oepnLogoutDialog(context);
            },
            child: Text(
              "Logout?",
              style: TextStyle(color: redcolor, fontWeight: FontWeight.w600),
            ),
          ),
          
           */
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

Future<void> oepnLogoutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Are you sure to Logout?', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              print('Confirmed');
              Navigator.of(context).pop();

              SharedPreferencesService.clearAllPreferences();
              SharedPreferencesService.setFirstTimeStatus(
                false,
              ); // for not showing onboard screen
              Get.offAll(() => LoginPage());
            },
          ),
        ],
      );
    },
  );
}

class InfoItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const InfoItem({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: lightGrayBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  /* image: DecorationImage(
                    image: AssetImage(iconPath),
                    fit: BoxFit.contain,
                  ), */
                ),
                child: Image.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: graytext,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SvgPicture.asset(
                  "assets/icons/svg_next_arrow.svg",
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(blacktext, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
