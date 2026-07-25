import 'dart:async';

import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/get_rejoin_request_students_response.dart';
import 'package:teacher_app/domain/usecases/get_rejoin_request_students_use_case.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';

const int _pageSize = 20;

class RejoinRequestStudentsController extends GetxController {
  final int requestId;

  RejoinRequestStudentsController({required this.requestId});

  final _useCase = GetRejoinRequestStudentsUseCase();

  final RxList<RejoinRequestStudentData> items = <RejoinRequestStudentData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;

  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);
  String _search = '';
  Timer? _searchDebounce;

  int _page = 0;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  void onGradeSelected(ItemSelectionUiState? grade) {
    selectedGrade.value = grade;
    load();
  }

  void onSearchChanged(String query) {
    _search = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 800), load);
  }

  Future<void> load() async {
    _page = 0;
    hasMore.value = true;
    isLoadingMore.value = false;
    error.value = '';
    isLoading.value = true;
    await _fetchPage();
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    _page++;
    await _fetchPage();
    isLoadingMore.value = false;
  }

  Future<void> _fetchPage() async {
    final result = await _useCase.execute(
      requestId,
      page: _page,
      size: _pageSize,
      gradeId: selectedGrade.value?.id,
      search: _search.isEmpty ? null : _search,
    );
    if (result is AppResultSuccess) {
      final pageData = result.value!;
      hasMore.value = (_page + 1) < (pageData.totalPages ?? 0);
      if (_page == 0) {
        items.value = pageData.items ?? [];
      } else {
        items.addAll(pageData.items ?? []);
      }
    } else {
      if (_page == 0) error.value = result.error?.toString() ?? 'error'.tr;
      _page--;
    }
  }
}