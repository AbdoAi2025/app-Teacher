
import 'session_details_ui_state.dart';

class SessionDetailsState {}

class SessionDetailsStateLoading extends SessionDetailsState{}
class SessionDetailsStateInvalidArgs extends SessionDetailsState{}
class SessionDetailsStateNotFound extends SessionDetailsState{}
class SessionDetailsStateSuccess extends SessionDetailsState{
  final SessionDetailsUiState uiState;
  SessionDetailsStateSuccess(this.uiState);
}
class SessionDetailsStateError extends SessionDetailsState{
  final Exception? exception;
  SessionDetailsStateError(this.exception);
}
