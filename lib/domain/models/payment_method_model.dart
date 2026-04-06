import 'package:teacher_app/enums/payment_method_enum.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class PaymentMethodModel {
  final int? id;
  final PaymentMethodEnum? paymentMethodEnum;
  final bool? enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethodModel({
    this.id,
    this.paymentMethodEnum,
    this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json.tryInt('id'),
      paymentMethodEnum: PaymentMethodEnum.fromDisplayName(json.tryString('name') ?? '') ,
      enabled: json.tryBool('enabled'),
      createdAt: json.tryString('createdAt') != null
          ? DateTime.tryParse(json.tryString('createdAt')!)
          : null,
      updatedAt: json.tryString('updatedAt') != null
          ? DateTime.tryParse(json.tryString('updatedAt')!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': paymentMethodEnum,
      'enabled': enabled,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }


  String? get paymentMethodName {
    return paymentMethodEnum?.displayName;
  }

  bool get isOnlinePayment {
    final enumType = paymentMethodEnum;
    return enumType == PaymentMethodEnum.ONLINE || enumType == PaymentMethodEnum.WALLET;
  }

  bool get isCashPayment {
    return paymentMethodEnum == PaymentMethodEnum.CASH;
  }
}