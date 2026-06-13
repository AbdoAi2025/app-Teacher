import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/add_student_use_case.dart';
import 'package:teacher_app/requests/add_student_request.dart';

import '../../base/AppResult.dart';
import '../../domain/states/add_student_result.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import 'states/add_student_state.dart';

class AddStudentController extends GetxController{

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);

  void onSelectedGrade(ItemSelectionUiState? item) {
    selectedGrade.value = item;
  }

  Stream<AddStudentState> onSave() async* {
    var isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      yield AddStudentStateFormValidation();
      return;
    }

    AddStudentUseCase addGroupUseCase = AddStudentUseCase();
    yield AddStudentStateLoading();
    AddStudentRequest request = getRequest();

    var result = await addGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveStateSuccess();
    } else {

      var data = result.data;
      if(data is AddStudentResultStudentLimitExceeded){
        yield AddStudentStateStudentLimitExceeded(data.message);
        return;
      }

      yield AddStudentStateError(result.error);
    }
  }

  AddStudentRequest getRequest() {
    return AddStudentRequest(
      name: nameController.text.trim(),
      parentPhone: parentPhoneController.text.trim(),
      phone: phoneController.text.trim(),
      gradeId: selectedGrade.value?.id,
    );
  }

}
