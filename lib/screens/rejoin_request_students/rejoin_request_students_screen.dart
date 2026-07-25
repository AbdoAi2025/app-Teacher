import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_rejoin_request_students_response.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/models/grade_model.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teacher_app/enums/request_status_enum.dart';
import 'package:teacher_app/screens/profile/profile_controller.dart';
import 'package:teacher_app/services/environment_service.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/filters/grade_filter_chip_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/pagination_list_widget.dart';
import 'package:teacher_app/widgets/request_status_chip_widget.dart';
import 'package:teacher_app/widgets/requests_empty_view_widget.dart';
import 'package:teacher_app/widgets/search_text_field.dart';
import 'rejoin_request_students_controller.dart';

class RejoinRequestStudentsScreen extends StatefulWidget {
  const RejoinRequestStudentsScreen({super.key});

  @override
  State<RejoinRequestStudentsScreen> createState() =>
      _RejoinRequestStudentsScreenState();
}

class _RejoinRequestStudentsScreenState
    extends State<RejoinRequestStudentsScreen> {
  late final RejoinRequestStudentsController _controller;
  final TextEditingController _searchController = TextEditingController();
  late final String? _requestDate;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    final int requestId = args['id'] as int;
    _requestDate = args['date'] as String?;
    _controller = Get.put(
      RejoinRequestStudentsController(requestId: requestId),
      tag: requestId.toString(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(
        titleWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStringsKeys.rejoinRequestStudents.tr, style: AppTextStyle.appToolBarTitle),
            if (_requestDate != null && _requestDate.isNotEmpty)
              Text(_requestDate, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryColor)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              spacing: 10,
              children: [
                SearchTextField(
                  controller: _searchController,
                  onChanged: (v) => _controller.onSearchChanged(v ?? ''),
                  searchOnSubmit: true,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GradeFilterChipWidget(
                    selectedGrade: _controller.selectedGrade,
                    onSelected: _controller.onGradeSelected,
                    onReset: () => _controller.onGradeSelected(null),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: LoadingWidget());
              }
              if (_controller.error.value.isNotEmpty) {
                return _ErrorView(
                  message: _controller.error.value,
                  onRetry: _controller.load,
                );
              }
              if (_controller.items.isEmpty) {
                return RequestsEmptyViewWidget(
                  icon: Icons.people_outline_rounded,
                  title: AppStringsKeys.noStudentsFound.tr,
                );
              }
              return RefreshIndicator(
                onRefresh: _controller.load,
                child: Obx(() => _StudentList(
                      items: _controller.items.toList(),
                      totalRecord: _controller.hasMore.value
                          ? _controller.items.length + 1
                          : _controller.items.length,
                      isLoading: _controller.isLoadingMore.value,
                      getMoreItems: _controller.loadMore,
                    )),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Pagination list ───────────────────────────────────────────────────────────

class _StudentList extends PaginationListWidget<RejoinRequestStudentData> {
  const _StudentList({
    required super.items,
    required super.totalRecord,
    required super.isLoading,
    required super.getMoreItems,
  }) : super(padding: const EdgeInsets.all(16));

  @override
  Widget getItemWidget(RejoinRequestStudentData item, int index) {
    return _StudentCard(item: item);
  }
}

// ── Student card ─────────────────────────────────────────────────────────────

class _StudentCard extends StatelessWidget {
  final RejoinRequestStudentData item;
  const _StudentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final gradeName = GradeModel(
      id: null,
      nameEn: item.gradeNameEn ?? '',
      nameAr: item.gradeNameAr ?? '',
    ).name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
            child: Icon(Icons.person_outline, color: AppColors.appMainColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.studentName != null && item.studentName!.isNotEmpty)
                  AppTextWidget(item.studentName!),
                if (gradeName.isNotEmpty)
                  AppTextWidget(gradeName, color: AppColors.textSecondaryColor),
                if (item.createdDateFormat.isNotEmpty)
                  AppTextWidget(item.createdDateFormat, color: AppColors.textSecondaryColor),
              ],
            ),
          ),
          RequestStatusChipWidget(status: RequestStatusEnum.fromString(item.status)),
          if (item.parentId != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.share_outlined, color: AppColors.appMainColor, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _onShare,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _onShare() async {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    final teacherId = profileController.profile.value?.teacherId;
    if (teacherId == null) return;
    final baseUrl = EnvironmentService.baseUrl.replaceAll(RegExp(r'/$'), '');
    final link = '$baseUrl/rejoin/$teacherId?parentId=${item.parentId}';
    await SharePlus.instance.share(ShareParams(text: link));
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryColor)),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(AppStringsKeys.retry.tr)),
        ],
      ),
    );
  }
}