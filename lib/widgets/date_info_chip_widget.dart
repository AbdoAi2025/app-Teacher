import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class DateInfoChipWidget extends StatelessWidget{

  final String date;

  const DateInfoChipWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     text: date,
     color: AppColors.color_26856C,
     icon: Icons.date_range,
   );
  }
}
