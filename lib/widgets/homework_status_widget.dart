import 'package:flutter/cupertino.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class HomeworkStatusWidget extends StatelessWidget{



  final HomeworkEnum? status;

  const HomeworkStatusWidget(this.status, {super.key,});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(status.getString() , color: status.getColor(),);
  }
}
