import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';

class SubscriptionPlanItemUiState {
  final String planCode;
  final String planName;
  final String description;
  final double price;
  final double? monthlyPrice;
  final double? yearlyPrice;
  final int durationInDays;
  final int studentLimit;
  final bool isActive;
  final bool isPopular;
  final DateTime? expirationDate;
  final String? descriptionAr;
  final String? descriptionEn;

  SubscriptionPlanItemUiState({
    required this.planCode,
    required this.planName,
    required this.description,
    required this.price,
    this.monthlyPrice,
    this.yearlyPrice,
    required this.durationInDays,
    required this.studentLimit,
    required this.isActive,
    this.isPopular = false,
    this.expirationDate,
    this.descriptionAr,
    this.descriptionEn,
  });

  factory SubscriptionPlanItemUiState.fromModel(SubscriptionPlanModel model) {
    return SubscriptionPlanItemUiState(
      planCode: model.planCode ?? "",
      planName: model.planName ?? "",
      description: model.description ?? "",
      price: model.price ?? 0.0,
      monthlyPrice: model.monthlyPrice,
      yearlyPrice: model.yearlyPrice,
      durationInDays: model.durationInDays ?? 0,
      studentLimit: model.studentLimit ?? 0,
      isActive: model.isActive ?? false,
      descriptionAr: model.descriptionAr,
      descriptionEn: model.descriptionEn,
    );
  }

  String get formattedPrice => "${price.toStringAsFixed(0)} EGP";
  String get formattedStudentLimit => "${'Up to'.tr} $studentLimit ${'students'.tr}";

  // Get monthly and annual pricing from API
  double get monthlyPriceValue => monthlyPrice ?? 0.0;
  double get annualPriceValue => yearlyPrice ?? 0.0;

  String get formattedMonthlyPrice => "${monthlyPriceValue.toStringAsFixed(0)} EGP";
  String get formattedAnnualPrice => "${annualPriceValue.toStringAsFixed(0)} EGP";

  String? get formattedExpirationDate {
    if (expirationDate == null) return null;
    return DateFormat('yyyy/MM/dd').format(expirationDate!);
  }

  String get localizedDescription {
    final currentLocale = Get.locale?.languageCode ?? 'en';

    if (currentLocale == 'ar') {
      return descriptionAr?.isNotEmpty == true ? descriptionAr! :
             (descriptionEn?.isNotEmpty == true ? descriptionEn! : description);
    } else {
      return descriptionEn?.isNotEmpty == true ? descriptionEn! :
             (descriptionAr?.isNotEmpty == true ? descriptionAr! : description);
    }
  }
}