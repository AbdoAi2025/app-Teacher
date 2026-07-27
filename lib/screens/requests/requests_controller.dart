import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/domain/usecases/get_received_requests_use_case.dart';
import 'package:teacher_app/domain/usecases/update_enrollment_request_status_use_case.dart';
import 'package:teacher_app/enums/request_status_enum.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';

const int _pageSize = 20;

class RequestsController extends GetxController {
  final _useCase = GetReceivedRequestsUseCase();
  final _updateUseCase = UpdateEnrollmentRequestStatusUseCase();

  final RxList<EnrollRequestData> items = <EnrollRequestData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
  final RxSet<int> updatingIds = <int>{}.obs;

  final Rx<RequestStatusEnum?> selectedStatus = Rx(null);
  final Rx<ItemSelectionUiState?> selectedGrade = Rx(null);

  int _page = 0;

  @override
  void onInit() {
    super.onInit();
    load();
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
      page: _page,
      size: _pageSize,
      status: _statusParam,
      gradeId: _gradeIdParam,
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

  String? get _statusParam => switch (selectedStatus.value) {
        RequestStatusEnum.pending => 'PENDING',
        RequestStatusEnum.accepted => 'ACCEPTED',
        RequestStatusEnum.rejected => 'REJECTED',
        _ => null,
      };

  int? get _gradeIdParam {
    final id = selectedGrade.value?.id;
    return id != null ? int.tryParse(id) : null;
  }

  void onStatusFilterSelected(RequestStatusEnum? status) {
    selectedStatus.value = status;
    load();
  }

  void onGradeFilterSelected(ItemSelectionUiState? grade) {
    selectedGrade.value = grade;
    load();
  }

  Future<void> updateRequestStatus(int id, String status, {void Function(EnrollRequestData)? onAccepted}) async {
    updatingIds.add(id);
    final result = await _updateUseCase.execute(id, status);
    updatingIds.remove(id);
    if (result is AppResultSuccess) {
      final updated = result.value!;
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        items[index] = updated;
      }
      if (status == 'ACCEPTED') onAccepted?.call(updated);
    } else {
      showErrorMessageEx(result.error);
    }
  }
}