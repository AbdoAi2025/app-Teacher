class VerifyPaymentRequest {
  final String orderId;

  VerifyPaymentRequest({
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
    };
  }

  factory VerifyPaymentRequest.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentRequest(
      orderId: json['orderId'] ?? '',
    );
  }
}