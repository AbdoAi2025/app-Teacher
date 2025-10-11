class CurrentSubscriptionPlanModel {
  final String? planCode;
  final String? planName;
  final int? studentLimit;
  final int? totalStudentCount;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final DateTime? subscriptionExpireDate;
  final bool isSubscribed;
  final bool isExpired;

  CurrentSubscriptionPlanModel({
    this.planCode,
    this.planName,
    this.studentLimit,
    this.totalStudentCount,
    this.monthlyPrice,
    this.yearlyPrice,
    this.subscriptionExpireDate,
    required this.isSubscribed,
    required this.isExpired,
  });

  factory CurrentSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionPlanModel(
      planCode: json['planCode'] as String?,
      planName: json['planName'] as String?,
      studentLimit: json['studentLimit'] as int?,
      totalStudentCount: json['totalStudentCount'] as int?,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      subscriptionExpireDate: json['subscriptionExpireDate'] != null
          ? DateTime.parse(json['subscriptionExpireDate'] as String)
          : null,
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      isExpired: json['isExpired'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planCode': planCode,
      'planName': planName,
      'studentLimit': studentLimit,
      'totalStudentCount': totalStudentCount,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'subscriptionExpireDate': subscriptionExpireDate?.toIso8601String(),
      'isSubscribed': isSubscribed,
      'isExpired': isExpired,
    };
  }

  bool get hasValidSubscription => isSubscribed && !isExpired;

  int get daysRemaining {
    if (subscriptionExpireDate == null) return 0;
    final difference = subscriptionExpireDate!.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  String get formattedMonthlyPrice {
    if (monthlyPrice == null) return '';
    return '\$${monthlyPrice!.toStringAsFixed(2)}';
  }

  String get formattedYearlyPrice {
    if (yearlyPrice == null) return '';
    return '\$${yearlyPrice!.toStringAsFixed(2)}';
  }

  @override
  String toString() {
    return 'CurrentSubscriptionPlanModel(planCode: $planCode, planName: $planName, isSubscribed: $isSubscribed, isExpired: $isExpired)';
  }
}