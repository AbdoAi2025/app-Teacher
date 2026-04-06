import 'package:teacher_app/utils/safe_json_access.dart';

import '../enums/payment_provider_type.dart';

class InitialSubscriptionModel {
  final String paymentKey;
  final String orderId;
  final String merchantOrderId;
  final PaymentProviderType paymentProviderType;

  InitialSubscriptionModel({
    required this.paymentKey,
    required this.orderId,
    required this.merchantOrderId,
    required this.paymentProviderType,
  });
}