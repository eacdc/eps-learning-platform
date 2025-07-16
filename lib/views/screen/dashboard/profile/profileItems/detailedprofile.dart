import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/gradiant_button.dart';
import 'package:test_your_learing/views/custom_widgets/title_desc_widget.dart';
import 'package:test_your_learing/views/dialogsheet/edit_profile_sheet.dart';
import 'package:test_your_learing/views/dialogsheet/logout_sheet.dart';

class DetailedProfilePage extends StatelessWidget {
  const DetailedProfilePage({super.key});

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
        body: Container(
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
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Profile Picture
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/png_user.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: lightgreytext,
                                  width: 2,
                                ),
                              ),
                            ),
                            // Edit Icon
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: whitecolor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  "assets/icons/png_edit_profilepic.png",
                                  height: 16,
                                  // color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Hii, Username',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Text(
                          'username@gmail.com',
                          style: TextStyle(fontSize: 14, color: graytext),
                        ),
                      ),

                      SizedBox(height: 32),

                      // TitleDescWidget for displaying user information
                      TitleDescWidget(
                        title: 'Full Name',
                        desc: 'User Full Name',
                      ),
                      SizedBox(height: 16),
                      TitleDescWidget(
                        title: 'Email Address',
                        desc: 'User email address',
                      ),
                      SizedBox(height: 16),
                      TitleDescWidget(
                        title: 'Phone Number',
                        desc: 'User phone number',
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              CustomGradiantButton(
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
                      return EditProfileSheet();
                    },
                  );
                },
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

