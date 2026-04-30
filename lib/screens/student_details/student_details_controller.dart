import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_group_details_use_case.dart';
import 'package:teacher_app/domain/usecases/get_groups_list_use_case.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/localized_name_model.dart';
import '../../base/AppResult.dart';
import '../../domain/events/students_events.dart';
import '../../domain/usecases/add_student_to_group_use_case.dart';
import '../../domain/usecases/remove_student_from_group_use_case.dart';
import '../../domain/usecases/delete_student_use_case.dart';
import '../../domain/usecases/update_student_grade_use_case.dart';
import '../../domain/usecases/get_student_details_use_case.dart';
import '../../domain/usecases/update_student_use_case.dart';
import '../../requests/remove_student_from_group_request.dart';
import '../../requests/update_student_request.dart';
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
        groupDay: data.groupDay ?? 0,
        groupTimeFrom: data.groupTimeFrom ?? "",
        groupTimeTo: data.groupTimeTo ?? "",
        gradeId: data.gradeId ?? 0,
        groups: data.groups ?? [],
        grades: data.grades ?? [],
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

  void onRefresh() {
    reload();
  }

  Stream<AppResult<dynamic>> deleteStudent()  async*{
    var useCase = DeleteStudentUseCase();
    var studentDetailsUiState = getStudentDetailsUiState();
    var studentId = studentDetailsUiState?.studentId ?? "";
    var gradeId = studentDetailsUiState?.gradeId ?? "";
    yield await useCase.execute(studentId  , gradeId.toString());
  }

  Stream<AppResult<dynamic>> updateStudentGrade(String id, String gradeId) async* {
    var studentId = getStudentDetailsUiState()?.studentId ?? "";
    yield await UpdateStudentGradeUseCase().execute(id, gradeId, studentId);
  }

  Stream<AppResult<dynamic>> addStudentToGroup(String groupId) async* {
    var studentId = getStudentDetailsUiState()?.studentId ?? "";
    var request = RemoveStudentFromGroupRequest(groupId: groupId, studentIds: [studentId]);
    yield await AddStudentToGroupUseCase().execute(request);
  }

  Stream<AppResult<dynamic>> removeStudentFromGroup(String groupId) async* {
    var studentId = getStudentDetailsUiState()?.studentId ?? "";
    var request = RemoveStudentFromGroupRequest(groupId: groupId, studentIds: [studentId]);
    yield await RemoveStudentFromGroupUseCase().execute(request);
  }
}
