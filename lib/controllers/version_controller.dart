import 'package:flutter/foundation.dart'
    show kIsWeb, kDebugMode, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:test_your_learing/constants/constant.dart';
import 'package:test_your_learing/helper/sharedpreference_helper.dart';
import 'package:test_your_learing/models/app_version_model.dart';
import 'package:test_your_learing/networks/api_manager.dart';
import 'package:test_your_learing/views/dialogsheet/update_sheet.dart';

class VersionController extends GetxController {
  bool _checkedThisSession = false;

  /// Checks the backend for a newer app version and, if needed, shows the
  /// update sheet. Android-only by design; no-ops elsewhere.
  Future<void> checkForUpdate(BuildContext context) async {
    // Only Android. Skip web, iOS, and desktop.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    // Avoid re-checking multiple times within the same app session.
    if (_checkedThisSession) return;
    _checkedThisSession = true;

    try {
      final info = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(info.buildNumber) ?? 0;

      final token = SharedPreferencesService.getAccessToken();
      final response = await ApiManager.requestNew(
        endpoint: ApiManager.appVersion("android"),
        method: "GET",
        token: token.isNotEmpty ? token : null,
      );

      if (!response.isSuccess || response.data is! Map) return;

      final version = AppVersionResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      if (version.latestBuild <= 0) return;

      // Already up to date.
      if (currentBuild >= version.latestBuild) return;

      final bool forced = currentBuild < version.minSupportedBuild;

      // For optional updates, don't nag if the user already dismissed this build.
      if (!forced &&
          SharedPreferencesService.getDismissedUpdateBuild() ==
              version.latestBuild) {
        return;
      }

      final storeUrl = version.androidStoreUrl.isNotEmpty
          ? version.androidStoreUrl
          : Constants.playStoreUrl;

      if (!context.mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: !forced,
        enableDrag: !forced,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => UpdateSheet(
          forced: forced,
          storeUrl: storeUrl,
          releaseNotes: version.releaseNotes,
          onLater: forced
              ? null
              : () {
                  SharedPreferencesService.setDismissedUpdateBuild(
                    version.latestBuild,
                  );
                },
        ),
      );
    } catch (e) {
      if (kDebugMode) print("Version check failed: $e");
    }
  }
}
