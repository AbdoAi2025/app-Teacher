import 'package:flutter/cupertino.dart';
import 'package:teacher_app/widgets/info_chip_widget.dart';

import '../themes/app_colors.dart';

class GradeChipWidget extends StatelessWidget{

  final String gradeName;
  final Color? color;
  final IconData? icon;

  const GradeChipWidget({super.key, required this.gradeName , this.color  , this.icon});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     icon: icon,
     text : gradeName,
     color : color ?? AppColors.color_3D5AB6,
   );
  }
}
