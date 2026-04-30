import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class DeleteInfoChipWidget extends StatelessWidget {

  final VoidCallback? onClick;
  const DeleteInfoChipWidget({super.key,  this.onClick});

  @override
  Widget build(BuildContext context) {

    return InfoChipWidget(
      onTap: () => onClick?.call(),
      color: AppColors.colorRed,
      icon:   Icons.delete_outline,
      size: 20,
    );
   return  InfoChipWidget(

     color: AppColors.colorError,
     icon: Icons.remove_circle_outline,
     size: 24,
   );
  }
}
