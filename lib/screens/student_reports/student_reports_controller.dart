import 'package:get/get.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/day_utils.dart';
import '../../domain/events/sessions_events.dart';
import '../../domain/usecases/get_student_activities_use_case.dart';
import 'args/student_reports_args_model.dart';
import 'states/student_reports_state.dart';

class StudentReportsController extends GetxController {
  GetStudentActivitiesUseCase getStudentActivitiesUseCase =
      GetStudentActivitiesUseCase();

  Rx<StudentReportsState> state = Rx(StudentReportsStateLoading());

  StudentReportsArgsModel? args;

  Map<String, SessionActivityItemUiState> itemChangedMap = {};

  Function()? _updatedGroup;

  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;

    if (args is StudentReportsArgsModel) {
      this.args = args;
    }

    _loadReports();
    _initEvents();
  }

  Future<void> _loadReports() async {
    var studentId = args?.studentId ?? "";
    if (studentId.isEmpty) {
      _updateState(StudentReportsStateInvalidStudentId());
      return;
    }

    var result = await getStudentActivitiesUseCase.execute(studentId);

    if (result.isSuccess) {
      List<StudentReportItemUiState> items = [];
      var uiStates = result.data
              ?.where(
            (element) => element.updated == true,
          )
              .map((apiModel) {
            return StudentReportItemUiState(
                sessionName: apiModel.sessionName ?? "",
                sessionDate: AppDateUtils.parsStringToString(
                    apiModel.sessionDate,
                    "EEE\ndd-MM-yy",
                    Get.locale?.languageCode),
                activityId: apiModel.activityId ?? "",
                studentId: apiModel.studentId ?? "",
                studentName: apiModel.studentName ?? "",
                studentParentPhone: apiModel.studentParentPhone ?? "",
                studentPhone: apiModel.studentPhone ?? "",
                sessionQuizGrade: apiModel.sessionQuizGrade,
                quizGrade: apiModel.quizGrade,
                attended: apiModel.attended,
                behaviorStatus: apiModel.behaviorStatus?.toBehaviorEnum(),
                behaviorNotes: apiModel.behaviorNotes,
                homeworkStatus: apiModel.homeworkStatus?.toHomeworkEnum(),
                homeworkNotes: apiModel.homeworkNotes);
          }) ??
          List.empty();

      items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);
      // items.addAll(uiStates);

      var firstItem = items.firstOrNull;

      var studentName = firstItem?.studentName ?? "";
      var totalAttendance =
          items.where((element) => element.attended == true).length.toString();

      var sessionsGradesFiltered = items.where(
        (element) => element.sessionQuizGrade != null,
      );
      var sessionsGrades = sessionsGradesFiltered.isNotEmpty
          ? sessionsGradesFiltered
              .map((e) => e.sessionQuizGrade ?? 0)
              .reduce((value, element) => value + element)
          : 0;

      var gradesFiltered = items.where(
        (element) => element.quizGrade != null,
      );

      var grades = gradesFiltered.isNotEmpty
          ? gradesFiltered
              .map((e) => e.quizGrade ?? 0)
              .reduce((value, element) => value + element)
          : null;

      appLog("grades : $grades, sessionsGrades:$sessionsGrades");
      var gradesPercentage =
          (grades ?? 0) > 0 ? ((grades! / sessionsGrades) * 100).toInt() : 0;

      _updateState(StudentReportsStateSuccess(
          uiStates: items,
          studentName: studentName,
          totalAttendance: totalAttendance.toString(),
          totalSessionGrades: sessionsGrades,
          totalGrades: grades,
          gradesPercentage: gradesPercentage));
      return;
    }

    _updateState(StudentReportsStateError(result.error));
  }

  void _updateState(StudentReportsState state) {
    this.state.value = state;
  }

  void onRefresh() {
    _loadReports();
  }

  String getStudentId() => args?.studentId ?? "";

  void _initEvents() {
    SessionsEvents.addListener(_sessionsEventsUpdated);
  }

  @override
  void onClose() {
    super.onClose();
    SessionsEvents.removeListener(_sessionsEventsUpdated);
  }

  onResume() {
    if (_updatedGroup != null) {
      _updatedGroup?.call();
      _updatedGroup = null;
    }
  }

  _sessionsEventsUpdated(SessionsEventsState event) {
    if (event is SessionsEventsStateDeleted) {
      _updatedGroup = () {
        _updateState(StudentReportsStateLoading());
        _loadReports();
      };
    }
  }
}
