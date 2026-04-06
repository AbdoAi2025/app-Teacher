class FcmTokenResponse {
  final String? id;
  final String? token;
  final String? deviceId;
  final String? deviceName;
  final String? platform;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? lastUsedAt;

  FcmTokenResponse({
    this.id,
    this.token,
    this.deviceId,
    this.deviceName,
    this.platform,
    this.active,
    this.createdAt,
    this.lastUsedAt,
  });

  factory FcmTokenResponse.fromJson(Map<String, dynamic> json) {
    return FcmTokenResponse(
      id: json['id'] as String?,
      token: json['token'] as String?,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      platform: json['platform'] as String?,
      active: json['active'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      'active': active,
      'createdAt': createdAt?.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }
}