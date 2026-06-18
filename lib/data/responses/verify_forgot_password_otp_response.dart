class VerifyForgotPasswordOtpResponse {
  final String resetToken;

  VerifyForgotPasswordOtpResponse({required this.resetToken});

  factory VerifyForgotPasswordOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyForgotPasswordOtpResponse(
      resetToken: json["resetToken"] as String,
    );
  }
}