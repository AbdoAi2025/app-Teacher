import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class AppErrorWidget extends StatelessWidget {

  final String message;
  final Function? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_errorMessage(), if (onRetry != null) _retryButton()],
      ),
    );
  }

  _errorMessage() => AppTextWidget(
        message,
        color: AppColors.colorError,
      );

  _retryButton() => InkWell(
      onTap: () {
        onRetry?.call();
      },
      child: AppTextWidget("Retry".tr));
}
