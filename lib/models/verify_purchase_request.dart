import '../enums/billing_period.dart';

class VerifyPurchaseRequest {
  final String packageName;
  final String productId;
  final String purchaseToken;
  final String subscriptionPlanCode;
  final BillingPeriod billingPeriod;

  VerifyPurchaseRequest({
    required this.packageName,
    required this.productId,
    required this.purchaseToken,
    required this.subscriptionPlanCode,
    required this.billingPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'productId': productId,
      'purchaseToken': purchaseToken,
      'subscriptionPlanCode': subscriptionPlanCode,
      'billingPeriod': billingPeriod.toJson(),
    };
  }

  factory VerifyPurchaseRequest.fromJson(Map<String, dynamic> json) {
    return VerifyPurchaseRequest(
      packageName: json['packageName'] ?? '',
      productId: json['productId'] ?? '',
      purchaseToken: json['purchaseToken'] ?? '',
      subscriptionPlanCode: json['subscriptionPlanCode'] ?? '',
      billingPeriod: BillingPeriod.fromJson(json['billingPeriod'] ?? 'MONTHLY'),
    );
  }
}