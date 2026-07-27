import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/models/grade_model.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/enums/request_status_enum.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/filters/grade_filter_chip_widget.dart';
import 'package:teacher_app/widgets/filters/status_filter_chip_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/pagination_list_widget.dart';
import 'package:teacher_app/widgets/request_status_chip_widget.dart';
import 'package:teacher_app/widgets/requests_empty_view_widget.dart';
import 'requests_controller.dart';

class EnrollmentRequestScreen extends StatelessWidget {
  const EnrollmentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestsController());
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: AppStringsKeys.enrollmentRequests.tr),
      body: Column(
        children: [
          _FilterRow(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: LoadingWidget());
              }
              if (controller.error.value.isNotEmpty) {
                return _ErrorView(
                    message: controller.error.value, onRetry: controller.load);
              }
              if (controller.items.isEmpty) {
                return RequestsEmptyViewWidget(
                  icon: Icons.inbox_outlined,
                  title: AppStringsKeys.noRequests.tr,
                );
              }
              return Obx(() => _EnrollmentRequestList(
                    items: controller.items.toList(),
                    totalRecord: controller.hasMore.value
                        ? controller.items.length + 1
                        : controller.items.length,
                    isLoading: controller.isLoadingMore.value,
                    getMoreItems: controller.loadMore,
                  ));
            }),
          ),
        ],
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final RequestsController controller;
  const _FilterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            StatusFilterChipWidget(
              selectedStatus: controller.selectedStatus,
              onSelected: controller.onStatusFilterSelected,
            ),
            const SizedBox(width: 8),
            GradeFilterChipWidget(
              selectedGrade: controller.selectedGrade,
              onSelected: controller.onGradeFilterSelected,
              onReset: () => controller.onGradeFilterSelected(null),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pagination list ───────────────────────────────────────────────────────────

class _EnrollmentRequestList extends PaginationListWidget<EnrollRequestData> {
  const _EnrollmentRequestList({
    required super.items,
    required super.totalRecord,
    required super.isLoading,
    required super.getMoreItems,
  }) : super(padding: const EdgeInsets.all(16));

  @override
  Widget getItemWidget(EnrollRequestData item, int index) {
    return _RequestCard(item: item);
  }
}

// ── Request card ─────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final EnrollRequestData item;
  const _RequestCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestsController>();
    final gradeName = GradeModel(
      id: null,
      nameEn: item.gradeNameEn ?? '',
      nameAr: item.gradeNameAr ?? '',
    ).name;
    final isPending =
        RequestStatusEnum.fromString(item.status) == RequestStatusEnum.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
                child: Icon(Icons.person_outline,
                    color: AppColors.appMainColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.studentName != null && item.studentName!.isNotEmpty)
                      AppTextWidget(item.studentName!),
                    if (item.fromUserName != null && item.fromUserName!.isNotEmpty)
                      AppTextWidget(item.fromUserName!,
                          color: AppColors.textSecondaryColor),
                    if (gradeName.isNotEmpty)
                      AppTextWidget(gradeName,
                          color: AppColors.textSecondaryColor),
                    if (item.createdDateFormat.isNotEmpty)
                      AppTextWidget(item.createdDateFormat,
                          color: AppColors.textSecondaryColor),
                  ],
                ),
              ),
              RequestStatusChipWidget(
                  status: RequestStatusEnum.fromString(item.status)),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 10),
            Obx(() {
              final isUpdating = controller.updatingIds.contains(item.id);
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: isUpdating
                        ? null
                        : () => controller.updateRequestStatus(
                            item.id!, 'REJECTED'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: Text(AppStringsKeys.reject.tr),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () => controller.updateRequestStatus(
                            item.id!, 'ACCEPTED'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appMainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(AppStringsKeys.accept.tr),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
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
          TextButton(
              onPressed: onRetry, child: Text(AppStringsKeys.retry.tr)),
        ],
      ),
    );
  }
}