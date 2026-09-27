import 'package:in_app_review/in_app_review.dart';

import 'sharedpreference_helper.dart';

/// Asks the user for a Play Store rating using Google's In-App Review API.
///
/// The native review sheet is shown from inside the app (the user never leaves
/// it). Google decides whether it is actually displayed and throttles how often
/// it appears, so this is a best-effort request, not a guaranteed prompt.
class ReviewHelper {
  /// Ask for a review once the app has been opened at least this many times.
  static const int _openThreshold = 3;

  /// Call on app open (e.g. from the dashboard). Increments the open counter
  /// and, once the threshold is reached, requests the in-app review a single
  /// time.
  static Future<void> maybeAskForReview() async {
    try {
      // Already asked once — never nag again.
      if (SharedPreferencesService.getReviewRequested()) return;

      final int count = SharedPreferencesService.getAppOpenCount() + 1;
      SharedPreferencesService.setAppOpenCount(count);

      if (count < _openThreshold) return;

      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        // Mark as requested before showing so a failure/quota-skip does not
        // cause it to be retried on every future launch.
        SharedPreferencesService.setReviewRequested(true);
        await inAppReview.requestReview();
      }
    } catch (_) {
      // Reviews are non-critical; never let this break app startup.
    }
  }
}
