import 'package:teacher_app/utils/safe_json_access.dart';
import '../enums/billing_period.dart';
import '../enums/payment_provider_type.dart';
import '../enums/service_type.dart';

class InitiateSubscriptionData {
  final String? paymentKey;
  final String? orderId;
  final String? merchantOrderId;
  final PaymentProviderType? paymentProviderType;
  final String? subscriptionPlanCode;
  final String? subscriptionPlanName;
  final BillingPeriod? billingPeriod;
  final double? amount;
  final String? currency;
  final ServiceType? serviceType;

  InitiateSubscriptionData({
    this.paymentKey,
    this.orderId,
    this.merchantOrderId,
    this.paymentProviderType,
    this.subscriptionPlanCode,
    this.subscriptionPlanName,
    this.billingPeriod,
    this.amount,
    this.currency,
    this.serviceType,
  });

  factory InitiateSubscriptionData.fromJson(Map<String, dynamic> json) {
    return InitiateSubscriptionData(
      paymentKey: json.tryString('paymentKey'),
      orderId: json.tryString('orderId'),
      merchantOrderId: json.tryString('merchantOrderId'),
      paymentProviderType: json.tryString('paymentProviderType') != null
          ? PaymentProviderType.fromJson(json.tryString('paymentProviderType')!)
          : null,
      subscriptionPlanCode: json.tryString('subscriptionPlanCode'),
      subscriptionPlanName: json.tryString('subscriptionPlanName'),
      billingPeriod: json.tryString('billingPeriod') != null
          ? BillingPeriod.fromJson(json.tryString('billingPeriod')!)
          : null,
      amount: json.tryDouble('amount'),
      currency: json.tryString('currency'),
      serviceType: json.tryString('serviceType') != null
          ? ServiceType.fromJson(json.tryString('serviceType')!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentKey': paymentKey,
      'orderId': orderId,
      'merchantOrderId': merchantOrderId,
      'paymentProviderType': paymentProviderType?.toJson(),
      'subscriptionPlanCode': subscriptionPlanCode,
      'subscriptionPlanName': subscriptionPlanName,
      'billingPeriod': billingPeriod?.toJson(),
      'amount': amount,
      'currency': currency,
      'serviceType': serviceType?.toJson(),
    };
  }
}

class InitiateSubscriptionResponse {
  final String status;
  final InitiateSubscriptionData? data;
  final String message;

  InitiateSubscriptionResponse({
    required this.status,
    this.data,
    required this.message,
  });

  factory InitiateSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return InitiateSubscriptionResponse(
      status: json.tryString('status') ?? '',
      data: json['data'] != null
          ? InitiateSubscriptionData.fromJson(json['data'])
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