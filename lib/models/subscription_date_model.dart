import 'package:intl/intl.dart';
import 'package:teacher_app/utils/day_utils.dart';

class SubscriptionDateModel {

  final String dateString;
  late final DateTime? _subscriptionExpireDateDateTime;

  bool get warningLimitExceed => remainingDays <= 5;

  SubscriptionDateModel({required this.dateString}){
    _subscriptionExpireDateDateTime = DateTime.tryParse(dateString);
  }

  bool get isExpired {
    if (dateString.isEmpty || _subscriptionExpireDateDateTime == null) return false;
    return DateTime.now().isAfter(_subscriptionExpireDateDateTime);
  }

  int get remainingDays {
    if (dateString.isEmpty || _subscriptionExpireDateDateTime == null) return 0;
    return _subscriptionExpireDateDateTime.difference(DateTime.now()).inDays;
  }

  String getSubscriptionEndDateFormat([String? dateFormat]) {
    return AppDateUtils.parsDateToString(_subscriptionExpireDateDateTime , format: dateFormat ?? 'yyyy/MM/dd');
  }

}
