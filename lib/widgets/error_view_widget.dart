import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

class ErrorViewWidget extends StatelessWidget {

  final String message;
  final String? retryText;
  final Function()? onRetry;
  final TextStyle? style;

  const ErrorViewWidget(
      {super.key,
      required this.message,
      this.style,
      this.retryText,
      this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
     messageView(),
      if (onRetry != null)
        PrimaryButtonWidget(
          text: retryText ?? "Retry".tr,
          onClick: () {
            onRetry?.call();
          },
        ),
    ]);
  }

  Widget messageView() {
    return AppTextWidget(message, style: style ?? AppTextStyle.textErrorStyle);
  }
}
