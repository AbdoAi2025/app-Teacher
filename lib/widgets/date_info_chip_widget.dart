import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class DateInfoChipWidget extends StatelessWidget{

  final String date;
  final Color? color;
  final TextStyle? textStyle;
  final  double? fontSize;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const DateInfoChipWidget({super.key, required this.date , this.color = AppColors.color_26856C , this.textStyle , this.fontSize , this.size , this.padding});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     text: date,
     color: color,
     size: size,
     padding: padding,
     fontSize: fontSize,
     textStyle: textStyle,
     icon: Icons.date_range,
   );
  }
}
