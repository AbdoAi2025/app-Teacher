import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/enums/subscription_plan_enum.dart';

import '../../../models/subscription_date_model.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SubscriptionPlanItemUiState {
  final String planCode;
  final String _planName;
  final String description;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final int durationInDays;
  final int studentLimit;
  final bool isActive;
  final bool isPopular;
  final SubscriptionDateModel? expirationDate;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? purchaseCode;
  final bool isCurrentPlan;

  SubscriptionPlanItemUiState({
    required this.planCode,
    required String  planName,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.durationInDays,
    required this.studentLimit,
    required this.isActive,
    required this.isCurrentPlan,
    this.isPopular = false,
    this.expirationDate,
    this.descriptionAr,
    this.descriptionEn,
    this.purchaseCode,
  }) : _planName = planName;

  factory SubscriptionPlanItemUiState.fromModel(SubscriptionPlanModel model, bool isCurrentPlan, {int? totalStudentCount}) {
    return SubscriptionPlanItemUiState(
        planCode: model.planCode ?? "",
        planName: model.planName ?? "",
        description: model.description ?? "",
        monthlyPrice: model.monthlyPrice,
        yearlyPrice: model.yearlyPrice,
        durationInDays: model.durationInDays ?? 0,
        studentLimit: model.studentLimit ?? 0,
        isActive: model.isActive ?? false,
        descriptionAr: model.descriptionAr,
        descriptionEn: model.descriptionEn,
        purchaseCode: model.purchaseCode,
        isCurrentPlan: isCurrentPlan
    );
  }

  String get formattedStudentLimit {
    // Check if this is an unlimited plan (PREMIUM or UNLIMITED)
    final planEnum = SubscriptionPlanEnum.fromValue(planCode);
    if (planEnum == SubscriptionPlanEnum.UNLIMITED) {
      return AppStringsKeys.unlimited.tr;
    }
    return "${AppStringsKeys.upTo.tr} $studentLimit ${AppStringsKeys.students2.tr}";
  }

  // Get monthly and annual pricing from API
  double get monthlyPriceValue => monthlyPrice ?? 0.0;

  double get annualPriceValue => yearlyPrice ?? 0.0;

  String get formattedMonthlyPrice =>
      "${monthlyPriceValue.toStringAsFixed(0)} EGP";

  String get formattedAnnualPrice =>
      "${annualPriceValue.toStringAsFixed(0)} EGP";

  String? get formattedExpirationDate {
    if (expirationDate == null) return null;
    return  expirationDate?.getSubscriptionEndDateFormat();
  }
  
  bool get showExpirationSection => formattedExpirationDate != null && formattedExpirationDate!.isNotEmpty && isCurrentPlan  && !isFree();


  String get localizedDescription {
    final currentLocale = Get.locale?.languageCode ?? 'en';

    if (currentLocale == 'ar') {
      return descriptionAr?.isNotEmpty == true
          ? descriptionAr!
          : (descriptionEn?.isNotEmpty == true ? descriptionEn! : description);
    } else {
      return descriptionEn?.isNotEmpty == true
          ? descriptionEn!
          : (descriptionAr?.isNotEmpty == true ? descriptionAr! : description);
    }
  }

  String get planName =>_planName.tr;


  Map<String, dynamic> toJson() {
    return {
      'planCode': this.planCode,
      'planName': this.planName,
      'description': this.description,
      'monthlyPrice': this.monthlyPrice,
      'yearlyPrice': this.yearlyPrice,
      'durationInDays': this.durationInDays,
      'studentLimit': this.studentLimit,
      'isActive': this.isActive,
      'isPopular': this.isPopular,
      'expirationDate': this.expirationDate,
      'descriptionAr': this.descriptionAr,
      'descriptionEn': this.descriptionEn,
      'purchaseCode': this.purchaseCode,
    };
  }

  bool isExpired() {
    if (expirationDate == null) return true;
    return expirationDate!.isExpired;
  }

  bool isFree() => SubscriptionPlanEnum.fromDisplayName(planCode) == SubscriptionPlanEnum.FREE;
}
