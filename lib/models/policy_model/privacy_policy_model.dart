class PrivacyPolicyResponse {
  final bool? success;
  final PrivacyPolicyData? data;

  PrivacyPolicyResponse({
    this.success,
    this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? PrivacyPolicyData.fromJson(json['data'])
          : null,
    );
  }
}

class PrivacyPolicyData {
  final String? title;
  final String? lastUpdated;
  final PrivacyPolicyContent? content;

  PrivacyPolicyData({
    this.title,
    this.lastUpdated,
    this.content,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      title: json['title'] as String?,
      lastUpdated: json['lastUpdated'] as String?,
      content: json['content'] != null
          ? PrivacyPolicyContent.fromJson(json['content'])
          : null,
    );
  }
}

class PrivacyPolicyContent {
  final String? introduction;
  final PolicySection? informationWeCollect;
  final PolicySection? howWeUseInformation;
  final PolicySection? dataSharing;
  final PolicySection? dataSecurity;
  final PolicySection? yourRights;
  final PolicySection? cookies;
  final PolicySection? childrenPrivacy;
  final PolicySection? changesToPolicy;
  final PolicySection? contactInformation;

  PrivacyPolicyContent({
    this.introduction,
    this.informationWeCollect,
    this.howWeUseInformation,
    this.dataSharing,
    this.dataSecurity,
    this.yourRights,
    this.cookies,
    this.childrenPrivacy,
    this.changesToPolicy,
    this.contactInformation,
  });

  factory PrivacyPolicyContent.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyContent(
      introduction: json['introduction'] as String?,
      informationWeCollect: json['informationWeCollect'] != null
          ? PolicySection.fromJson(json['informationWeCollect'])
          : null,
      howWeUseInformation: json['howWeUseInformation'] != null
          ? PolicySection.fromJson(json['howWeUseInformation'])
          : null,
      dataSharing: json['dataSharing'] != null
          ? PolicySection.fromJson(json['dataSharing'])
          : null,
      dataSecurity: json['dataSecurity'] != null
          ? PolicySection.fromJson(json['dataSecurity'])
          : null,
      yourRights: json['yourRights'] != null
          ? PolicySection.fromJson(json['yourRights'])
          : null,
      cookies: json['cookies'] != null
          ? PolicySection.fromJson(json['cookies'])
          : null,
      childrenPrivacy: json['childrenPrivacy'] != null
          ? PolicySection.fromJson(json['childrenPrivacy'])
          : null,
      changesToPolicy: json['changesToPolicy'] != null
          ? PolicySection.fromJson(json['changesToPolicy'])
          : null,
      contactInformation: json['contactInformation'] != null
          ? PolicySection.fromJson(json['contactInformation'])
          : null,
    );
  }
}

class PolicySection {
  final String? title;
  final List<String>? items;

  PolicySection({
    this.title,
    this.items,
  });

  factory PolicySection.fromJson(Map<String, dynamic> json) {
    return PolicySection(
      title: json['title'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
