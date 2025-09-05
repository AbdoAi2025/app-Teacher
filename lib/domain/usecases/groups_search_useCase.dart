import 'package:get/get.dart';

import '../../models/group_item_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../utils/day_utils.dart';

class GroupsSearchUseCase{

  List<GroupItemUiState> execute(List<GroupItemUiState> groups , String query) {

    return groups.where((element) =>
        element.groupName.toLowerCase().contains(query.toLowerCase()) ||
            element.date.tr.toLowerCase().contains(query.toLowerCase()) ||
            element.timeFrom.toLowerCase().contains(query.toLowerCase()) ||
            element.timeTo.toLowerCase().contains(query.toLowerCase()) ||
            element.gradeNameEn.contains(query.toLowerCase()) ||
            element.gradeNameAr.contains(query.toLowerCase())
    ).toList();
  }

}
