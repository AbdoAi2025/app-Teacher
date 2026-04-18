import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';

class StudentFirstLetterWidget  extends StatelessWidget{

  final String name;
  const StudentFirstLetterWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return Container();
    var color = _getBackgroundColor(name);
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: .1),
      ),
      child: AppTextWidget(
        name[0].toUpperCase(),
        style: AppTextStyle.title,
        color: color,
      ),
    );
  }


  Color _getBackgroundColor(String name) {
    if (name.isEmpty) return AppColors.appMainColor;

    // List of professional colors for the background
    final List<Color> backgroundColors = [
      Color(0xFF008E73), // Teal
      Color(0xFF1E88E5), // Blue
      Color(0xFF8E24AA), // Purple
      Color(0xFFD81B60), // Pink
      Color(0xFFF4511E), // Deep Orange
      Color(0xFF43A047), // Green
      Color(0xFF3949AB), // Indigo
    ];

    // Get the first character's code and use modulo to pick a color
    int index =
        name.trim().toUpperCase().codeUnitAt(0) % backgroundColors.length;
    return backgroundColors[index];
  }

}
