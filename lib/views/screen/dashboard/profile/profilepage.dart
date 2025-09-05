import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/profile/profile_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Widget> itemWidgets = [
    InfoItem(
      iconPath: 'assets/icons/profileicon/png_profile_logo.png',
      title: 'Detailed Profile',
      description: 'Information account',
      onTap: () {
        print('User Profile clicked');
        Get.to(DetailedProfilePage());
      },
    ),
    InfoItem(
      iconPath: 'assets/icons/profileicon/png_account_security_logo.png',
      title: 'Account & Security',
      description: 'Information about your account',
      onTap: () {
        print('Settings clicked');
        Get.to(AccountSecurityPage());
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
        Get.to(NottificationSettingPage());
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_helpcenter_logo.png',
      title: 'Help Center & Support',
      description: 'Get support from experts',
      onTap: () {
        print('Settings clicked');
        Get.to(HelpCenterPage());
      },
    ),

    InfoItem(
      iconPath: 'assets/icons/profileicon/png_privacy_policy_logo.png',
      title: 'Privacy Policy',
      description: 'Our privacy policy',
      onTap: () {
        print('Settings clicked');
        Get.to(PrivacyPolicyPage());
      },
    ),
  ];

  late final ProfileController profileController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profileController = findOrPut(() => ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      profileController.getUserProfile(token: token, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return Container(
      color: themeColors.surface,

      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final profileImage =
                      profileController.userProfile.value?.profilePicture ?? '';
                  final name =
                      profileController.userProfile.value?.username ?? '-';
                  final phone =
                      profileController.userProfile.value?.phone ?? '-';
                  final isLoading = profileController.isLoading.value;

                  return Row(
                    children: [
                      // Profile Image or Shimmer
                      isLoading
                          ? Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                          : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: graylight,
                              shape: BoxShape.circle,
                              border: Border.all(color: graylight, width: 1.0),
                            ),
                            child:
                                profileImage.isNotEmpty
                                    ? ClipOval(
                                      child: Image.network(
                                        profileImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  'assets/icons/png_user.png',
                                                  fit: BoxFit.none,
                                                ),
                                      ),
                                    )
                                    : Image.asset(
                                      'assets/icons/png_user.png',
                                      fit: BoxFit.none,
                                    ),
                          ),

                      const SizedBox(width: 16),

                      // Name and Phone or Shimmer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              isLoading
                                  ? [
                                    Shimmer.fromColors(
                                      baseColor: shimmerBaseColor,
                                      highlightColor: shimmerHighlightColor,
                                      child: Container(
                                        width: 120,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Shimmer.fromColors(
                                      baseColor: shimmerBaseColor,
                                      highlightColor: shimmerHighlightColor,
                                      child: Container(
                                        width: 80,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                  : [
                                    Text(
                                      'Hi, $name',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                         color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      phone,
                                      style: TextStyle(
                                        fontSize: 14,
                                       color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                        ),
                      ),
                    ],
                  );
                }),
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
                        side: BorderSide(color: Theme.of(context).colorScheme.onSurface,),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
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
          /* 
          Obx(
            () => Visibility(
              visible: profileController.isLoading.value,
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
          ),
         */
        ],
      ),
    );
  }
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
        color: Theme.of(context).colorScheme.secondaryContainer,
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.onSurface, // adaptive text color
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant, // lighter variant
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
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
