import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/usecases/get_grades_list_use_case.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';
import 'grades_selection_state.dart';

class SelectGradeController extends GetxController {
  final Rx<GradesSelectionState> state =
      Rx<GradesSelectionState>(GradesSelectionStateLoading());

  final _useCase = GetGradesListUseCase();

  Future<void> loadGrades({String? selectedId}) async {
    state.value = GradesSelectionStateLoading();
    final result = await _useCase.execute();
    if (result is AppResultSuccess) {
      final items = (result.data ?? [])
          .map((e) => ItemSelectionUiState(
                id: e.id?.toString() ?? '',
                name: e.localizedName?.toLocalizedName() ?? '',
                isSelected: e.id?.toString() == selectedId,
              ))
          .toList();
      state.value = GradesSelectionStateSuccess(items);
    } else {
      state.value =
          GradesSelectionStateError(result.error?.toString() ?? 'Error');
    }
  }
}