import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  bool showFaq = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircularBackButton(
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'Help Center',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: textWhiteGrey, height: 1),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            // Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toggleButton("FAQ's", showFaq, () {
                  setState(() => showFaq = true);
                }),
                const SizedBox(width: 16),
                toggleButton("Help Center", !showFaq, () {
                  setState(() => showFaq = false);
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Toggle Content
            Expanded(child: showFaq ? FaqWidget() : HelpCenterWidget()),
          ],
        ),
      ),
    );
  }

  // Toggle Button Widget
  Widget toggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primarycolor : whitecolor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? primarycolor : graylight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class FaqWidget extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      "question": "What are course apps?",
      "answer":
          "Course apps connect users to educational resources and content tailored to their learning goals.",
    },
    {
      "question": "What features do course apps have?",
      "answer":
          "They include quizzes, video tutorials, tracking progress, certification, and discussion forums.",
    },
    {
      "question": "What are the benefits of using course apps?",
      "answer":
          "They provide flexible learning, progress tracking, and personalized content anytime, anywhere.",
    },
    {
      "question": "Are course apps effective for learning?",
      "answer":
          "Yes, when used consistently, they enhance knowledge retention and encourage self-paced learning.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign: TextAlign.start,

                "Frequently Asked\nQuestion",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: textBlack,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchField(),
          ),
          Divider(
            color: lightGrayBg,
            height: 48,
            thickness: 8,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  // collapsedBackgroundColor: Colors.grey[100],
                  backgroundColor: Colors.white,
                  collapsedIconColor: graydark,
                  shape: Border.all(color: Colors.transparent),

                  iconColor: graydark,
                  title: Text(
                    faqList[index]["question"] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textBlack,
                      fontSize: 15,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faqList[index]["answer"] ?? '',
                        style: TextStyle(color: graytext),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox.shrink(),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class HelpCenterWidget extends StatelessWidget {
   final List<Widget> itemWidgets = [
    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_customer.png',
      title: 'Customer Service',
      description: '1274-555 666 (Toll-free)',
      onTap: () {
        print('User Profile clicked');
        
       
      },
    ),
    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_whatsapp.png',
      title: 'WhatsApp',
      description: '+91-9912112199',
      onTap: () {
        print('Settings clicked');
      },
    ),

    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_website.png',
      title: 'Website',
      description: 'www.epslearning',
      onTap: () {
        print('Settings clicked');
      },
    ),

    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_facebook.png',
      title: 'Facebook',
      description: '@eps_learning',
      onTap: () {
        print('Settings clicked');
      },
    ),

    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_twitter.png',
      title: 'Twitter',
      description: '@epslearning',
      onTap: () {
        print('Settings clicked');
      },
    ),

    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_instagram.png',
      title: 'Instagram',
      description: '@eps_learning',
      onTap: () {
        print('Settings clicked');
         
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
    return ListView.builder(
              itemCount: itemWidgets.length,
              itemBuilder: (context, index) {
                return itemWidgets[index];
              },
            );
          
  }
}


class HelpCenterItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const HelpCenterItem({
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
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
                  height: 16,
                  width: 16,
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
              
            ],
          ),
        ),
      ),
    );
  }
}

