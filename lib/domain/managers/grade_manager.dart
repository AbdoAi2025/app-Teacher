import 'package:get/get.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/domain/usecases/get_grades_list_use_case.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/extensions_utils.dart';

import '../../exceptions/app_http_exception.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';

enum GradeManagerState { loading, success, error }

class GradeManager {
  static final GradeManager _instance = GradeManager._internal();
  factory GradeManager() => _instance;
  GradeManager._internal();

  final GetGradesListUseCase _getGradesListUseCase = GetGradesListUseCase();

  Rx<GradeManagerState> state = Rx(GradeManagerState.loading);
  List<GradeApiModel> _grades = [];
  String? _errorMessage;

  List<GradeApiModel> get grades => List.unmodifiable(_grades);
  String? get errorMessage => _errorMessage;

  Future<void> loadGrades() async {
    appLog("GradeManager: Loading grades...");
    state.value = GradeManagerState.loading;

    try {
      final result = await _getGradesListUseCase.execute();

      if (result.isSuccess && result.data != null) {
        _grades = result.data!;
        state.value = GradeManagerState.success;
        appLog("GradeManager: Successfully loaded ${_grades.length} grades");
      } else {
        _errorMessage = result.error?.toString() ?? "Failed to load grades";
        state.value = GradeManagerState.error;
        appLog("GradeManager: Error loading grades - $_errorMessage");
      }
    } catch (e) {
      _errorMessage = e.toString();
      state.value = GradeManagerState.error;
      appLog("GradeManager: Exception loading grades - $_errorMessage");
    }
  }

  List<ItemSelectionUiState> getGradeSelectionItems() {
    return _grades.map((grade) => ItemSelectionUiState(
      id: grade.id?.toString() ?? '',
      name: grade.localizedName?.toLocalizedName() ?? grade.nameEn ?? grade.nameAr ?? 'Unknown Grade',
      isSelected: false,
    )).toList();
  }

  GradeApiModel? findGradeById(String gradeId) {
    try {
      return _grades.firstWhere((grade) => grade.id?.toString() == gradeId);
    } catch (e) {
      return null;
    }
  }

  void refresh() {
    loadGrades();
  }
}