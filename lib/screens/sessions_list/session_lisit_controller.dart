import 'package:get/get.dart';
import 'package:teacher_app/data/requests/get_my_sessions_request.dart';
import 'package:teacher_app/domain/usecases/get_my_sessions_use_case.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
import 'package:teacher_app/localization/localArabic.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/screens/sessions_list/args/session_list_args_model.dart';
import 'package:teacher_app/screens/sessions_list/states/session_item_ui_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../domain/events/sessions_events.dart';
import 'states/session_lisit_state.dart';

class SessionListController extends GetxController {

  Rx<SessionListState> state = Rx(SessionListStateLoading());

  GetMySessionsRequest request = GetMySessionsRequest();

  Map<String, SessionActivityItemUiState> itemChangedMap = {};

  Function()? _updatedGroup;

  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;

    if(args is SessionListArgsModel){
      request.groupId = args.groupId;
      request.studentId = args.studentId;
    }

    _loadSessions();
    _initEvents();
  }

  Future<void> _loadSessions() async {
    var result = await GetMySessionsUseCase().execute(request);

    if (result.isSuccess) {
      var uiStates = result.data?.map((apiModel) {
        return SessionItemUiState(
            id: apiModel.sessionId ?? "",
            sessionStatus: SessionStatus.fromValue(apiModel.sessionStatus ?? 0),
            sessionCreatedAt: apiModel.createdAt ?? "",
            groupId: apiModel.groupId ?? "",
            groupName: apiModel.groupName ?? "",
            timeFrom: apiModel.timeFrom ?? "",
            timeTo: apiModel.timeTo ?? "",
          sessionName: apiModel.sessionName ?? "",
        );
      }).toList() ?? List.empty();

      _updateState(SessionListStateSuccess(uiStates));
      return;
    }

    _updateState(SessionListStateError(result.error));
  }

  void _updateState(SessionListState state) {
    this.state.value = state;
  }

  void onRefresh() {
    _loadSessions();
  }

  String getStudentId() => request.studentId ?? "";


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
    if(event is SessionsEventsStateDeleted){
      _updatedGroup = (){
        _updateState(SessionListStateLoading());
        _loadSessions();
      };
    }
  }

}
