import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/usecases/get_grades_list_use_case.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';
import 'grades_selection_state.dart';

class SelectGradeController extends GetxController {
  final Rx<GradesSelectionState> gradeSelectionState =
      Rx<GradesSelectionState>(GradesSelectionStateLoading());

  Function(ItemSelectionUiState?)? _onSelected;
  bool _showClearOption = false;
  String? _selectedId;
  bool _loaded = false;

  final _useCase = GetGradesListUseCase();

  void init({
    String? selectedId,
    bool showClearOption = false,
    required Function(ItemSelectionUiState?) onSelected,
  }) {
    _selectedId = selectedId;
    _showClearOption = showClearOption;
    _onSelected = onSelected;
  }

  void checkGradesState() {
    if (!_loaded) {
      _loaded = true;
      _loadGrades();
    }
  }

  Future<void> _loadGrades() async {
    gradeSelectionState.value = GradesSelectionStateLoading();
    final result = await _useCase.execute();
    if (result is AppResultSuccess) {
      var items = (result.data ?? [])
          .map((e) => ItemSelectionUiState(
                id: e.id?.toString() ?? '',
                name: e.localizedName?.toLocalizedName() ?? '',
                isSelected: e.id?.toString() == _selectedId,
              ))
          .toList();
      if (_showClearOption) {
        items = [
          ItemSelectionUiState(
            id: '',
            name: 'All Grades'.tr,
            isSelected: _selectedId == null || _selectedId!.isEmpty,
          ),
          ...items,
        ];
      }
      gradeSelectionState.value = GradesSelectionStateSuccess(items);
    } else {
      gradeSelectionState.value =
          GradesSelectionStateError(result.error?.toString() ?? 'Error');
    }
  }

  void onSelectedGrade(ItemSelectionUiState? item) {
    final isAllGrades = item == null || item.id.isEmpty;
    _onSelected?.call(isAllGrades ? null : item);
  }
}