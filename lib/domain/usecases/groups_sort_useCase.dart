import '../../models/group_item_model.dart';
import '../../utils/day_utils.dart';

class GroupsSortUseCase{

  List<GroupItemModel> execute(List<GroupItemModel> groups) {
    groups.sort((a, b) {
      // 1. Sort by day
      final dayCompare = a.day.compareTo(b.day);
      if (dayCompare != 0) return dayCompare;
      // 2. Sort by timeFrom (24h)
      final timeA = AppDateUtils.parseTime(a.timeFrom);
      final timeB = AppDateUtils.parseTime(b.timeFrom);
      return timeA.compareTo(timeB);
    });
    return groups;
  }

}
