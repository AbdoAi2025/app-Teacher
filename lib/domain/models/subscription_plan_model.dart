class SubscriptionPlanModel {
  final String? planCode;
  final String? planName;
  final String? description;
  final double? price;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final int? durationInDays;
  final int? studentLimit;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? purchaseCode;

  SubscriptionPlanModel({
    this.planCode,
    this.planName,
    this.description,
    this.price,
    this.monthlyPrice,
    this.yearlyPrice,
    this.durationInDays,
    this.studentLimit,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.descriptionAr,
    this.descriptionEn,
    this.purchaseCode,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planCode: json['planCode'] as String?,
      planName: json['planName'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num?)?.toDouble(),
      durationInDays: json['durationInDays'] as int?,
      studentLimit: json['studentLimit'] as int?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      purchaseCode: json['purchaseCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planCode': planCode,
      'planName': planName,
      'description': description,
      'price': price,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'durationInDays': durationInDays,
      'studentLimit': studentLimit,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'purchaseCode': purchaseCode,
    };
  }
}