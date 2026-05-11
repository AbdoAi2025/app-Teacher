import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/models/group_timing_model.dart';
import 'package:teacher_app/domain/usecases/update_group_timings_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import '../../data/responses/add_group_response.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/usecases/add_group_use_case.dart';
import '../../domain/usecases/get_grades_list_use_case.dart';
import '../../domain/usecases/get_my_students_list_use_case.dart';
import '../../domain/usecases/set_group_students_use_case.dart';
import '../../domain/usecases/update_group_use_case.dart';
import '../../requests/add_group_request.dart';
import '../../requests/set_group_students_request.dart';
import '../../requests/update_group_request.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import 'grades/grades_selection_state.dart';
import 'states/create_group_state.dart';
import 'students_selection/states/student_selection_item_ui_state.dart';
import 'students_selection/states/students_selection_state.dart';

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
  final Rx<GradesSelectionState> gradeSelectionState =
      Rx(GradesSelectionStateLoading());

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
  GetMyStudentsListUseCase getMyStudentsListUseCase = GetMyStudentsListUseCase();

  @override
  void onInit() {
    super.onInit();
    _loadGrades();
    loadMyStudents();
  }

  // ----------------------------------------------------------------
  // Step 1: Create Group
  // ----------------------------------------------------------------
  Future<bool> submitGroupInfo() async {
    final isValid = formKey.currentState?.validate() ??
        (nameController.text.trim().isNotEmpty && selectedGrade.value != null);
    if (!isValid) return false;

    final currentName = nameController.text.trim();
    final currentGradeId = selectedGrade.value?.id;


    if (createdGroupId != null) {
      final dataChanged = currentName != submittedName || currentGradeId != submittedGradeId;
      if (!dataChanged) {
        currentStep.value = 1;
        return true;
      }
      isStepLoading.value = true;
      stepError.value = '';

      final result = await UpdateGroupUseCase().execute(UpdateGroupRequest(
        groupId: createdGroupId!,
        name: currentName,
        gradeId: currentGradeId,
      ));

      isStepLoading.value = false;

      if (result is AppResultSuccess) {
        submittedName = currentName;
        submittedGradeId = currentGradeId;
        currentStep.value = 1;
        GroupsManagers.onGroupUpdated(createdGroupId);
        return true;
      } else {
        stepError.value = result.error?.toString() ?? 'Something went wrong'.tr;
        return false;
      }
    }

    isStepLoading.value = true;
    stepError.value = '';


    final result = await saveGroupInfo(currentName, currentGradeId);

    isStepLoading.value = false;

    if (result is AppResultSuccess) {
      createdGroupId = result.value?.id;
      submittedName = currentName;
      submittedGradeId = currentGradeId;
      currentStep.value = 1;
      loadMyStudents();
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

    final selected = selectedStudentsRx.value;
    final currentIds = selected.map((e) => e.studentId).toList()..sort();
    final submittedIds = [..._submittedStudentIds]..sort();
    final dataChanged = currentIds.join(',') != submittedIds.join(',');

    if (!dataChanged) {
      currentStep.value = 2;
      return true;
    }

    isStepLoading.value = true;
    stepError.value = '';

    final result = await _setGroupStudentsUseCase.execute(
      SetGroupStudentsRequest(
        groupId: groupId,
        studentIds: currentIds,
      ),
    );
    await loadMyStudents();
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
    final step1Ok = await submitGroupInfo();
    if (!step1Ok) return false;

    final step2Ok = await submitStudents();
    if (!step2Ok) return false;

    return submitTimings();
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

  Future<void> loadMyStudents() async {
    final gradeId = selectedGrade.value?.id ?? '';
    if (gradeId.isEmpty) {
      studentsSelectionState.value = StudentsSelectionStateSelectGrade();
      return;
    }
    studentsSelectionState.value = StudentsSelectionStateLoading();
    final result = await getMyStudentsListUseCase
        .execute(GetMyStudentsRequest(hasGroups: false, gradeId: gradeId));
    if (result is AppResultSuccess) {
      var students = result.value
              ?.map((e) => StudentSelectionItemUiState(
                    studentId: e.studentId ?? '',
                    studentName: e.studentName ?? '',
                    groupName: e.groupName ?? '',
                    gradeId: e.gradeId ?? 0,
                    isSelected: isSelected(e),
                  ))
              .toList() ??
          [];
      students.sort((a, b) => a.studentName.compareTo(b.studentName));
      studentsSelectionState.value = StudentsSelectionStateSuccess(students);
    }
  }

  Future<void> _loadGrades() async {
    final result = await GetGradesListUseCase().execute();
    if (result is AppResultSuccess) {
      final items = result.data
          ?.map((e) => ItemSelectionUiState(
                id: e.id?.toString() ?? '',
                name: e.localizedName?.toLocalizedName() ?? '',
                isSelected: e.id?.toString() == selectedGrade.value?.id,
              ))
          .toList();
      gradeSelectionState.value =
          GradesSelectionStateSuccess(items ?? []);
    } else if (result is AppResultError) {
      gradeSelectionState.value =
          GradesSelectionStateError(result.error.toString());
    }
  }

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
    for (final g in getGradesList()) {
      g.isSelected = g.id == (item?.id ?? '');
    }
    selectedGrade.value = item;
    loadMyStudents();
    selectedStudentsRx.value = selectedStudents
        .where((e) => e.gradeId.toString() == item?.id)
        .toList();
  }

  List<ItemSelectionUiState> getGradesList() {
    final state = gradeSelectionState.value;
    if (state is GradesSelectionStateSuccess) return state.items;
    return [];
  }

  void onSelectStudentClick() {
    final state = studentsSelectionState.value;
    if (state is StudentsSelectionStateSuccess && state.students.isNotEmpty) {
      return;
    }
    loadMyStudents();
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

  // Legacy single-step stream (used by EditGroupController)
  Stream<CreateGroupState> saveGroup() async* {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      yield CreateGroupStateFormValidation();
      return;
    }
    yield CreateGroupStateLoading();
    final result = await _addGroupUseCase.execute(getRequest());
    if (result is AppResultSuccess) {
      yield SaveGroupStateSuccess();
    } else {
      yield CreateGroupStateError(result.error);
    }
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
}