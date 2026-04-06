import 'package:teacher_app/utils/safe_json_access.dart';
import '../enums/billing_period.dart';

class SubscribeData {
  final String? userId;
  final String? teacherId;
  final String? subscriptionPlanCode;
  final String? subscriptionPlanName;
  final DateTime? expirationDate;
  final BillingPeriod? billingPeriod;
  final double? amountCharged;
  final String? actionType;
  final String? previousPlanName;
  final bool success;
  final String? message;

  SubscribeData({
    this.userId,
    this.teacherId,
    this.subscriptionPlanCode,
    this.subscriptionPlanName,
    this.expirationDate,
    this.billingPeriod,
    this.amountCharged,
    this.actionType,
    this.previousPlanName,
    required this.success,
    this.message,
  });

  factory SubscribeData.fromJson(Map<String, dynamic> json) {
    return SubscribeData(
      userId: json.tryString('userId'),
      teacherId: json.tryString('teacherId'),
      subscriptionPlanCode: json.tryString('subscriptionPlanCode'),
      subscriptionPlanName: json.tryString('subscriptionPlanName'),
      expirationDate: json.tryString('expirationDate') != null
          ? DateTime.tryParse(json.tryString('expirationDate')!)
          : null,
      billingPeriod: json.tryString('billingPeriod') != null
          ? BillingPeriod.fromJson(json.tryString('billingPeriod')!)
          : null,
      amountCharged: json.tryDouble('amountCharged'),
      actionType: json.tryString('actionType'),
      previousPlanName: json.tryString('previousPlanName'),
      success: json.tryBool('success') ?? false,
      message: json.tryString('message'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'teacherId': teacherId,
      'subscriptionPlanCode': subscriptionPlanCode,
      'subscriptionPlanName': subscriptionPlanName,
      'expirationDate': expirationDate?.toIso8601String(),
      'billingPeriod': billingPeriod?.toJson(),
      'amountCharged': amountCharged,
      'actionType': actionType,
      'previousPlanName': previousPlanName,
      'success': success,
      'message': message,
    };
  }
}

class SubscribeResponse {
  final String status;
  final SubscribeData? data;
  final String message;

  SubscribeResponse({
    required this.status,
    this.data,
    required this.message,
  });

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) {
    return SubscribeResponse(
      status: json.tryString('status') ?? '',
      data: json['data'] != null
          ? SubscribeData.fromJson(json['data'])
          : null,
      message: json.tryString('message') ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
      'message': message,
    };
  }
}