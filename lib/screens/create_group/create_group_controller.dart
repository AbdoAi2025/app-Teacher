import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/events/students_events.dart';
import 'package:teacher_app/domain/models/group_timing_model.dart';
import 'package:teacher_app/domain/usecases/update_group_timings_use_case.dart';
import '../../data/responses/add_group_response.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/usecases/add_group_use_case.dart';
import '../../domain/usecases/set_group_students_use_case.dart';
import '../../domain/usecases/update_group_use_case.dart';
import '../../requests/add_group_request.dart';
import '../../requests/set_group_students_request.dart';
import '../../requests/update_group_request.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import 'states/create_group_state.dart';
import 'students_selection/states/student_selection_item_ui_state.dart';
import 'students_selection/states/students_selection_state.dart';
import 'students_selection/students_selection_controller.dart';

class CreateGroupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // --- Core fields (kept for EditGroupController compatibility) ---
  final nameController = TextEditingController();
  final timeFromController = TextEditingController();
  final timeToController = TextEditingController();
  final gradeController = TextEditingController();

  late RxInt selectedDayRx = (-1).obs;
  late Rx<TimeOfDay?> selectedTimeFromRx = Rx(null);
  late Rx<TimeOfDay?> selectedTimeToRx = Rx(null);

  List<StudentSelectionItemUiState> selectedStudents = [];
  final Rx<List<StudentSelectionItemUiState>> selectedStudentsRx = Rx([]);
  final Rx<StudentsSelectionState> studentsSelectionState =
      Rx(StudentsSelectionStateLoading());

  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);

  // --- Students selection controller ---
  final StudentsSelectionController studentsSelectionController =
      StudentsSelectionController();

  // --- Multi-step state ---
  final RxInt currentStep = 0.obs;
  String? createdGroupId;
  String? submittedName;
  String? submittedGradeId;
  List<String> _submittedStudentIds = [];
  String _submittedTimingsKey = '';
  final RxBool isStepLoading = false.obs;
  final RxString stepError = ''.obs;
  final RxList<GroupTimingModel> timings = <GroupTimingModel>[].obs;

  final _addGroupUseCase = AddGroupUseCase();
  final _setGroupStudentsUseCase = SetGroupStudentsUseCase();
  final _updateGroupTimingsUseCase = UpdateGroupTimingsUseCase();

  // ----------------------------------------------------------------
  // Step 1: Create Group
  // ----------------------------------------------------------------
  Future<bool> onSubmitGroupInfo() async {
    final isValid = formKey.currentState?.validate() ??
        (nameController.text.trim().isNotEmpty && selectedGrade.value != null);
    if (!isValid) return false;

    final currentName = nameController.text.trim();
    final currentGradeId = selectedGrade.value?.id;
    isStepLoading.value = true;
    stepError.value = '';
    final result = await saveGroupInfo(currentName, currentGradeId);
    isStepLoading.value = false;

    if (result is AppResultSuccess) {
      createdGroupId = result.value?.id;
      submittedName = currentName;
      submittedGradeId = currentGradeId;
      currentStep.value = 1;
      return true;
    } else {
      stepError.value = result.error?.toString() ?? 'Something went wrong'.tr;
      return false;
    }
  }

  // ----------------------------------------------------------------
  // Step 2: Add Students
  // ----------------------------------------------------------------
  Future<bool> submitStudents() async {
    final groupId = createdGroupId;
    if (groupId == null) return false;

    final currentIds = studentsSelectionController.selectedStudentIds..sort();
    final submittedIds = [..._submittedStudentIds]..sort();
    final dataChanged = currentIds.join(',') != submittedIds.join(',');

    if (!dataChanged) {
      currentStep.value = 2;
      return true;
    }

    isStepLoading.value = true;
    stepError.value = '';

    final result = await saveGroupStudents(groupId, currentIds);
    isStepLoading.value = false;
    if (result.isError) {
      stepError.value = result.error?.toString() ?? 'Something went wrong'.tr;
      return false;
    }

    _submittedStudentIds = currentIds;
    currentStep.value = 2;
    return true;
  }

  // ----------------------------------------------------------------
  // All steps: validate + submit sequentially
  // ----------------------------------------------------------------
  bool validateGroupInfo() => formKey.currentState?.validate() ?? false;

  Future<bool> submitAll() async {
    final step1Ok = await onSubmitGroupInfo();
    if (!step1Ok) return false;

    final step2Ok = await submitStudents();
    if (!step2Ok) return false;

    final step3Ok = await submitTimings();
    GroupsManagers.onGroupUpdated(createdGroupId);
    final currentIds = studentsSelectionController.selectedStudentIds..sort();
    for (var id in currentIds) {
      StudentsEvents.onStudentUpdated(id);
    }

    StudentsEvents.onStudentAdded();
    GroupsManagers.onRefresh();
    return step3Ok;

  }

  // ----------------------------------------------------------------
  // Step 3: Add Timings
  // ----------------------------------------------------------------
  Future<bool> submitTimings() async {
    final groupId = createdGroupId;
    if (groupId == null) return false;

    final incomplete = timings.where((t) => !t.isComplete).toList();
    if (incomplete.isNotEmpty) {
      stepError.value = 'Please complete all timing entries'.tr;
      return false;
    }

    final currentKey = _buildTimingsKey(timings);
    if (timings.isNotEmpty && currentKey == _submittedTimingsKey) return true;

    isStepLoading.value = true;
    stepError.value = '';

    final result = await _updateGroupTimingsUseCase.execute(groupId, timings);

    isStepLoading.value = false;

    if (result.isSuccess) {
      _submittedTimingsKey = currentKey;
      return true;
    } else {
      stepError.value = result.error?.toString() ?? 'Something went wrong'.tr;
      return false;
    }
  }

  String _buildTimingsKey(List<GroupTimingModel> t) => t
      .map((e) => '${e.day}-${getTimeFormat(e.timeFrom)}-${getTimeFormat(e.timeTo)}')
      .join('|');

  void addTiming() {
    timings.add(GroupTimingModel());
  }

  void removeTiming(int index) {
    timings.removeAt(index);
  }

  void updateTimingDay(int index, int day) {
    timings[index].day = day;
    timings.refresh();
  }

  void updateTimingTimeFrom(int index, TimeOfDay time) {
    timings[index].timeFrom = time;
    timings.refresh();
  }

  void updateTimingTimeTo(int index, TimeOfDay time) {
    timings[index].timeTo = time;
    timings.refresh();
  }

  // ----------------------------------------------------------------
  // Grades & Students (kept for EditGroupController compatibility)
  // ----------------------------------------------------------------
  void onDaySelected(int index) => selectedDayRx.value = index;
  void onTimeFromSelected(TimeOfDay value) => selectedTimeFromRx.value = value;
  void onTimeToSelected(TimeOfDay value) => selectedTimeToRx.value = value;

  bool isSelected(StudentListItemApiModel e) {
    for (final s in getSelectedStudents()) {
      if (s.studentId == e.studentId && s.isSelected) return true;
    }
    return false;
  }

  List<StudentSelectionItemUiState> getSelectedStudents() =>
      selectedStudentsRx.value;

  void onSelectedStudents(List<StudentSelectionItemUiState> students) {
    selectedStudents = students;
    selectedStudentsRx.value = students;
  }

  void onRemoveStudentClick(StudentSelectionItemUiState item) {
    final all = getAllStudents();
    final found =
        all.firstWhereOrNull((e) => e.studentId == item.studentId);
    found?.isSelected = false;
    selectedStudentsRx.value =
        all.where((e) => e.isSelected).toList();
  }

  List<StudentSelectionItemUiState> getAllStudents() {
    final state = studentsSelectionState.value;
    if (state is StudentsSelectionStateSuccess) return state.students;
    return selectedStudentsRx.value;
  }

  void onSelectedGrade(ItemSelectionUiState? item) {
    if (item?.id == selectedGrade.value?.id) return;
    selectedGrade.value = item;
    selectedStudentsRx.value = selectedStudents
        .where((e) => e.gradeId.toString() == item?.id)
        .toList();
    studentsSelectionController.setGradeId(item?.id ?? '', name: item?.name ?? '');
  }

String getTimeFormat(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  AddGroupRequest getRequest() {
    return AddGroupRequest(
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudentsRx.value.map((e) => e.studentId).toList(),
      gradeId: selectedGrade.value?.id,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    timeFromController.dispose();
    timeToController.dispose();
    gradeController.dispose();
    super.onClose();
  }

  Future<AppResult<AddGroupResponse?>> saveGroupInfo(String currentName, String? currentGradeId) {
    return _addGroupUseCase.execute(
      AddGroupRequest(
        name: currentName,
        gradeId: currentGradeId,
      ),
    );
  }

  Future<AppResult<dynamic>> saveGroupStudents(String groupId, List<String> currentIds) {
    return _setGroupStudentsUseCase.execute(
      SetGroupStudentsRequest(
        groupId: groupId,
        studentIds: currentIds,
      ),
    );
  }
}