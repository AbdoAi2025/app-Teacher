import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class DayInfoChipWidget extends StatelessWidget{

  final String text;

  const DayInfoChipWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     text: text,
     color: AppColors.color_3D5AB6,
     icon: Icons.calendar_today_outlined,
   );
  }
}
