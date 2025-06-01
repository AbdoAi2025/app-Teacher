 class StartSessionState {}

class StartSessionStateLoading extends StartSessionState{}
class StartSessionStateSuccess extends StartSessionState{
  final String id;
  StartSessionStateSuccess(this.id);
}
class StartSessionStateError extends StartSessionState{
  final Exception? exception;
  StartSessionStateError(this.exception);
}
