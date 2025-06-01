import 'package:get/get.dart';
import 'package:teacher_app/screens/student_add/add_student_controller.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../../base/AppResult.dart';
import '../../domain/usecases/update_student_use_case.dart';
import '../../requests/update_student_request.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import '../student_add/states/add_student_state.dart';
import 'args/edit_student_args_model.dart';
import 'states/update_student_state.dart';

class EditStudentController extends AddStudentController {

  EditStudentArgsModel? args;

  @override
  void onInit() {
    var args = Get.arguments;

    if (args is EditStudentArgsModel) {
      this.args = args;
      appLog("EditStudentController args : $args");
      nameController.text = args.studentName;
      parentPhoneController.text = args.parentPhone;
      phoneController.text = args.studentPhone;

      /*Set selected grade*/
      selectedGrade.value = ItemSelectionUiState(
        id: args.gradeId,
        name: args.gradeName,
        isSelected: true
      );
    }

    super.onInit();
  }



  @override
  Stream<AddStudentState> onSave() async* {

    var isValid = formKey.currentState?.validate() ?? false;

    if(!isValid) {
      yield AddStudentStateFormValidation();
      return;
    }

    UpdateStudentUseCase useCase = UpdateStudentUseCase();
    yield AddStudentStateLoading();

    var studentId = args?.studentId ?? "";
    if(studentId.isEmpty){
      yield UpdateStudentStateStudentNotFound();
      return;
    }

    UpdateStudentRequest request = UpdateStudentRequest(
     studentId: args?.studentId,
      name: nameController.text,
      parentPhone: parentPhoneController.text,
      phone: phoneController.text,
      gradeId: selectedGrade.value?.id ,
    );

    var result = await useCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveStateSuccess();
    } else {
      yield AddStudentStateError(result.error);
    }
  }
}
