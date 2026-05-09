class VerifyForgotPasswordOtpRequest {
  final String userId;
  final String code;

  VerifyForgotPasswordOtpRequest({required this.userId, required this.code});

  Map<String, dynamic> toJson() => {"userId": userId, "code": code};
}