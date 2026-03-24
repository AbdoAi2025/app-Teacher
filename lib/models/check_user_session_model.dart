import 'package:intl/intl.dart';
import 'package:teacher_app/models/subscription_date_model.dart';

class CheckUserSessionModel {

  final bool isActive;
  final bool isSubscribed;
  final SubscriptionDateModel? subscriptionExpireDate;

  CheckUserSessionModel({
    required this.isActive,
    required this.isSubscribed,
    this.subscriptionExpireDate,
  });

  int? getRemainingDays() {
    if (subscriptionExpireDate == null) return null;
    return subscriptionExpireDate!.remainingDays;
  }

  bool get warningLimitExceed => subscriptionExpireDate?.warningLimitExceed ?? false;
}
