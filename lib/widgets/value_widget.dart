import 'package:flutter/cupertino.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class ValueWidget extends StatelessWidget {

  final String text;
  final TextAlign? textAlign;

  const ValueWidget(this.text , {super.key , this.textAlign});

  @override
  Widget build(BuildContext context) {
   return AppTextWidget(text, style: AppTextStyle.value, textAlign : textAlign);
  }

}
