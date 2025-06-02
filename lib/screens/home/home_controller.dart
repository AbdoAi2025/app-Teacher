import 'package:get/get.dart';
import 'package:teacher_app/screens/home/states/running_sessions_state.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/running_sessions/running_session_manager.dart';

class HomeController extends GetxController {

  Rx<RunningSessionsState> runningState = RunningSessionManager.runningState;
  var todayGroupsState = GroupsManagers.todayGroupsState;

  @override
  void onInit() {
    super.onInit();
    _loadRunningSession();
    _initLoadGroups();
  }

  Future<void> _loadRunningSession() async {
    RunningSessionManager.loadRunningSession();
  }

  onRefresh() {
    RunningSessionManager.onRefresh();
    GroupsManagers.onRefresh();
  }

  void updateRunningSessionState(RunningSessionsState state) {
    runningState.value = state;
  }

  void _initLoadGroups() {
    GroupsManagers.loadGroups();
  }
}
