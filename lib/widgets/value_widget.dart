import 'package:flutter/cupertino.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class ValueWidget extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;

  const ValueWidget(this.text , {super.key , this.textAlign, this.style});

  @override
  Widget build(BuildContext context) {
   return AppTextWidget(text, style: style?? AppTextStyle.value, textAlign : textAlign);
  }

}
