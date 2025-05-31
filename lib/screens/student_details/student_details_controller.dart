import 'package:get/get.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/localized_name_model.dart';
import '../../domain/usecases/get_student_details_use_case.dart';
import 'states/student_details_state.dart';

class StudentDetailsController extends GetxController {
  Rx<StudentDetailsState> state = Rx(StudentDetailsStateLoading());
  StudentDetailsArgModel? studentDetailsArgsModel;

  @override
  void onInit() {
    super.onInit();

    var arg = Get.arguments;

    if (arg is StudentDetailsArgModel) {
      studentDetailsArgsModel = arg;
    }

    _loadStudentDetails();
  }

  void updateState(StudentDetailsState state) {
    this.state.value = state;
  }

  Future<void> _loadStudentDetails() async {
    var id = studentDetailsArgsModel?.id ?? "";
    if (id.isEmpty) {
      updateState(StudentDetailsStateInvalidArgs());
      return;
    }
    GetStudentDetailsUseCase useCase = GetStudentDetailsUseCase();
    var result = await useCase.execute(id);
    var data = result.data;
    if (result.isSuccess && data != null) {
      var uiState = StudentDetailsUiState(
        studentId: data.studentId ?? "",
        studentName: data.studentName ?? "",
        parentPhone: data.studentParentPhone ?? "",
        phone: data.studentPhone ?? "",
        groupId: data.groupId ?? "",
        groupName: data.groupName ?? "",
        gradeName: LocalizedNameModel(
                nameEn: data.gradeNameEn ?? "",
            nameAr: data.gradeNameAr ?? ""
        ).toLocalizedName(),
      );
      updateState(StudentDetailsStateSuccess(uiState: uiState));
    } else {
      updateState(StudentDetailsStateError(exception: result.error!));
    }
  }

  StudentDetailsUiState? getStudentDetailsUiState() {
    var state = this.state.value;
    if (state is StudentDetailsStateSuccess) {
      return state.uiState;
    }
    return null;
  }

  void reload() {
    updateState(StudentDetailsStateLoading());
    _loadStudentDetails();
  }
}
