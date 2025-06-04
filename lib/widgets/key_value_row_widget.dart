import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/txt_styles.dart';

class KeyValueRowWidget extends StatelessWidget {

  final String keyText;
  final String? value;
  final MainAxisSize? mainAxisSize;
  final Widget? keyWidget;
  final Widget? valueWidget;

  const KeyValueRowWidget({
    super.key,
    required this.keyText,
    this.value ,
    this.mainAxisSize,
    this.keyWidget,
    this.valueWidget,
  });


  @override
  Widget build(BuildContext context) {

    return Row(
        spacing: 5,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min, children: [

      keyWidget?? AppTextWidget(keyText, style: AppTextStyle.label),

      if(value != null || value != "" || valueWidget != null )...{
        if(mainAxisSize == MainAxisSize.min)...{
          _valueText(value ?? "")
        }else ...{
          Expanded(child:_valueText(value ?? ""))
        },
      }

    ]);
  }

  _valueText(String value) => valueWidget ?? AppTextWidget(value , style: AppTextStyle.value);


}
