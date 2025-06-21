import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class BehaviorStatusWidget extends StatelessWidget{



  final StudentBehaviorEnum? status;

  const BehaviorStatusWidget(this.status, {super.key,});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(status.getString().tr , color: status.getColor(),);
  }
}
