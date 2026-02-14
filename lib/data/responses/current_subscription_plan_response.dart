import 'package:teacher_app/utils/LogUtils.dart';

class CurrentSubscriptionPlanResponse {
  final String? planCode;
  final String? planName;
  final int? studentLimit;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final DateTime? subscriptionExpireDate;
  final bool isSubscribed;
  final bool isExpired;
  final int? totalStudentCount;
  final String? descriptionAr;
  final String? descriptionEn;

  CurrentSubscriptionPlanResponse({
    this.planCode,
    this.planName,
    this.studentLimit,
    this.monthlyPrice,
    this.yearlyPrice,
    this.subscriptionExpireDate,
    this.isSubscribed = false,
    this.isExpired = false,
    this.totalStudentCount,
    this.descriptionAr,
    this.descriptionEn,
  });

  factory CurrentSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    appLog("CurrentSubscriptionPlanResponse fromJson json:$json");
    return CurrentSubscriptionPlanResponse(
      planCode: json['planCode'] as String?,
      planName: json['planName'] as String?,
      studentLimit: json['studentLimit'] as int?,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      subscriptionExpireDate: json['subscriptionExpireDate'] != null
          ? DateTime.tryParse(json['subscriptionExpireDate'].toString())
          : null,

      isSubscribed: json['isSubscribed'] as bool? ?? false,
      isExpired: json['isExpired'] as bool? ?? false,
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
      'subscriptionExpireDate': subscriptionExpireDate?.toIso8601String(),
      'isSubscribed': isSubscribed,
      'isExpired': isExpired,
      'totalStudentCount': totalStudentCount,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
    };
  }
}