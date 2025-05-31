import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import '../../domain/usecases/add_group_use_case.dart';
import '../../domain/usecases/get_grades_list_use_case.dart';
import '../../domain/usecases/get_my_students_list_use_case.dart';
import '../../requests/add_group_request.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import 'grades/grades_selection_state.dart';
import 'states/create_group_state.dart';
import 'students_selection/states/student_selection_item_ui_state.dart';
import 'students_selection/states/students_selection_state.dart';

class CreateGroupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  GetMyStudentsListUseCase getMyStudentsListUseCase =
      GetMyStudentsListUseCase();

  DateTime now = DateTime.now();
  late int dayOfWeek = now.weekday; // e.g., 1 (Monday), 7 (Sunday)
  late RxInt selectedDayRx = (-1).obs;
  late Rx<TimeOfDay?> selectedTimeFromRx = Rx(null);
  late Rx<TimeOfDay?> selectedTimeToRx = Rx(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeFromController = TextEditingController();
  final TextEditingController timeToController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  /*Students selection*/
  final Rx<List<StudentSelectionItemUiState>> selectedStudents = Rx([]);
  final Rx<StudentsSelectionState> studentsSelectionState =
      Rx(StudentsSelectionStateLoading());

  /*grades selection*/
  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);
  final Rx<GradesSelectionState> gradeSelectionState =
      Rx(GradesSelectionStateLoading());

  @override
  void onInit() {
    super.onInit();
    loadMyStudents();
    _loadGrades();
  }

  void onDaySelected(int index) {
    selectedDayRx.value = index;
  }

  void onTimeFromSelected(TimeOfDay value) {
    selectedTimeFromRx.value = value;
  }

  void onTimeToSelected(TimeOfDay value) {
    selectedTimeToRx.value = value;
  }

  Future<void> loadMyStudents() async {
    var result = await getMyStudentsListUseCase
        .execute(GetMyStudentsRequest(hasGroups: false));
    if (result is AppResultSuccess) {
      var students = result.value
              ?.map((e) => StudentSelectionItemUiState(
                  studentId: e.studentId ?? "",
                  studentName: e.studentName ?? "",
                  isSelected: isSelected(e)))
              .toList() ??
          List.empty();
      studentsSelectionState.value = StudentsSelectionStateSuccess(students);
    }
  }

  Future<void> _loadGrades() async {
    var result = await GetGradesListUseCase().execute();

    if (result is AppResultSuccess) {
      var uiState = result.data?.map(
        (e) => ItemSelectionUiState(
            id: e.id?.toString() ?? "",
            name: e.localizedName?.toLocalizedName() ?? "",
            isSelected: e.id?.toString() == selectedGrade.value?.id
        ),
      );
      gradeSelectionState.value = GradesSelectionStateSuccess(uiState?.toList() ?? List.empty());
      return;
    }

    if(result is AppResultError){
      gradeSelectionState.value = GradesSelectionStateError(result.error.toString());
    }
  }

  isSelected(StudentListItemApiModel e) {
    var students = getSelectedStudents();
    for (var student in students) {
      if (student.studentId == e.studentId && student.isSelected) {
        return true;
      }
    }
    return false;
  }

  List<StudentSelectionItemUiState> getSelectedStudents() {
    return selectedStudents.value;
  }

  void onSelectedStudents(List<StudentSelectionItemUiState> students) {
    selectedStudents.value = students;
  }

  onRemoveStudentClick(StudentSelectionItemUiState item) {
    var allStudents = getAllStudents();
    var studentItem = allStudents
        .firstWhereOrNull((element) => element.studentId == item.studentId);
    studentItem?.isSelected = false;
    selectedStudents.value =
        allStudents.where((element) => element.isSelected).toList();
  }

  List<StudentSelectionItemUiState> getAllStudents() {
    var students = studentsSelectionState.value;
    if (students is StudentsSelectionStateSuccess) {
      return students.students;
    }
    return List.empty();
  }

  Stream<CreateGroupState> saveGroup() async* {
    var isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      yield CreateGroupStateFormValidation();
      return;
    }

    AddGroupUseCase addGroupUseCase = AddGroupUseCase();
    yield CreateGroupStateLoading();
    AddGroupRequest request = getRequest();

    var result = await addGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveGroupStateSuccess();
    } else {
      yield CreateGroupStateError(result.error);
    }
  }

  getTimeFormat(TimeOfDay? time) {
    if (time == null) return "";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  AddGroupRequest getRequest() {
    return AddGroupRequest(
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudents.value.map((e) => e.studentId).toList(),
      gradeId: selectedGrade.value?.id
    );
  }

  void onSelectedGrade(ItemSelectionUiState? item) {
    var grades = getGradesList();

    for (var grade in grades) {
      grade.isSelected = grade.id == (item?.id ?? "") ;
    }

    selectedGrade.value = item;
  }

  List<ItemSelectionUiState> getGradesList() {
    var grades = gradeSelectionState.value;
    if (grades is GradesSelectionStateSuccess) {
      return grades.items;
    }
    return List.empty();
  }
}
