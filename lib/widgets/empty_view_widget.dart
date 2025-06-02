import 'package:flutter/cupertino.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import 'error_view_widget.dart';

class EmptyViewWidget extends ErrorViewWidget {

  const EmptyViewWidget({
    super.key,
    required super.message,
    super.style,
    super.retryText,
    super.onRetry,
  });

  @override
  Widget messageView() {
    return AppTextWidget(message,
        style: style ?? AppTextStyle.value.copyWith(
          fontSize: 16
        ));
  }
}
