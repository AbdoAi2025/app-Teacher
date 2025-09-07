
import 'package:get/get.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../enums/sort_enum.dart';
import '../../screens/groups/groups_state.dart';

class GroupsCategorizedUseCase{

  List<GroupItemUiState> execute(List<GroupItemUiState> groups , SortEnum type ) {

    final Map<String, List<GroupItemUiState>> grouped = {};

    for (final group in groups) {
      var key = '';
      if(type == SortEnum.byDay){
        key = group.dayName.tr;
      }else if(type == SortEnum.byGrade){
        key = group.gradeName;
      }
      if(key.isNotEmpty){
        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(group);
      }
    }


    /*check if grouped is empty, return groups*/
    if(grouped.isEmpty){
      return groups;
    }

    // Optional: sort inside each day by timeFrom
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => AppDateUtils.parseTime(a.timeFrom).compareTo(AppDateUtils.parseTime(b.timeFrom)));
    }

    List<GroupItemUiState> sortedGroups = [];

    grouped.forEach((key, value) {
      sortedGroups.add(GroupItemTitleUiState(
          title: "$key(${value.length})"));
      sortedGroups.addAll(value);

    });
    return sortedGroups;
  }




}
