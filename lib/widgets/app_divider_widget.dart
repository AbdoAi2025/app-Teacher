import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppDividerWidget  extends StatelessWidget{

  const AppDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppColors.color_DBD5CC.withValues(alpha: 0.5), thickness: 1);
  }



}
