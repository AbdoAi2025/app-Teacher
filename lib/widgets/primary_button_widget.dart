import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final Function() onClick;

  const PrimaryButtonWidget(
      {super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: AppTextWidget(text, style: TextStyle(fontSize: 18)),
    );
  }
}
