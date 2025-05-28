import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import '../../domain/usecases/add_group_use_case.dart';
import '../../domain/usecases/get_my_students_list_use_case.dart';
import '../../requests/add_group_request.dart';
import 'states/create_group_state.dart';
import 'students_selection/states/student_selection_item_ui_state.dart';
import 'students_selection/states/students_selection_state.dart';

class CreateGroupController extends GetxController {

  final formKey = GlobalKey<FormState>();

  GetMyStudentsListUseCase getMyStudentsListUseCase = GetMyStudentsListUseCase();

  DateTime now = DateTime.now();
  late int dayOfWeek = now.weekday; // e.g., 1 (Monday), 7 (Sunday)
  late RxInt selectedDayRx = (-1).obs;
  late Rx<TimeOfDay?> selectedTimeFromRx = Rx(null);
  late Rx<TimeOfDay?> selectedTimeToRx = Rx(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeFromController = TextEditingController();
  final TextEditingController timeToController = TextEditingController();

  final Rx<List<StudentSelectionItemUiState>> selectedStudents = Rx([]);
  final Rx<StudentsSelectionState> studentsSelectionState =
      Rx(StudentsSelectionStateLoading());

  @override
  void onInit() {
    super.onInit();
    _loadMyStudents();
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

  Future<void> _loadMyStudents() async {
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

  Stream<CreateGroupState> createGroup() async* {

    var isValid = formKey.currentState?.validate() ?? false;

    if(!isValid) {
      yield CreateGroupStateFormValidation();
      return;
    }

    AddGroupUseCase addGroupUseCase = AddGroupUseCase();
    yield CreateGroupStateLoading();
    AddGroupRequest request = AddGroupRequest(
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudents.value.map((e) => e.studentId).toList(),
    );

    var result = await addGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield CreateGroupStateSuccess();
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
}
