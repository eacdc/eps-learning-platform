import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants/colors.dart';
import '../../models/collection_model/books_collection_list.dart';
import '../custom_widgets/primary_button.dart';
import '../custom_widgets/secondary_button.dart';

class SubscribeBookSheet extends StatelessWidget {
  final String title;
  //final Widget content;
  final String desc;
  final BookList bookData;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositiveCallback;
  final VoidCallback onNegativeCallback;

  const SubscribeBookSheet({
    Key? key,
    required this.title,
    required this.desc,
    required this.bookData,
    required this.positiveText,
    required this.negativeText,
    required this.onPositiveCallback,
    required this.onNegativeCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                        "${positiveText} Book",
                        style: TextStyle(
                          fontSize: 15,
                          color: blacktext,
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
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top: Book Image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                      bottom: Radius.circular(12),
                    ),
                    child: Image.network(
                      bookData.bookCoverImgLink,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo.png',
                          height: 120,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: blacktext,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 16,
                      color: lightGraytext,
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
                          textValue: positiveText,
                          textColor: whitecolor,
                          onPressed: onPositiveCallback,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SecondaryButton(
                          buttonColor: primarycolor,
                          textValue: negativeText,
                          textColor: primarycolor,
                          onPressed: () {
                            Navigator.of(context).pop();

                            onNegativeCallback;
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
