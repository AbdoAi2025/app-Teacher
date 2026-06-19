import 'package:teacher_app/models/subscription_date_model.dart';

class CheckUserSessionModel {

  final bool isActive;
  final bool isSubscribed;
  final SubscriptionDateModel subscriptionExpireDate;
  final bool mustCompleteProfile;
  final bool requireVerify;
  final String? userId;
  final String? otpSentTo;

  CheckUserSessionModel({
    required this.isActive,
    required this.isSubscribed,
    required this.subscriptionExpireDate,
    this.mustCompleteProfile = false,
    this.requireVerify = false,
    this.userId,
    this.otpSentTo,
  });

  int? getRemainingDays() {
    return subscriptionExpireDate.remainingDays;
  }

  bool get warningLimitExceed => subscriptionExpireDate.warningLimitExceed;
}
