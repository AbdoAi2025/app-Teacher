import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/txt_styles.dart';

class SectionWidget extends StatelessWidget {
  final String? title;
  final String? innerTitle;
  final Widget child;

  const SectionWidget({super.key, this.title,this.innerTitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          _titleText(title!),
        Container(
            decoration: AppBackgroundStyle.backgroundWithShadow(),
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (innerTitle != null)
                  _titleText(innerTitle!),
                child,
              ],
            )
        ),
      ],
    );
  }

  _titleText(String title) => AppTextWidget(title,
      style: AppTextStyle.title.copyWith(color: AppColors.appMainColor));
}
