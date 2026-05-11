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

  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  int _page = 0;
  String _searchQuery = '';

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

  void onSearchChanged(String query) {
    _searchQuery = query;
    loadStudents();
  }

  Future<void> loadStudents() async {
    _page = 0;
    hasMore.value = true;
    isLoadingMore.value = false;
    studentsState.value = StudentsSelectionStateLoading();
    await _fetchPage();
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    _page++;
    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    final result = await _studentsUseCase.execute(GetMyStudentsRequest(
      gradeId: selectedGradeFilter.value?.id,
      hasGroups: filterNotInGroup.value ? false : null,
      search: _searchQuery.isEmpty ? null : _searchQuery,
      pageIndex: _page,
    ));

    if (result is AppResultSuccess) {
      final raw = result.value ?? [];
      final newItems = raw
          .map((e) => StudentSelectionItemUiState(
                studentId: e.studentId ?? '',
                studentName: e.studentName ?? '',
                groupName: e.groups.isNotEmpty ? e.groups.first.groupName ?? '' : '',
                gradeId: e.grades.isNotEmpty ? e.grades.first.gradeId ?? 0 : 0,
                isSelected: _isSelected(e.studentId ?? ''),
              ))
          .toList();

      final existing = _page == 0
          ? <StudentSelectionItemUiState>[]
          : (studentsState.value is StudentsSelectionStateSuccess
              ? List<StudentSelectionItemUiState>.from(
                  (studentsState.value as StudentsSelectionStateSuccess).students)
              : <StudentSelectionItemUiState>[]);

      hasMore.value = raw.length >= GetMyStudentsRequest().pageSize;
      studentsState.value =
          StudentsSelectionStateSuccess([...existing, ...newItems]);
    } else {
      if (_page == 0) {
        studentsState.value = StudentsSelectionStateError(
            result.error?.toString() ?? 'Something went wrong');
      }
    }
    isLoadingMore.value = false;
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