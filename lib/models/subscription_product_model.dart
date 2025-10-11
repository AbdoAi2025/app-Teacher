import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProductModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final Duration duration;
  final ProductDetails? productDetails;

  SubscriptionProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    this.productDetails,
  });

  static const String monthlySubscriptionId = 'assistantapp_plan_basic_month_200';
  static const String yearlySubscriptionId = 'assistantapp_plan_basic_year_1800';

  static SubscriptionProductModel monthly({ProductDetails? productDetails}) {
    return SubscriptionProductModel(
      id: monthlySubscriptionId,
      title: 'Monthly Subscription',
      description: 'Access all premium features for 1 month',
      price: productDetails?.price ?? '€9.99',
      duration: const Duration(days: 30),
      productDetails: productDetails,
    );
  }

  static SubscriptionProductModel yearly({ProductDetails? productDetails}) {
    return SubscriptionProductModel(
      id: yearlySubscriptionId,
      title: 'Yearly Subscription',
      description: 'Access all premium features for 1 year - Best Value!',
      price: productDetails?.price ?? '€99.99',
      duration: const Duration(days: 365),
      productDetails: productDetails,
    );
  }

  bool get isMonthly => id == monthlySubscriptionId;
  bool get isYearly => id == yearlySubscriptionId;

  String get formattedDuration {
    if (isMonthly) return '1 Month';
    if (isYearly) return '1 Year';
    return '${duration.inDays} Days';
  }

  String get savingsText {
    if (isYearly) return 'Save 17%';
    return '';
  }

  bool get isRecommended => isYearly;
}