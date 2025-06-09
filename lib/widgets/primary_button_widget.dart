import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final Function() onClick;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const PrimaryButtonWidget(
      {super.key,
        required this.text,
        required this.onClick ,
        this.padding,
        this.textStyle,
      });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      style: ElevatedButton.styleFrom(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: AppTextWidget(text, style: textStyle ?? TextStyle(fontSize: 18)),
    );
  }
}
