import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/txt_styles.dart';

class HomeworkStatusWidget extends StatelessWidget{



  final HomeworkEnum? status;
  final double? fontSize;

  const HomeworkStatusWidget(this.status, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(
      status.getString().tr ,
      color: status.getColor(),
      fontSize: fontSize,
      overflow: TextOverflow.ellipsis,);
  }
}
