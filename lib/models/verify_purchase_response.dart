import 'package:teacher_app/utils/safe_json_access.dart';

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
      userId: json.tryString('userId'),
      teacherId: json.tryString('teacherId'),
      subscriptionPlanCode: json.tryString('subscriptionPlanCode'),
      subscriptionPlanName: json.tryString('subscriptionPlanName'),
      expirationDate: json.tryInt('expirationDate') != null
          ? DateTime.fromMillisecondsSinceEpoch(json.tryInt('expirationDate')!)
          : null,
      billingPeriod: json.tryString('billingPeriod') != null
          ? BillingPeriod.fromJson(json.tryString('billingPeriod')!)
          : null,
      amountCharged: json.tryDouble('amountCharged'),
      actionType: json.tryString('actionType'),
      previousPlanName: json.tryString('previousPlanName'),
      verified: json.tryBool('verified') ?? false,
      success: json.tryBool('success') ?? false,
      message: json.tryString('message') ?? '',
      purchaseToken: json.tryString('purchaseToken'),
      orderId: json.tryString('orderId'),
      purchaseTime: json.tryInt('purchaseTime'),
      purchaseState: json.tryString('purchaseState'),
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