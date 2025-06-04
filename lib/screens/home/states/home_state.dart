import 'package:get/get.dart';
import 'package:teacher_app/screens/groups/groups_state.dart';

import 'running_sessions_state.dart';

class HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateLoaded extends HomeState {
  final Rx<RunningSessionsState> runningState;
  final Rx<GroupsState> todayGroupsState;

  HomeStateLoaded({required this.runningState, required this.todayGroupsState});
}
