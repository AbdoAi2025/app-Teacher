import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/domain/usecases/get_my_students_list_use_case.dart';
import 'package:teacher_app/screens/students_list/states/students_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/localized_name_model.dart';

import '../../base/AppResult.dart';
import '../../domain/events/students_events.dart';
import '../../domain/usecases/delete_student_use_case.dart';
import '../../requests/get_my_students_request.dart';
import 'states/student_item_ui_state.dart';

class StudentsController extends GetxController {

  GetMyStudentsRequest request = GetMyStudentsRequest();

  GetMyStudentsListUseCase getMyStudentsListUseCase =
      GetMyStudentsListUseCase();

  Rx<StudentsState> state = Rx(StudentsStateLoading());

  List<StudentItemUiState> studentsUiStates = [];
  List<StudentItemUiState> searchStudentsUiStates = [];

  static const  sortByGroupType = 0;
  static const  sortByGradeType = 1;
  int? sortType ;

  @override
  void onInit() {
    super.onInit();
    _loadStudents();
    _initOnStudentEvents();
  }

  Future<void> _loadStudents() async {

    request.pageIndex = 0;

    var studentsResult = await getMyStudentsListUseCase.execute(request);

    if (studentsResult.isSuccess) {
      var uiStates = _getStudentsUiStates(studentsResult.data);
      studentsUiStates = uiStates;
      var isLoadingMore = false;
      var isNextPage = false;//uiStates.isNotEmpty;
      var totalRecords = isNextPage ? uiStates.length * 2 : uiStates.length;

      _updateState(StudentsStateSuccess(
        uiStates: _getItemsFiltered(),
        isLoadingMore: isLoadingMore,
        totalRecords: totalRecords,
        isNextPage: isNextPage,
      ));
      return;
    }

    if (studentsResult.isError) {
      state.value = StudentsStateError(studentsResult.error);
    }
  }

  void refreshStudents() {
    _updateState(StudentsStateLoading());
    _loadStudents();
  }

  void _updateState(StudentsState state) {
    this.state.value = state;
  }

  void _initOnStudentEvents() {
    StudentsEvents.studentsEvents.listen((event) {
      if (event == null) return;
      refreshStudents();
    });
  }

  Stream<AppResult<dynamic>> deleteStudent(StudentItemUiState uiState) async* {
    var useCase = DeleteStudentUseCase();
    yield await useCase.execute(uiState.id);
  }

  Future<void> getMoreStudents() async {

    // request.pageIndex++;
    //
    // var state = this.state.value;
    //
    // if(state is StudentsStateSuccess){
    //
    //   _updateState(state.copyWith(isLoadingMore: true));
    //
    //   var studentsResult = await getMyStudentsListUseCase.execute(request);
    //
    //   if (studentsResult.isSuccess) {
    //     var allUiStates = studentsUiStates;
    //     var uiStates = _getStudentsUiStates(studentsResult.data);
    //     allUiStates.addAll(uiStates);
    //
    //     if(request.search != null && request.search!.isNotEmpty){
    //       searchStudentsUiStates = allUiStates;
    //     }else {
    //       studentsUiStates = allUiStates;
    //     }
    //
    //     var isLoadingMore = false;
    //     var isNextPage = uiStates.isNotEmpty;
    //     var totalRecords = isNextPage ? allUiStates.length * 2 : allUiStates.length;
    //
    //     _updateState(StudentsStateSuccess(
    //       uiStates: allUiStates,
    //       isLoadingMore: isLoadingMore,
    //       totalRecords: totalRecords,
    //       isNextPage: isNextPage,
    //     ));
    //     return;
    //   }
    // }
  }

  List<StudentItemUiState> _getStudentsUiStates(List<StudentListItemApiModel>? data) {
    return data
            ?.map((e) => StudentItemUiState(
                  id: e.studentId ?? "",
                  name: e.studentName ?? "",
                  grade: LocalizedNameModel(
                          nameEn: e.gradeNameEn ?? "",
                          nameAr: e.gradeNameAr ?? "")
                      .toLocalizedName(),
                  groupName: e.groupName ?? "",
                  parentPhone: e.studentParentPhone ?? "",
                ))
            .toList() ??
        List.empty();
  }

  onSearchChanged(String? query) {
    appLog("onSearchChanged query: $query");
    appLog("onSearchChanged studentsUiStates:${studentsUiStates.length}");
    request.search = query;
    updateList();
  }

  void onCloseSearch() {
    onSearchChanged(null);
  }

  List<StudentItemUiState> filterStudentBySearch(List<StudentItemUiState> studentsUiStates, String? search) {
    if (search == null || search.isEmpty) {
      return studentsUiStates;
    }
    return studentsUiStates.where((element) =>
       element.name.toLowerCase().contains(search.toLowerCase()) ||
       element.grade.toLowerCase().contains(search.toLowerCase()) ||
       element.groupName.toLowerCase().contains(search.toLowerCase()) ||
       element.parentPhone.toLowerCase().contains(search.toLowerCase())
    ).toList();
  }

  List<StudentItemUiState> _applySort(List<StudentItemUiState> studentsUiStates) {
    if(sortType == sortByGroupType){
      return groupByGroup(studentsUiStates);
    }else if(sortType == sortByGradeType){
      return groupByGrade(studentsUiStates);
    }
    return studentsUiStates;
  }
  
  void sortByGroup() {
    _sort(sortByGroupType);
  }
  
  void sortByGrade() {
    _sort(sortByGradeType);
  }
  void resetSort() {
    _sort(null);
  }

  void _sort(int? type) {
    sortType = type;
    updateList();
  }

  List<StudentItemUiState> groupByGroup(List<StudentItemUiState> uiStates) {

    final Map<String, List<StudentItemUiState>> grouped = {};

    /*sort items by group name*/
    uiStates.sort((a, b) => a.groupName.compareTo(b.groupName));


    /*Group by group name*/
    for (final uiState in uiStates) {
      var groupName = uiState.groupName;
      grouped.putIfAbsent(groupName, () => []);
      grouped[groupName]!.add(uiState);
    }

    // Optional: sort inside each  by name
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) =>  a.name.compareTo(b.name));
    }

    List<StudentItemUiState> sortedGroups = [];

    grouped.forEach((key, value) {
      sortedGroups.add(StudentItemTitleUiState(title: key));
      sortedGroups.addAll(value);
    });
    return sortedGroups;
  }

  static List<StudentItemUiState> groupByGrade(List<StudentItemUiState> uiStates) {

    final Map<String, List<StudentItemUiState>> grouped = {};

    /*sort items by grade name*/
    uiStates.sort((a, b) => a.grade.compareTo(b.grade));

    /*Group by group name*/
    for (final uiState in uiStates) {
      var gradeName = uiState.grade;
      grouped.putIfAbsent(gradeName, () => []);
      grouped[gradeName]!.add(uiState);
    }

    // Optional: sort inside each  by name
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) =>  a.name.compareTo(b.name));
    }

    List<StudentItemUiState> sortedGroups = [];

    grouped.forEach((key, value) {
      sortedGroups.add(StudentItemTitleUiState(title: key));
      sortedGroups.addAll(value);
    });
    return sortedGroups;
  }

  /*apply sort if needed , and search if needed*/
  List<StudentItemUiState> _getItemsFiltered() {
    var items  = filterStudentBySearch(studentsUiStates.toList(), request.search);
    items = _applySort(items);
    return items;
  }

  void updateList() {
    var stateValue = state.value;
    if(stateValue is StudentsStateSuccess){
      _updateState(stateValue.copyWith(uiStates: _getItemsFiltered()));
    }
  }
}
