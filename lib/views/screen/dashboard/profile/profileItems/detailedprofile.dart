import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/controllers/profile/profile_controller.dart';
import 'package:test_your_learing/helper/getx_helper.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/title_desc_widget.dart';
import 'package:test_your_learing/views/dialogsheet/edit_profile_sheet.dart';
import 'package:test_your_learing/views/dialogsheet/logout_sheet.dart';
import 'package:test_your_learing/views/dialogsheet/update_pic_sheet.dart';

class DetailedProfilePage extends StatefulWidget {
  const DetailedProfilePage({super.key});

  @override
  State<DetailedProfilePage> createState() => _DetailedProfilePageState();
}

class _DetailedProfilePageState extends State<DetailedProfilePage> {
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();

    profileController = findOrPut(() => ProfileController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      profileController.getUserProfile(token: token, context: context);
    });
  }

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
                        'Detailed Profile',
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
        body: Obx(() {
          final profileImage =
              profileController.userProfile.value?.profilePicture ?? '';
          final name = profileController.userProfile.value?.username ?? '-';
          final fullname = profileController.userProfile.value?.fullname ?? '';
          final email = profileController.userProfile.value?.email ?? '-';
          final phone = profileController.userProfile.value?.phone ?? '';
          final isLoading = profileController.isLoading.value;
          final halfWidth = Constants.screenWidthPercentage(context, 0.5);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),

                        Center(
                          child:
                              isLoading
                                  ? Shimmer.fromColors(
                                    baseColor: shimmerBaseColor2,
                                    highlightColor: shimmerHighlightColor2,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                  : Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      // Profile Picture
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: graylight,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: lightgreytext,
                                            width: 1.0,
                                          ),
                                          /*  boxShadow: [
                                            BoxShadow(
                                              color: lightGraytext.withAlpha(50),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ], */
                                        ),

                                        child:
                                            profileImage.isNotEmpty
                                                ? ClipOval(
                                                  child: Image.network(
                                                    profileImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Image.asset(
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

                                      // Edit Icon
                                      Positioned(
                                        bottom: 2,
                                        right: 2,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              builder: (context) {
                                                return UpdateProfilePicSheet(
                                                  userProfile:
                                                      profileController
                                                          .userProfile
                                                          .value,
                                                  profileController:
                                                      profileController,
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: whitecolor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: graytext
                                                      .withAlpha(80),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                              "assets/icons/png_edit_profilepic.png",
                                              height: 20,
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child:
                              isLoading
                                  ? Shimmer.fromColors(
                                    baseColor: shimmerBaseColor2,
                                    highlightColor: shimmerHighlightColor2,
                                    child: Container(
                                      width: 120,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'Hii, $name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),

                        SizedBox(height: 6),
                        Center(
                          child:
                              isLoading
                                  ? Shimmer.fromColors(
                                    baseColor: shimmerBaseColor2,
                                    highlightColor: shimmerHighlightColor2,
                                    child: Container(
                                      width: halfWidth,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  )
                                  : Text(
                                    '$phone',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: graytext,
                                    ),
                                  ),
                        ),

                        SizedBox(height: 32),

                        // TitleDescWidget for displaying user information
                        TitleDescWidget(
                          title: 'Full Name',
                          desc: fullname,
                          isLoading: isLoading,
                        ),
                        SizedBox(height: 16),
                        TitleDescWidget(
                          title: 'Email Address',
                          desc: email,
                          isLoading: isLoading,
                        ),
                        SizedBox(height: 16),
                        TitleDescWidget(
                          title: 'Phone Number',
                          desc: phone,
                          isLoading: isLoading,
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                isLoading
                    ? SizedBox.shrink()
                    : CustomGradiantButton(
                      loading: false,
                      buttonColor: primarycolor,
                      textValue: 'Edit Profile',
                      textColor: onprimary,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return EditProfileSheet(
                              userProfile: profileController.userProfile.value,
                              profileController: profileController,
                            );
                          },
                        );
                      },
                    ),

                SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}
