import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/controllers/faq_controller.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';

import '../../../../../helper/getx_helper.dart';
import '../../../../../helper/sharedpreference_helper.dart';
import '../../../../custom_widgets/progressbar_widget.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  bool showFaq = true;

  late final FaqController faqController;

  @override
  void initState() {
    super.initState();

    faqController = findOrPut(() => FaqController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      faqController.getFaq(token: token, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.surface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor:  Theme.of(context).colorScheme.surface,
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
                     Text(
                      'Centre d\'aide',
                      style: TextStyle(
                        color:  Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
                             Divider(color: Theme.of(context).dividerColor, height: 1),
            ],
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  // Toggle Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      toggleButton("FAQ", showFaq, () {
                        setState(() => showFaq = true);
                      }),
                      const SizedBox(width: 16),
                      toggleButton("Centre d'aide", !showFaq, () {
                        setState(() => showFaq = false);
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Toggle Content
                  Expanded(child: showFaq ? FaqWidget() : HelpCenterWidget()),
                ],
              ),

              ProgressBarWidget(visible: faqController.isLoading.value),
            ],
          );
        }),
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
          color: isSelected ? primarycolor :  Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? primarycolor : Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white :  Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class FaqWidget extends StatelessWidget {
  final fcontroller = findOrPut(() => FaqController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        final faqdata = fcontroller.faqResponse.value?.data;
        final faq_category = faqdata?.categories;

        final faqcategorylist =
            [
              faq_category?['general'],
              faq_category?['account'],
              faq_category?['features'],
              faq_category?['technical'],
              faq_category?['privacy'],
              faq_category?['subscription'],
            ].where((element) => element != null).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textAlign: TextAlign.start,

                  "Questions\nFréquemment Posées",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color:  Theme.of(context).colorScheme.onSurface,
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
              color:  Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
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
                itemCount: faqcategorylist.length,
                itemBuilder: (context, index) {
                  final category = faqcategorylist[index];
                  return ExpansionTile(
                    // collapsedBackgroundColor: Colors.grey[100],
                    backgroundColor:  Theme.of(context).colorScheme.surface,
                    collapsedIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    shape: Border.all(color: Colors.transparent),

                    iconColor:  Theme.of(context).colorScheme.onSurfaceVariant,
                    title: Text(
                      category?.title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:  Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:  Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        alignment: Alignment.centerLeft,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: category?.questions?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = category?.questions?[index];
                            return ExpansionTile(
                              // collapsedBackgroundColor: Colors.grey[100],
                              // backgroundColor: Colors.white,
                              collapsedIconColor: graydark,
                              shape: Border.all(color: Colors.transparent),

                              iconColor: graydark,
                              title: Text(
                                item?.question ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                                  fontSize: 14.5,
                                ),
                              ),
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item?.answer ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder:
                              (context, index) => SizedBox.shrink(),
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
        );
      }),
    );
  }
}

class HelpCenterWidget extends StatelessWidget {
  final List<Widget> itemWidgets = [
    HelpCenterItem(
      iconPath: 'assets/icons/score_progress/png_hc_customer.png',
      title: 'Service client',
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
        color: Theme.of(context).colorScheme.secondaryContainer,
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
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
