import 'package:get/get.dart';

enum SubscriptionPlanEnum {
  FREE("FREE", "Free Plan"),
  BASIC("BASIC", "Basic Plan"),
  PREMIUM("PREMIUM", "Premium Plan"),
  UNLIMITED("UNLIMITED", "Unlimited Plan");

  const SubscriptionPlanEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  String get localizedName {
    switch (this) {
      case SubscriptionPlanEnum.FREE:
        return "Free Plan".tr;
      case SubscriptionPlanEnum.BASIC:
        return "Basic Plan".tr;
      case SubscriptionPlanEnum.PREMIUM:
        return "Premium Plan".tr;
      case SubscriptionPlanEnum.UNLIMITED:
        return "Unlimited Plan".tr;
    }
  }

  static SubscriptionPlanEnum? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;

    for (SubscriptionPlanEnum plan in SubscriptionPlanEnum.values) {
      if (plan.value.toLowerCase() == value.toLowerCase()) {
        return plan;
      }
    }
    return null;
  }

  static SubscriptionPlanEnum? fromDisplayName(String? displayName) {
    if (displayName == null || displayName.isEmpty) return null;

    for (SubscriptionPlanEnum plan in SubscriptionPlanEnum.values) {
      if (plan.displayName.toLowerCase() == displayName.toLowerCase()) {
        return plan;
      }
    }
    return null;
  }

  @override
  String toString() => value;
}