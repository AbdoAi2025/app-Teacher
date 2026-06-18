class LoginResult {
  final String id;
  final String name;
  final String accessToken;
  final String refreshToken;
  final bool mustCompleteProfile;
  final bool requiresVerification;
  final String? otpSentTo;

  LoginResult({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    this.mustCompleteProfile = false,
    this.requiresVerification = false,
    this.otpSentTo,
  });

  toJson() {
    return {
      "id": id,
      "name": name,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "mustCompleteProfile": mustCompleteProfile,
      "requiresVerification": requiresVerification,
      "otpSentTo": otpSentTo,
    };
  }
}
