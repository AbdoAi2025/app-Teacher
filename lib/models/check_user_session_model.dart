import 'package:intl/intl.dart';
import 'package:teacher_app/models/subscription_date_model.dart';

class CheckUserSessionModel {

  final bool isActive;
  final bool isSubscribed;
  final SubscriptionDateModel subscriptionExpireDate;

  CheckUserSessionModel({
    required this.isActive,
    required this.isSubscribed,
    required this.subscriptionExpireDate,
  });

  int? getRemainingDays() {
    return subscriptionExpireDate.remainingDays;
  }

  bool get warningLimitExceed => subscriptionExpireDate.warningLimitExceed;
}
