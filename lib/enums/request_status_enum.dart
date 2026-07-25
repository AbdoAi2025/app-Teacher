import 'package:flutter/material.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/themes/app_colors.dart';

enum RequestStatusEnum {
  pending,
  accepted,
  rejected,
  unknown;

  static RequestStatusEnum fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'pending' => RequestStatusEnum.pending,
      'accepted' => RequestStatusEnum.accepted,
      'rejected' => RequestStatusEnum.rejected,
      _ => RequestStatusEnum.unknown,
    };
  }

  Color get color => switch (this) {
        RequestStatusEnum.pending => Colors.orange,
        RequestStatusEnum.accepted => Colors.green,
        RequestStatusEnum.rejected => Colors.red,
        RequestStatusEnum.unknown => AppColors.textSecondaryColor,
      };

  String get labelKey => switch (this) {
        RequestStatusEnum.pending => AppStringsKeys.pending,
        RequestStatusEnum.accepted => AppStringsKeys.accepted,
        RequestStatusEnum.rejected => AppStringsKeys.rejected,
        RequestStatusEnum.unknown => '',
      };
}