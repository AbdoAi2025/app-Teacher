import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/domain/usecases/get_my_students_list_use_case.dart';
import 'package:teacher_app/screens/students_list/states/students_state.dart';
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
      var isLoadingMore = false;
      var isNextPage = uiStates.isNotEmpty;
      var totalRecords = isNextPage ? uiStates.length * 2 : uiStates.length;
      _updateState(StudentsStateSuccess(
        uiStates: uiStates,
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

  void refreshStudnets() {
    _updateState(StudentsStateLoading());
    _loadStudents();
  }

  void _updateState(StudentsState state) {
    this.state.value = state;
  }

  void _initOnStudentEvents() {
    StudentsEvents.studentsEvents.listen((event) {
      if (event == null) return;
      refreshStudnets();
    });
  }

  Stream<AppResult<dynamic>> deleteStudent(StudentItemUiState uiState) async* {
    var useCase = DeleteStudentUseCase();
    yield await useCase.execute(uiState.id);
  }

  Future<void> getMoreStudents() async {

    request.pageIndex++;

    var state = this.state.value;

    if(state is StudentsStateSuccess){
      _updateState(state.copyWith(isLoadingMore: true));

      var studentsResult = await getMyStudentsListUseCase.execute(request);

      if (studentsResult.isSuccess) {
        var allUiStates = state.uiStates;
        var uiStates = _getStudentsUiStates(studentsResult.data);
        allUiStates.addAll(uiStates);

        var isLoadingMore = false;
        var isNextPage = uiStates.isNotEmpty;
        var totalRecords = isNextPage ? allUiStates.length * 2 : allUiStates.length;

        _updateState(StudentsStateSuccess(
          uiStates: allUiStates,
          isLoadingMore: isLoadingMore,
          totalRecords: totalRecords,
          isNextPage: isNextPage,
        ));
        return;
      }
    }
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
}
