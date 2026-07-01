class AppVersionResponse {
  /// Newest build number currently published on the store.
  final int latestBuild;

  /// Anything below this build must update (mandatory).
  final int minSupportedBuild;

  /// Store URL to open when the user taps "Update".
  final String androidStoreUrl;

  /// Optional release notes shown in the update sheet.
  final String? releaseNotes;

  AppVersionResponse({
    required this.latestBuild,
    required this.minSupportedBuild,
    required this.androidStoreUrl,
    this.releaseNotes,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      latestBuild: _toInt(json['latestBuild']),
      minSupportedBuild: _toInt(json['minSupportedBuild']),
      androidStoreUrl: (json['androidStoreUrl'] ?? '').toString(),
      releaseNotes: json['releaseNotes']?.toString(),
    );
  }
}
