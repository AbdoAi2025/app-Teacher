import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/request_status_enum.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/themes/app_colors.dart';

class StatusFilterChipWidget extends StatelessWidget {
  final Rx<RequestStatusEnum?> selectedStatus;
  final Function(RequestStatusEnum?) onSelected;

  const StatusFilterChipWidget({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = selectedStatus.value;
      if (selected != null) {
        return InputChip(
          label: Text(
            selected.labelKey.tr,
            style: TextStyle(color: selected.color, fontSize: 13),
          ),
          avatar: Icon(Icons.filter_list, size: 16, color: selected.color),
          deleteIcon: Icon(Icons.close, size: 16, color: selected.color),
          onDeleted: () => onSelected(null),
          onPressed: () => _openStatusMenu(context),
          backgroundColor: selected.color.withValues(alpha: 0.1),
          side: BorderSide(color: selected.color),
          padding: const EdgeInsets.symmetric(horizontal: 0),
        );
      }
      return ActionChip(
        avatar: Icon(Icons.filter_list, size: 16, color: AppColors.textSecondaryColor),
        label: Text(
          AppStringsKeys.status.tr,
          style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 13),
        ),
        onPressed: () => _openStatusMenu(context),
        backgroundColor: AppColors.colorOffWhite,
        side: BorderSide(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 0),
      );
    });
  }

  void _openStatusMenu(BuildContext context) {
    final options = [
      RequestStatusEnum.pending,
      RequestStatusEnum.accepted,
      RequestStatusEnum.rejected,
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text(AppStringsKeys.all.tr),
              onTap: () {
                onSelected(null);
                Get.back();
              },
            ),
            const Divider(height: 1),
            ...options.map((s) => ListTile(
                  leading: Icon(Icons.circle, size: 12, color: s.color),
                  title: Text(s.labelKey.tr),
                  trailing: selectedStatus.value == s
                      ? Icon(Icons.check, color: AppColors.appMainColor)
                      : null,
                  onTap: () {
                    onSelected(s);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }
}