import '../../../widgets/item_selection_widget/item_selection_ui_state.dart';

abstract class GradesSelectionState {}

class GradesSelectionStateLoading extends GradesSelectionState {}

class GradesSelectionStateSuccess extends GradesSelectionState {
  final List<ItemSelectionUiState> items;

  GradesSelectionStateSuccess(this.items);
}

class GradesSelectionStateError extends GradesSelectionState {
  final String message;
  GradesSelectionStateError(this.message);
}
