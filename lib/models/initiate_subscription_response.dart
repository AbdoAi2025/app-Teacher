import 'package:teacher_app/utils/safe_json_access.dart';
import '../enums/billing_period.dart';
import '../enums/payment_provider_type.dart';

class PaymentMethods {
  final bool cardEnabled;
  final bool walletEnabled;
  final bool installmentsEnabled;
  final bool kioskEnabled;

  PaymentMethods({
    required this.cardEnabled,
    required this.walletEnabled,
    required this.installmentsEnabled,
    required this.kioskEnabled,
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    return PaymentMethods(
      cardEnabled: json.tryBool('cardEnabled') ?? false,
      walletEnabled: json.tryBool('walletEnabled') ?? false,
      installmentsEnabled: json.tryBool('installmentsEnabled') ?? false,
      kioskEnabled: json.tryBool('kioskEnabled') ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardEnabled': cardEnabled,
      'walletEnabled': walletEnabled,
      'installmentsEnabled': installmentsEnabled,
      'kioskEnabled': kioskEnabled,
    };
  }
}

class AdditionalPaymentData {
  final String? merchantOrderId;
  final double? subscriptionPlanPrice;
  final String? subscriptionPlanDescription;

  AdditionalPaymentData({
    this.merchantOrderId,
    this.subscriptionPlanPrice,
    this.subscriptionPlanDescription,
  });

  factory AdditionalPaymentData.fromJson(Map<String, dynamic> json) {
    return AdditionalPaymentData(
      merchantOrderId: json.tryString('merchant_order_id'),
      subscriptionPlanPrice: json.tryDouble('subscription_plan_price'),
      subscriptionPlanDescription: json.tryString('subscription_plan_description'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchant_order_id': merchantOrderId,
      'subscription_plan_price': subscriptionPlanPrice,
      'subscription_plan_description': subscriptionPlanDescription,
    };
  }
}

class InitiateSubscriptionData {
  final bool success;
  final String? paymentKey;
  final String? paymentTransactionId;
  final String? providerTransactionId;
  final PaymentProviderType? paymentProviderType;
  final String? paymentStatus;
  final String? subscriptionId;
  final String? subscriptionPlanCode;
  final String? subscriptionPlanName;
  final BillingPeriod? billingPeriod;
  final double? amount;
  final String? currency;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionExpirationDate;
  final String? actionType;
  final String? userId;
  final String? teacherId;
  final String? previousPlanName;
  final String? paymentUrl;
  final String? iframeUrl;
  final String? mobileWalletUrl;
  final String? redirectUrl;
  final DateTime? paymentKeyExpirationTime;
  final int? paymentKeyExpirationMinutes;
  final AdditionalPaymentData? additionalPaymentData;
  final String? message;
  final String? errorCode;
  final PaymentMethods? paymentMethods;

  InitiateSubscriptionData({
    required this.success,
    this.paymentKey,
    this.paymentTransactionId,
    this.providerTransactionId,
    this.paymentProviderType,
    this.paymentStatus,
    this.subscriptionId,
    this.subscriptionPlanCode,
    this.subscriptionPlanName,
    this.billingPeriod,
    this.amount,
    this.currency,
    this.subscriptionStartDate,
    this.subscriptionExpirationDate,
    this.actionType,
    this.userId,
    this.teacherId,
    this.previousPlanName,
    this.paymentUrl,
    this.iframeUrl,
    this.mobileWalletUrl,
    this.redirectUrl,
    this.paymentKeyExpirationTime,
    this.paymentKeyExpirationMinutes,
    this.additionalPaymentData,
    this.message,
    this.errorCode,
    this.paymentMethods,
  });

  factory InitiateSubscriptionData.fromJson(Map<String, dynamic> json) {
    return InitiateSubscriptionData(
      success: json.tryBool('success') ?? false,
      paymentKey: json.tryString('paymentKey'),
      paymentTransactionId: json.tryString('paymentTransactionId'),
      providerTransactionId: json.tryString('providerTransactionId'),
      paymentProviderType: json.tryString('paymentProviderType') != null
          ? PaymentProviderType.fromJson(json.tryString('paymentProviderType')!)
          : null,
      paymentStatus: json.tryString('paymentStatus'),
      subscriptionId: json.tryString('subscriptionId'),
      subscriptionPlanCode: json.tryString('subscriptionPlanCode'),
      subscriptionPlanName: json.tryString('subscriptionPlanName'),
      billingPeriod: json.tryString('billingPeriod') != null
          ? BillingPeriod.fromJson(json.tryString('billingPeriod')!)
          : null,
      amount: json.tryDouble('amount'),
      currency: json.tryString('currency'),
      subscriptionStartDate: json.tryString('subscriptionStartDate') != null
          ? DateTime.tryParse(json.tryString('subscriptionStartDate')!)
          : null,
      subscriptionExpirationDate: json.tryString('subscriptionExpirationDate') != null
          ? DateTime.tryParse(json.tryString('subscriptionExpirationDate')!)
          : null,
      actionType: json.tryString('actionType'),
      userId: json.tryString('userId'),
      teacherId: json.tryString('teacherId'),
      previousPlanName: json.tryString('previousPlanName'),
      paymentUrl: json.tryString('paymentUrl'),
      iframeUrl: json.tryString('iframeUrl'),
      mobileWalletUrl: json.tryString('mobileWalletUrl'),
      redirectUrl: json.tryString('redirectUrl'),
      paymentKeyExpirationTime: json.tryString('paymentKeyExpirationTime') != null
          ? DateTime.tryParse(json.tryString('paymentKeyExpirationTime')!)
          : null,
      paymentKeyExpirationMinutes: json.tryInt('paymentKeyExpirationMinutes'),
      additionalPaymentData: json['additionalPaymentData'] != null
          ? AdditionalPaymentData.fromJson(json['additionalPaymentData'])
          : null,
      message: json.tryString('message'),
      errorCode: json.tryString('errorCode'),
      paymentMethods: json['paymentMethods'] != null
          ? PaymentMethods.fromJson(json['paymentMethods'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'paymentKey': paymentKey,
      'paymentTransactionId': paymentTransactionId,
      'providerTransactionId': providerTransactionId,
      'paymentProviderType': paymentProviderType?.toJson(),
      'paymentStatus': paymentStatus,
      'subscriptionId': subscriptionId,
      'subscriptionPlanCode': subscriptionPlanCode,
      'subscriptionPlanName': subscriptionPlanName,
      'billingPeriod': billingPeriod?.toJson(),
      'amount': amount,
      'currency': currency,
      'subscriptionStartDate': subscriptionStartDate?.toIso8601String(),
      'subscriptionExpirationDate': subscriptionExpirationDate?.toIso8601String(),
      'actionType': actionType,
      'userId': userId,
      'teacherId': teacherId,
      'previousPlanName': previousPlanName,
      'paymentUrl': paymentUrl,
      'iframeUrl': iframeUrl,
      'mobileWalletUrl': mobileWalletUrl,
      'redirectUrl': redirectUrl,
      'paymentKeyExpirationTime': paymentKeyExpirationTime?.toIso8601String(),
      'paymentKeyExpirationMinutes': paymentKeyExpirationMinutes,
      'additionalPaymentData': additionalPaymentData?.toJson(),
      'message': message,
      'errorCode': errorCode,
      'paymentMethods': paymentMethods?.toJson(),
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