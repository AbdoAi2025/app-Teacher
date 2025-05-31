import 'group_details_ui_state.dart';

sealed class GroupDetailsState {}

class GroupDetailsStateLoading extends GroupDetailsState {}
class GroupDetailsStateInvalidArgs extends GroupDetailsState {}

class GroupDetailsStateSuccess extends GroupDetailsState {
  final GroupDetailsUiState uiState;
  GroupDetailsStateSuccess({required this.uiState});
}

class GroupDetailsStateError extends GroupDetailsState {
  final Exception exception;
  GroupDetailsStateError({required this.exception});
}
