import '../enums/payment_provider_type.dart';

class InitialSubscriptionModel {
  final String? paymentKey;
  final String? paymentTransactionId;
  final PaymentProviderType? paymentProviderType;

  InitialSubscriptionModel({
    this.paymentKey,
    this.paymentTransactionId,
    this.paymentProviderType,
  });

  factory InitialSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return InitialSubscriptionModel(
      paymentKey: json['paymentKey'],
      paymentTransactionId: json['paymentTransactionId'],
      paymentProviderType: json['paymentProviderType'] != null
          ? PaymentProviderType.fromJson(json['paymentProviderType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentKey': paymentKey,
      'paymentTransactionId': paymentTransactionId,
      'paymentProviderType': paymentProviderType?.toJson(),
    };
  }
}