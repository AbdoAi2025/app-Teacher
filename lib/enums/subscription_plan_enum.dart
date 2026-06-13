import 'package:get/get.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

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
        return AppStringsKeys.freePlan.tr;
      case SubscriptionPlanEnum.BASIC:
        return AppStringsKeys.basicPlan.tr;
      case SubscriptionPlanEnum.PREMIUM:
        return AppStringsKeys.premiumPlan.tr;
      case SubscriptionPlanEnum.UNLIMITED:
        return AppStringsKeys.unlimitedPlan.tr;
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