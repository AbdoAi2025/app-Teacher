import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/app_colors.dart';

class QuizGradeWidget extends StatelessWidget {

  final int total;
  final double? score;
  final double? fontSize;

  const QuizGradeWidget({super.key, required this.total, required this.score , this.fontSize});

  @override
  Widget build(BuildContext context) {

    var color = (score ?? 0) < total/2 ? AppColors.colorNo : AppColors.colorYes;

    return AppTextWidget(
      score == null ? "Not Determined".tr : "${_getGradeFormat()} / $total" ,
      color: score == null ? AppColors.inactiveColor : color,
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize,
    );
  }


  _getGradeFormat() {
    return NumberFormat.compact().format(score ?? 0);
  }

}
