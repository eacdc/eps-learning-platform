import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';
import 'package:test_your_learing/views/custom_widgets/progressbar_widget.dart';

import '../../../../../controllers/privacy_policy_controller.dart';
import '../../../../../helper/getx_helper.dart';
import '../../../../../helper/sharedpreference_helper.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  //late WebViewController controller;
  //final RxBool isLoading = true.obs; // default true to show loader at first
  late final PrivacyPolicyController privacyPolicyController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /* controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {
                isLoading.value = true;
              },
              onPageFinished: (String url) {
                isLoading.value = false;
              },
              onHttpError: (HttpResponseError error) {
                isLoading.value = false;
              },
              onWebResourceError: (WebResourceError error) {
                isLoading.value = false;
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://flutter.dev')); */

    privacyPolicyController = findOrPut(() => PrivacyPolicyController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = SharedPreferencesService.getAccessToken() ?? '';
      privacyPolicyController.getPrivacyPolicy(token: token, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.surface,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor:  Theme.of(context).colorScheme.surface,
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
                       Text(
                        'Politique de confidentialité',
                        style: TextStyle(
                          color:  Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
                             Divider(color: Theme.of(context).dividerColor, height: 1),
            ],
          ),
        ),
        body: Obx(() {
          final privacyData = privacyPolicyController.privacyPolicy.value?.data;
          final policyContent = privacyData?.content;
          final sections =
              [
                policyContent?.informationWeCollect,
                policyContent?.howWeUseInformation,
                policyContent?.dataSharing,
                policyContent?.dataSecurity,
                policyContent?.yourRights,
                policyContent?.cookies,
                policyContent?.childrenPrivacy,
                policyContent?.changesToPolicy,
                policyContent?.contactInformation,
              ].where((s) => s != null).toList();
          return Stack(
            children: [
              /*    Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: WebViewWidget(controller: controller),
              ), */
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),

                            Text(
                              policyContent?.introduction ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),

                            for (final section in sections) ...[
                              SizedBox(height: 12),
                              InfoSection(
                                title: section?.title ?? "",
                                values: section?.items ?? [],
                              ),
                            ],
                            SizedBox(height: 18,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ProgressBarWidget(
                visible: privacyPolicyController.isLoading.value,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final List<String> values;

  const InfoSection({super.key, required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Values as bullet list
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              values.map((value) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("•  ", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          value,
                          style:  TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
