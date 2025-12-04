import 'package:teacher_app/domain/models/subscription_plan_model.dart';

class GetSubscriptionPlansResponse {
  GetSubscriptionPlansResponse({
    this.data,
  });

  GetSubscriptionPlansResponse.fromJson(dynamic json) {
    if (json is List) {
      data = [];
      json.forEach((v) {
        data?.add(SubscriptionPlanModel.fromJson(v));
      });
    }
  }

  List<SubscriptionPlanModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}