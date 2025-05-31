class ItemSelectionUiState {
  final String id;
  final String name;
  late bool isSelected;

  ItemSelectionUiState(
      {required this.id,
        required this.name,
        required this.isSelected});

  ItemSelectionUiState copyWith() {
    return ItemSelectionUiState(
        id: id,
        name: name,
        isSelected: isSelected
    );
  }
}
