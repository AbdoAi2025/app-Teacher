import 'package:teacher_app/utils/safe_json_access.dart';

class VerifyPaymentData {
  final bool success;

  VerifyPaymentData({
    required this.success,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      success: json.tryBool('success') ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
    };
  }
}

class VerifyPaymentResponse {
  final String status;
  final bool? data;
  final String message;

  VerifyPaymentResponse({
    required this.status,
    this.data,
    required this.message,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      status: json.tryString('status') ?? '',
      data: json.tryBool('data'),
      message: json.tryString('message') ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
      'message': message,
    };
  }
}