 class EndSessionState {}

class EndSessionStateLoading extends EndSessionState{}
class EndSessionStateSuccess extends EndSessionState{
  final String id;
  EndSessionStateSuccess(this.id);
}
class EndSessionStateError extends EndSessionState{
  final Exception? exception;
  EndSessionStateError(this.exception);
}
