import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/usecases/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';
import 'states/student_selection_item_ui_state.dart';
import 'states/students_selection_state.dart';

class StudentsSelectionController extends GetxController {
  final RxBool filterNotInGroup = true.obs;
  final Rx<StudentsSelectionState> studentsState =
      Rx<StudentsSelectionState>(StudentsSelectionStateSelectGrade());
  final RxList<StudentSelectionItemUiState> selectedStudents =
      <StudentSelectionItemUiState>[].obs;

  final Rx<ItemSelectionUiState?> selectedGradeFilter = Rx(null);

  final _studentsUseCase = GetMyStudentsListUseCase();

  void setGradeId(String gradeId, {String name = ''}) {
    if (selectedGradeFilter.value?.id == gradeId) return;
    selectedGradeFilter.value = gradeId.isEmpty
        ? null
        : ItemSelectionUiState(id: gradeId, name: name, isSelected: true);
    if (gradeId.isEmpty) {
      studentsState.value = StudentsSelectionStateSelectGrade();
    } else {
      loadStudents();
    }
  }

  void onGradeFilterSelected(ItemSelectionUiState? grade) {
    selectedGradeFilter.value = grade;
    loadStudents();
  }

  void toggleFilter() {
    filterNotInGroup.value = !filterNotInGroup.value;
    loadStudents();
  }

  Future<void> loadStudents() async {
    final gradeId = selectedGradeFilter.value?.id;
    studentsState.value = StudentsSelectionStateLoading();
    final result = await _studentsUseCase.execute(GetMyStudentsRequest(
      gradeId: gradeId,
      hasGroups: filterNotInGroup.value ? false : null,
    ));
    if (result is AppResultSuccess) {
      final items = (result.value ?? [])
          .map((e) => StudentSelectionItemUiState(
                studentId: e.studentId ?? '',
                studentName: e.studentName ?? '',
                groupName: e.groupName ?? '',
                gradeId: e.gradeId ?? 0,
                isSelected: _isSelected(e.studentId ?? ''),
              ))
          .toList();
      items.sort((a, b) => a.studentName.compareTo(b.studentName));
      studentsState.value = StudentsSelectionStateSuccess(items);
    } else {
      studentsState.value = StudentsSelectionStateError(
          result.error?.toString() ?? 'Something went wrong');
    }
  }

  bool _isSelected(String studentId) =>
      selectedStudents.any((s) => s.studentId == studentId);

  void onSaveSelection(List<StudentSelectionItemUiState> saved) {
    selectedStudents.value = saved;
  }

  void removeStudent(StudentSelectionItemUiState item) {
    selectedStudents.value =
        selectedStudents.where((e) => e.studentId != item.studentId).toList();
    final state = studentsState.value;
    if (state is StudentsSelectionStateSuccess) {
      state.students
          .firstWhereOrNull((e) => e.studentId == item.studentId)
          ?.isSelected = false;
      studentsState.refresh();
    }
  }

  void setInitialStudents(List<StudentSelectionItemUiState> students) {
    selectedStudents.value = students;
  }

  List<String> get selectedStudentIds =>
      selectedStudents.map((s) => s.studentId).toList();
}