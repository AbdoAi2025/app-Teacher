class VerifyPaymentRequest {
  final String orderId;
  final String merchantOrderId;

  VerifyPaymentRequest({
    required this.orderId,
    required this.merchantOrderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'merchantOrderId': merchantOrderId,
    };
  }
}