import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class TimeFromToInfoChipWidget extends StatelessWidget{

  final String text;

  const TimeFromToInfoChipWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     text: text,
     color: AppColors.color_008E73,
     icon: Icons.schedule_outlined,
   );
  }
}
