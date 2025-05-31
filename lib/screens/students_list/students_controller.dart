import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_my_students_list_use_case.dart';
import 'package:teacher_app/screens/students_list/states/students_state.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/localized_name_model.dart';

import '../../requests/get_my_students_request.dart';
import 'states/student_item_ui_state.dart';

class StudentsController extends GetxController {
  GetMyStudentsListUseCase getMyStudentsListUseCase =
      GetMyStudentsListUseCase();

  Rx<StudentsState> state = Rx(StudentsStateLoading());

  @override
  void onInit() {
    super.onInit();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    var studentsResult =
        await getMyStudentsListUseCase.execute(GetMyStudentsRequest());
    if (studentsResult.isSuccess) {
      var uiStates = studentsResult.data
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
      _updateState(StudentsStateSuccess(uiStates));
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
}
