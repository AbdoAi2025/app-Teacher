class ForgotPasswordResponse {
  final String userId;
  final String otpSentTo;

  ForgotPasswordResponse({required this.userId, required this.otpSentTo});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      userId: json["userId"] as String,
      otpSentTo: json["otpSentTo"] as String,
    );
  }
}