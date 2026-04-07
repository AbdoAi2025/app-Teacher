import 'package:intl/intl.dart';
import 'package:teacher_app/utils/day_utils.dart';

class SubscriptionDateModel {

  final String dateString;
  DateTime? _subscriptionExpireDateDateTime;

  bool get warningLimitExceed => remainingDays <= 5 && remainingDays >= 0;

  SubscriptionDateModel({required this.dateString}){
    if(dateString.isNotEmpty){
      _subscriptionExpireDateDateTime = DateTime.tryParse(dateString);
    }
  }

  bool get isExpired {
    var subscriptionExpireDateDateTime = _subscriptionExpireDateDateTime;
    if (dateString.isEmpty == true || subscriptionExpireDateDateTime == null) return false;
    return DateTime.now().isAfter(subscriptionExpireDateDateTime);
  }

  int get remainingDays {

    var subscriptionExpireDateDateTime = _subscriptionExpireDateDateTime;


    if(subscriptionExpireDateDateTime == null) return -1;

    if (dateString.isEmpty || subscriptionExpireDateDateTime == null) return 0;
    return subscriptionExpireDateDateTime.difference(DateTime.now()).inDays;
  }

  String getSubscriptionEndDateFormat([String? dateFormat]) {
    return AppDateUtils.parsDateToString(_subscriptionExpireDateDateTime , format: dateFormat ?? 'yyyy/MM/dd');
  }

}
