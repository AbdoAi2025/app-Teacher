import '../enums/billing_period.dart';

class VerifyPurchaseResponse {
  final String? userId;
  final String? teacherId;
  final String? subscriptionPlanCode;
  final String? subscriptionPlanName;
  final DateTime? expirationDate;
  final BillingPeriod? billingPeriod;
  final double? amountCharged;
  final String? actionType; // "SUBSCRIBED", "UPGRADED", "DOWNGRADED"
  final String? previousPlanName;
  final bool verified;
  final bool success;
  final String message;

  // Google Play specific fields
  final String? purchaseToken;
  final String? orderId;
  final int? purchaseTime;
  final String? purchaseState;

  VerifyPurchaseResponse({
    this.userId,
    this.teacherId,
    this.subscriptionPlanCode,
    this.subscriptionPlanName,
    this.expirationDate,
    this.billingPeriod,
    this.amountCharged,
    this.actionType,
    this.previousPlanName,
    required this.verified,
    required this.success,
    required this.message,
    this.purchaseToken,
    this.orderId,
    this.purchaseTime,
    this.purchaseState,
  });

  factory VerifyPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPurchaseResponse(
      userId: json['userId'],
      teacherId: json['teacherId'],
      subscriptionPlanCode: json['subscriptionPlanCode'],
      subscriptionPlanName: json['subscriptionPlanName'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['expirationDate'])
          : null,
      billingPeriod: json['billingPeriod'] != null
          ? BillingPeriod.fromJson(json['billingPeriod'])
          : null,
      amountCharged: json['amountCharged']?.toDouble(),
      actionType: json['actionType'],
      previousPlanName: json['previousPlanName'],
      verified: json['verified'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      purchaseToken: json['purchaseToken'],
      orderId: json['orderId'],
      purchaseTime: json['purchaseTime'],
      purchaseState: json['purchaseState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'teacherId': teacherId,
      'subscriptionPlanCode': subscriptionPlanCode,
      'subscriptionPlanName': subscriptionPlanName,
      'expirationDate': expirationDate?.millisecondsSinceEpoch,
      'billingPeriod': billingPeriod?.toJson(),
      'amountCharged': amountCharged,
      'actionType': actionType,
      'previousPlanName': previousPlanName,
      'verified': verified,
      'success': success,
      'message': message,
      'purchaseToken': purchaseToken,
      'orderId': orderId,
      'purchaseTime': purchaseTime,
      'purchaseState': purchaseState,
    };
  }
}