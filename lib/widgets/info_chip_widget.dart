import 'package:flutter/cupertino.dart';

import '../themes/txt_styles.dart';
import 'app_txt_widget.dart';

class InfoChipWidget extends StatelessWidget{
  final String? text;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final double? size;
  const InfoChipWidget({super.key,  this.text, this.color, this.icon, this.textStyle,this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: color == null ? 0 : 10, vertical:  6),
      decoration: color == null ? null : BoxDecoration(
        color: color!.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null)
            Icon(
              icon,
              size: size ?? 14,
              color: color,
            ),
          if(text != null && text!.isNotEmpty)
          AppTextWidget(
            text!,
            style: textStyle ?? AppTextStyle.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }


}
