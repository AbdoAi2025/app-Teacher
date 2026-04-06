class UpdateFcmTokenRequest {
  final String token;
  final String? deviceId;
  final String? deviceName;
  final String? platform;

  UpdateFcmTokenRequest({
    required this.token,
    this.deviceId,
    this.deviceName,
    this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
    };
  }
}