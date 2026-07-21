import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_students_by_parent_phone_response.dart';
import 'package:teacher_app/domain/usecases/add_student_use_case.dart';
import 'package:teacher_app/domain/usecases/get_students_by_parent_phone_use_case.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_shared/widgets/phone_text_editing_controller.dart';

import '../../base/AppResult.dart';
import '../../domain/states/add_student_result.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import 'states/add_student_state.dart';

class AddStudentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final PhoneTextEditingController parentPhoneController = PhoneTextEditingController();
  final PhoneTextEditingController phoneController = PhoneTextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);

  final RxBool fieldsEnabled = false.obs;
  final RxBool isSearchingByPhone = false.obs;
  final Rx<String?> selectedStudentId = Rx(null);
  final RxString gradeDisplayName = ''.obs;
  final RxList<StudentByParentPhoneApiModel> studentsFoundByPhone = RxList();

  Function(List<StudentByParentPhoneApiModel>)? onStudentsFound;

  String? _lastSearchedPhone;

  void onSelectedGrade(ItemSelectionUiState? item) {
    selectedGrade.value = item;
  }

  Future<void> searchByParentPhone() async {
    final currentPhone = parentPhoneController.getPhone();
    if (currentPhone.trim().isEmpty) return;

    if (currentPhone == _lastSearchedPhone && studentsFoundByPhone.isNotEmpty) {
      onStudentsFound?.call(studentsFoundByPhone);
      return;
    }

    if (selectedStudentId.value != null) {
      _clearSelectedStudent();
    }

    _lastSearchedPhone = currentPhone;
    isSearchingByPhone.value = true;
    final result = await GetStudentsByParentPhoneUseCase().execute(currentPhone);
    isSearchingByPhone.value = false;
    if (result.isSuccess) {
      final students = result.value ?? [];
      studentsFoundByPhone.assignAll(students);
      if (students.isNotEmpty) {
        onStudentsFound?.call(students);
      }
    }
  }

  void onStudentSelected(StudentByParentPhoneApiModel student) {
    selectedStudentId.value = student.studentId;
    nameController.text = student.studentName ?? '';
    gradeDisplayName.value = student.gradeName;
    selectedGrade.value = null;
    fieldsEnabled.value = false;
  }

  void onCreateNewStudent() {
    _clearSelectedStudent();
    fieldsEnabled.value = true;
    studentsFoundByPhone.clear();
  }

  void _clearSelectedStudent() {
    selectedStudentId.value = null;
    gradeDisplayName.value = '';
    nameController.clear();
    selectedGrade.value = null;
    _lastSearchedPhone = null;
    studentsFoundByPhone.clear();
  }

  Stream<AddStudentState> onSave() async* {
    var isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      yield AddStudentStateFormValidation();
      return;
    }

    AddStudentUseCase addStudentUseCase = AddStudentUseCase();
    yield AddStudentStateLoading();
    AddStudentRequest request = getRequest();

    var result = await addStudentUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveStateSuccess();
    } else {
      var data = result.data;
      if (data is AddStudentResultStudentLimitExceeded) {
        yield AddStudentStateSubscriptionIssue(data.message);
        return;
      }
      if (data is AddStudentResultInActiveSubscription) {
        yield AddStudentStateSubscriptionIssue(data.message);
        return;
      }
      yield AddStudentStateError(result.error);
    }
  }

  AddStudentRequest getRequest() {
    return AddStudentRequest(
      studentId: selectedStudentId.value,
      name: nameController.text.trim(),
      parentPhone: parentPhoneController.getPhone(),
      phone: phoneController.getPhone(),
      gradeId: selectedGrade.value?.id,
    );
  }

}