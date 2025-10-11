import '../../models/current_subscription_plan_model.dart';

class CurrentSubscriptionPlanResponse {
  final String? planCode;
  final String? planName;
  final int? studentLimit;
  final int? totalStudentCount;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final String? subscriptionExpireDate;
  final bool? subscribed;
  final bool? expired;

  CurrentSubscriptionPlanResponse({
    this.planCode,
    this.planName,
    this.studentLimit,
    this.totalStudentCount,
    this.monthlyPrice,
    this.yearlyPrice,
    this.subscriptionExpireDate,
    this.subscribed,
    this.expired,
  });

  factory CurrentSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionPlanResponse(
      planCode: json['planCode'] as String?,
      planName: json['planName'] as String?,
      studentLimit: json['studentLimit'] as int?,
      totalStudentCount: json['totalStudentCount'] as int?,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      subscriptionExpireDate: json['subscriptionExpireDate'] as String?,
      subscribed: json['subscribed'] as bool?,
      expired: json['expired'] as bool?,
    );
  }

  CurrentSubscriptionPlanModel toModel() {
    return CurrentSubscriptionPlanModel(
      planCode: planCode,
      planName: planName,
      studentLimit: studentLimit,
      totalStudentCount: totalStudentCount,
      monthlyPrice: monthlyPrice,
      yearlyPrice: yearlyPrice,
      subscriptionExpireDate: subscriptionExpireDate != null
          ? DateTime.parse(subscriptionExpireDate!)
          : null,
      isSubscribed: subscribed ?? false,
      isExpired: expired ?? false,
    );
  }
}