import 'package:flutter/cupertino.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class LabelWidget extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;

  const LabelWidget(this.text , {super.key , this.textAlign});

  @override
  Widget build(BuildContext context) {
   return AppTextWidget(text, style: AppTextStyle.label, textAlign : textAlign);
  }

}
