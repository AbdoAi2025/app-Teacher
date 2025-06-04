import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class PhoneWithIconWidget extends StatelessWidget {
  final String phone;
  final bool hideIcon;
  final bool showCallIcon;
  final MainAxisSize? mainAxisSize;


  const PhoneWithIconWidget(this.phone, {super.key ,this.hideIcon = false ,this.showCallIcon = false , this.mainAxisSize});

  @override
  Widget build(BuildContext context) {
    return Row(
        spacing: 5,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min, children: [

      if(!hideIcon)
      Icon(Icons.phone, color: AppColors.appMainColor, size: 18),

      if(mainAxisSize == null || mainAxisSize == MainAxisSize.min)...{
        _phoneValue()
      }else ...{
        Expanded(child: _phoneValue()),
      },


      if(showCallIcon)
      _callIcon()

    ]);
  }


  _callIcon() {
    return Transform.flip(
        flipX: true,
        child: Icon(Icons.phone_in_talk_outlined, color: AppColors.appMainColor, size: 18));
  }

  _phoneValue() => AppTextWidget(phone , style: AppTextStyle.value,);
}
