import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/domain/usecases/get_received_requests_use_case.dart';

const int _pageSize = 20;

class RequestsController extends GetxController {
  final _useCase = GetReceivedRequestsUseCase();

  final RxList<EnrollRequestData> items = <EnrollRequestData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;
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
    final result = await _useCase.execute(page: _page, size: _pageSize);
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