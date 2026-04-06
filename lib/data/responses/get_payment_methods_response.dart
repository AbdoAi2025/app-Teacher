import 'package:teacher_app/domain/models/payment_method_model.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetPaymentMethodsResponse {
  GetPaymentMethodsResponse({
    this.paymentMethods,
  });

  GetPaymentMethodsResponse.fromJson(dynamic json) {
    if (json['paymentMethods'] != null) {
      paymentMethods = [];
      json['paymentMethods'].forEach((v) {
        paymentMethods?.add(PaymentMethodModel.fromJson(v));
      });
    }
  }

  List<PaymentMethodModel>? paymentMethods;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (paymentMethods != null) {
      map['paymentMethods'] = paymentMethods?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}