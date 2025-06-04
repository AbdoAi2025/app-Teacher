import 'session_item_ui_state.dart';

class SessionListState {}
class SessionListStateLoading extends SessionListState{}
class SessionListStateSuccess extends SessionListState{
  final List<SessionItemUiState> uiStates;
  SessionListStateSuccess(this.uiStates);
}
class SessionListStateError extends SessionListState{
  final Exception? exception;
  SessionListStateError(this.exception);
}
