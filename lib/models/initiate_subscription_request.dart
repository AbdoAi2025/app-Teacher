import 'package:teacher_app/models/initiate_subscription_response.dart';

import '../enums/billing_period.dart';
import '../enums/payment_provider_type.dart';

class InitiateSubscriptionRequest {
  final String subscriptionPlanCode;
  final BillingPeriod billingPeriod;
  final PaymentProviderType paymentProviderType;

  InitiateSubscriptionRequest({
    required this.subscriptionPlanCode,
    required this.billingPeriod,
    required this.paymentProviderType,
  });

  Map<String, dynamic> toJson() {


    return {
      'subscriptionPlanCode': subscriptionPlanCode,
      'billingPeriod': billingPeriod.toJson(),
      'paymentProviderType': paymentProviderType.toJson(),
      // 'paymentMethod': "MOBILE_WALLET",
    };
  }

  factory InitiateSubscriptionRequest.fromJson(Map<String, dynamic> json) {
    return InitiateSubscriptionRequest(
      subscriptionPlanCode: json['subscriptionPlanCode'] ?? '',
      billingPeriod: BillingPeriod.fromJson(json['billingPeriod'] ?? 'MONTHLY'),
      paymentProviderType: PaymentProviderType.fromJson(json['paymentProviderType'] ?? 'PAYMOB'),
    );
  }
}