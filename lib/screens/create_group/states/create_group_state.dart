

sealed class CreateGroupState {}

class CreateGroupStateLoading extends CreateGroupState {}
class CreateGroupStateFormValidation extends CreateGroupState {}
class CreateGroupStateSuccess extends CreateGroupState {}
class CreateGroupStateError extends CreateGroupState {
  final Exception? exception;
  CreateGroupStateError(this.exception);

}