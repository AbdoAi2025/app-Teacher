import 'package:get/get.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/screens/home/states/running_sessions_state.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/running_sessions/running_session_manager.dart';
import '../../domain/usecases/get_profile_info_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'states/home_state.dart';

class HomeController extends GetxController {

  Rx<RunningSessionsState> runningState = RunningSessionManager.runningState;
  var todayGroupsState = GroupsManagers.todayGroupsState;

  Rx<HomeState> homeState = Rx(HomeStateLoading());

  Rx<ProfileInfoModel?> profileInfo = Rx<ProfileInfoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _initLoadHomeData();
    _initGetProfileInfo();
  }

  Future<void> _initLoadHomeData() async {
    await _loadRunningSession();
    await _initLoadGroups();
    _updateHomeState(HomeStateLoaded(runningState: runningState, todayGroupsState: todayGroupsState));
  }

  Future<void> _loadRunningSession() async {
    RunningSessionManager.loadRunningSession();
  }

  onRefresh() {
    _updateHomeState(HomeStateLoading());
    _initLoadHomeData();
  }

  void updateRunningSessionState(RunningSessionsState state) {
    runningState.value = state;
  }

  Future<void> _initLoadGroups() async {
    await GroupsManagers.loadGroups();
  }

  Future<void> _initGetProfileInfo() async {
    GetProfileInfoUseCase getProfileInfoUseCase = GetProfileInfoUseCase();
    profileInfo.value = await getProfileInfoUseCase.execute();
  }

  logout() async {
    await LogoutUseCase().execute();
  }

  void _updateHomeState(HomeState state) {
    homeState.value = state;
  }


}
