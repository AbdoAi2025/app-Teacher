import 'package:get/get.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/domain/usecases/delete_group_use_case.dart';
import 'package:teacher_app/domain/usecases/groups_sort_useCase.dart';
import 'package:teacher_app/enums/sort_enum.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../base/AppResult.dart';
import '../../domain/usecases/get_groups_list_use_case.dart';
import '../../domain/usecases/groups_categorized_useCase.dart';
import '../../domain/usecases/groups_search_useCase.dart';
import 'groups_state.dart';

class GroupsController extends GetxController{


  Rx<GroupsState> state = Rx(GroupsStateLoading());

  SortEnum sortType = SortEnum.byDay;

  String? query;

  @override
  void onInit() {
    super.onInit();
    _initLoadGroups();
  }

  void refreshGroups() {
    GroupsManagers.onRefresh();
  }

  void _initLoadGroups() {

    GroupsManagers.state.listen((state) {
      if(state is GroupsStateSuccess){
        var items =  getGroupsList(state.uiStates.toList());
        this.state.value = GroupsStateSuccess(uiStates: items);
      }else {
        this.state.value = state;
      }
    });

    var stateValue = state.value;
    if(stateValue is GroupsStateSuccess && stateValue.uiStates.isNotEmpty) {
      return;
    }
    GroupsManagers.loadGroups();
  }


  Stream<AppResult<dynamic>>  deleteGroup(GroupItemUiState uiState)  async*{
    var useCase = DeleteGroupUseCase();
    yield await useCase.execute(uiState.groupId);
  }

  onSearchChanged(String? query) {
    this.query = query;
    updateList();
  }

  void onCloseSearch() {
    onSearchChanged(null);
  }

  void sortByDay() {
    sortType = SortEnum.byDay;
    updateList();
  }

  void sortByGrade() {
    sortType = SortEnum.byGrade;
    updateList();
  }

  void resetSort() {}

  void updateList() {
    var stateValue = GroupsManagers.state.value;
    if(stateValue is GroupsStateSuccess){
      var items = stateValue.uiStates.toList();
      items =  getGroupsList(items);
      state.value = GroupsStateSuccess(uiStates: items);
    }
  }

  List<GroupItemUiState> getGroupsList(List<GroupItemUiState> items) {
    var filteredItems = items.toList();
    /*search item */
    if(query != null && query!.isNotEmpty){
      var useCase = GroupsSearchUseCase();
      filteredItems = useCase.execute(items, query!);
    }

    filteredItems = GroupsCategorizedUseCase().execute(filteredItems, sortType);

    return filteredItems;
  }
}
