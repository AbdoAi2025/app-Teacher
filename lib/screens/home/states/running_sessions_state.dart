 import 'running_session_item_ui_state.dart';

class RunningSessionsState {}

class RunningSessionsStateLoading extends RunningSessionsState{}
class RunningSessionsStateSuccess extends RunningSessionsState{
  final List<RunningSessionItemUiState> uiState;
  RunningSessionsStateSuccess(this.uiState);
}
class RunningSessionsStateError extends RunningSessionsState{
  final Exception? exception;
  RunningSessionsStateError(this.exception);
}
