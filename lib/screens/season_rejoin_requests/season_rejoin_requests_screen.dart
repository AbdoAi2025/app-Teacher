import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_rejoin_requests_response.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/enums/request_status_enum.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/pagination_list_widget.dart';
import 'package:teacher_app/widgets/request_status_chip_widget.dart';
import 'package:teacher_app/widgets/requests_empty_view_widget.dart';
import 'season_rejoin_requests_controller.dart';

class SeasonRejoinRequestsScreen extends StatelessWidget {
  const SeasonRejoinRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeasonRejoinRequestsController());
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: AppStringsKeys.seasonRejoinRequests.tr),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onCreateTapped(controller),
        backgroundColor: AppColors.appMainColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }
        if (controller.error.value.isNotEmpty) {
          return _ErrorView(message: controller.error.value, onRetry: controller.load);
        }
        if (controller.items.isEmpty) {
          return RequestsEmptyViewWidget(
            icon: Icons.sync_outlined,
            title: AppStringsKeys.noRequests.tr,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: Obx(() => _RejoinRequestList(
                items: controller.items.toList(),
                totalRecord: controller.hasMore.value
                    ? controller.items.length + 1
                    : controller.items.length,
                isLoading: controller.isLoadingMore.value,
                getMoreItems: controller.loadMore,
              )),
        );
      }),
    );
  }

  void _onCreateTapped(SeasonRejoinRequestsController controller) {
    showConfirmationMessage(
      AppStringsKeys.areYouSureToSendRejoinRequestToAllParents.tr,
      () async {
        showDialogLoading();
        final errorMessage = await controller.createRequest();
        hideDialogLoading();
        if (errorMessage == null) {
          showSuccessMessage(AppStringsKeys.requestCreatedSuccessfully.tr);
        } else {
          showErrorMessage(errorMessage);
        }
      },
    );
  }
}

// ── Pagination list ───────────────────────────────────────────────────────────

class _RejoinRequestList extends PaginationListWidget<RejoinRequestData> {
  const _RejoinRequestList({
    required super.items,
    required super.totalRecord,
    required super.isLoading,
    required super.getMoreItems,
  }) : super(padding: const EdgeInsets.all(16));

  @override
  Widget getItemWidget(RejoinRequestData item, int index) {
    return GestureDetector(
      onTap: () {
        if (item.id != null) AppNavigator.navigateToRejoinRequestStudents(item.id!, date: item.createdDateFormat);
      },
      child: _RejoinRequestCard(item: item),
    );
  }
}

// ── Request card ─────────────────────────────────────────────────────────────

class _RejoinRequestCard extends StatelessWidget {
  final RejoinRequestData item;
  const _RejoinRequestCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = item.createdDateFormat;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
            child: Icon(Icons.sync_outlined, color: AppColors.appMainColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.name != null && item.name!.isNotEmpty)
                  AppTextWidget(item.name!),
                // if (item.fromUserName != null && item.fromUserName!.isNotEmpty)
                //   AppTextWidget(item.fromUserName!, color: AppColors.textSecondaryColor),
                if (formattedDate.isNotEmpty)
                  AppTextWidget(formattedDate, color: AppColors.textSecondaryColor),
              ],
            ),
          ),
          RequestStatusChipWidget(status: RequestStatusEnum.fromString(item.status)),
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
          TextButton(onPressed: onRetry, child: Text(AppStringsKeys.retry.tr)),
        ],
      ),
    );
  }
}