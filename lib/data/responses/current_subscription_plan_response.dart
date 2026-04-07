import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

import '../../enums/subscription_plan_enum.dart';
import '../../models/subscription_date_model.dart';

class CurrentSubscriptionPlanResponse {
  final String? planCode;
  final String? planName;
  final int? studentLimit;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final SubscriptionDateModel subscriptionExpireDate;
  final int? totalStudentCount;
  final String? descriptionAr;
  final String? descriptionEn;
  final bool? _isSubscribed;
  final bool? _isExpired;

  // Computed properties
  bool get isSubscribed => _isSubscribed == true && planCode != null && planCode!.isNotEmpty;

  bool get isExpired {
    return subscriptionExpireDate.isExpired;
  }

  SubscriptionPlanEnum? get subscriptionPlanEnum {
    return SubscriptionPlanEnum.fromDisplayName(planName);
  }



  CurrentSubscriptionPlanResponse({
    this.planCode,
    this.planName,
    this.studentLimit,
    this.monthlyPrice,
    this.yearlyPrice,
    required this.subscriptionExpireDate,
    this.totalStudentCount,
    this.descriptionAr,
    this.descriptionEn,
    bool? isSubscribed,
    bool? isExpired,
  }) : _isSubscribed = isSubscribed,
        _isExpired = isExpired;

  factory CurrentSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    appLog("CurrentSubscriptionPlanResponse fromJson json:$json");
    return CurrentSubscriptionPlanResponse(
      planCode: json['planCode'] as String?,
      planName: json['planName'] as String?,
      studentLimit: json['studentLimit'] as int?,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      subscriptionExpireDate: SubscriptionDateModel(dateString: json.tryString('subscriptionExpireDate') ?? ""),
      isSubscribed: json['subscribed'] as bool? ?? false,
      isExpired: json['expired'] as bool? ?? false,
      totalStudentCount: json['totalStudentCount'] as int?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planCode': planCode,
      'planName': planName,
      'studentLimit': studentLimit,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'subscriptionExpireDate': subscriptionExpireDate.toString(),
      'isSubscribed': isSubscribed,
      'isExpired': isExpired,
      'totalStudentCount': totalStudentCount,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
    };
  }
}