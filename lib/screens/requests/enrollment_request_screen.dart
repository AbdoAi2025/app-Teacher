import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/pagination_list_widget.dart';
import 'requests_controller.dart';

class EnrollmentRequestScreen extends StatelessWidget {
  const EnrollmentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestsController());
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: AppStringsKeys.enrollmentRequests.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }
        if (controller.error.value.isNotEmpty) {
          return _ErrorView(message: controller.error.value, onRetry: controller.load);
        }
        if (controller.items.isEmpty) {
          return _EmptyView();
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
    final formattedDate = item.createdAt != null
        ? DateFormat('dd MMM yyyy').format(item.createdAt!)
        : '';

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
                if (item.fromUserName != null && item.fromUserName!.isNotEmpty)
                  AppTextWidget(item.fromUserName!, color: AppColors.textSecondaryColor),
                if (item.gradeNameEn != null && item.gradeNameEn!.isNotEmpty)
                  AppTextWidget(item.gradeNameEn!, color: AppColors.textSecondaryColor),
                if (formattedDate.isNotEmpty)
                  AppTextWidget(formattedDate, color: AppColors.textSecondaryColor),
              ],
            ),
          ),
          if (item.status != null) _StatusChip(status: item.status!),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'pending' => Colors.orange,
      'accepted' => Colors.green,
      'rejected' => Colors.red,
      _ => AppColors.textSecondaryColor,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Empty / Error ─────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 12),
          AppTextWidget(AppStringsKeys.noRequests.tr, color: AppColors.textSecondaryColor),
        ],
      ),
    );
  }
}

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