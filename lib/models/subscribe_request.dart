import '../enums/billing_period.dart';

class SubscribeRequest {
  final String subscriptionPlanCode;
  final BillingPeriod billingPeriod;

  SubscribeRequest({
    required this.subscriptionPlanCode,
    required this.billingPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      'subscriptionPlanCode': subscriptionPlanCode,
      'billingPeriod': billingPeriod.toJson(),
    };
  }

  factory SubscribeRequest.fromJson(Map<String, dynamic> json) {
    return SubscribeRequest(
      subscriptionPlanCode: json['subscriptionPlanCode'] ?? '',
      billingPeriod: BillingPeriod.fromJson(json['billingPeriod'] ?? 'MONTHLY'),
    );
  }
}