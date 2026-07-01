import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/primary_button.dart';
import 'package:test_your_learing/views/custom_widgets/secondary_button.dart';
import 'package:test_your_learing/views/screen/authentication/login.dart';

class LogoutSheet extends StatelessWidget {
  final String? title;
  final Widget? content;
  final VoidCallback? onReadMore;

  const LogoutSheet({Key? key, this.title, this.content, this.onReadMore})
    : super(key: key);

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
                        "Se déconnecter",
                        style: TextStyle(
                          fontSize: 18,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Êtes-vous sûr de vouloir vous déconnecter ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          buttonColor: primarycolor,
                          textValue: "Oui, se déconnecter",
                          textColor: whitecolor,
                          onPressed: () {
                            print('Confirmed');
                            Navigator.of(context).pop();

                            SharedPreferencesService.clearAllPreferences();
                            SharedPreferencesService.setFirstTimeStatus(
                              false,
                            ); // for not showing onboard screen
                            SharedPreferencesService
                                .setHasSeenDashboardWalkthrough(true);
                            Get.offAll(() => LoginPage());
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SecondaryButton(
                          buttonColor: primarycolor,
                          textValue: "Annuler",
                          textColor: primarycolor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),

                      /* 

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: onReadMore ?? () {},
                        child: Text(
                          "Read More",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ), */
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
