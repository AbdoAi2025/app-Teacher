class SubscriptionPlanModel {
  final String planCode;
  final String planName;
  final int studentLimit;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final DateTime? createdAt;

  SubscriptionPlanModel({
    required this.planCode,
    required this.planName,
    required this.studentLimit,
    this.monthlyPrice,
    this.yearlyPrice,
    this.createdAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planCode: json['planCode'] as String,
      planName: json['planName'] as String,
      studentLimit: json['studentLimit'] as int,
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planCode': planCode,
      'planName': planName,
      'studentLimit': studentLimit,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String get formattedMonthlyPrice {
    if (monthlyPrice == null) return 'Free';
    return '\$${monthlyPrice!.toStringAsFixed(2)}/month';
  }

  String get formattedYearlyPrice {
    if (yearlyPrice == null) return 'Free';
    return '\$${yearlyPrice!.toStringAsFixed(2)}/year';
  }

  bool get isFree => planCode == 'FREE';
  bool get isBasic => planCode == 'BASIC';
  bool get isPremium => planCode == 'PREMIUM';
  bool get isUnlimited => planCode == 'UNLIMITED';

  String get studentLimitText {
    if (isUnlimited) return 'Unlimited students';
    return '$studentLimit students maximum';
  }

  List<String> get features {
    switch (planCode) {
      case 'FREE':
        return [
          'Up to $studentLimit students',
          // 'Basic reporting',
          'Limited sessions',
        ];
      case 'BASIC':
        return [
          'Up to $studentLimit students',
          // 'Advanced reporting',
          // 'Unlimited sessions',
          // 'Email support',
        ];
      case 'PREMIUM':
        return [
          'Up to $studentLimit students',
          // 'Advanced analytics',
          // 'Export data',
          // 'Priority support',
          // 'Custom features',
        ];
      case 'UNLIMITED':
        return [
          'Unlimited students',
          // 'All premium features',
          // 'Advanced analytics',
          // 'Export data',
          // 'Priority support',
          // '24/7 chat support',
        ];
      default:
        return [];
    }
  }

  @override
  String toString() {
    return 'SubscriptionPlanModel(planCode: $planCode, planName: $planName, studentLimit: $studentLimit)';
  }
}