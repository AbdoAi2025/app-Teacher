import 'package:intl/intl.dart';

class CheckUserSessionModel {

  final bool isActive;
  final bool isSubscribed;
  final String? subscriptionExpireDate;

  CheckUserSessionModel({
    required this.isActive,
    required this.isSubscribed,
    this.subscriptionExpireDate,
  });

  /// Calculate remaining days until subscription expires
  /// Returns null if subscriptionExpireDate is null, empty, or parsing fails
  /// Returns negative values if subscription has already expired
  int? getRemainingDays() {
    if (subscriptionExpireDate == null || subscriptionExpireDate!.isEmpty) {
      return null;
    }

    try {
      final expireDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(subscriptionExpireDate!);
      final today = DateTime.now();
      final difference = expireDate.difference(today);
      return difference.inDays;
    } catch (e) {
      // If date parsing fails, return null
      return null;
    }
  }
}
