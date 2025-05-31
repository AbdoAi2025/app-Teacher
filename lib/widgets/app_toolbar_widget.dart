
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/back_icon_widget.dart';

class AppToolbarWidget {


  AppToolbarWidget._();

  static AppBar appBar(String title,
  {
    Widget? leading,
    List<Widget>? actions,
    SystemUiOverlayStyle? systemOverlayStyle,
    Color? backgroundColor,
    Function()? onLeadingClick,
  }){

    return AppBar(
        systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.dark,
        surfaceTintColor: Colors.transparent,
        title: AppTextWidget(
          title,
          style: AppTextStyle.appToolBarTitle,
        ),
        centerTitle: true,
        backgroundColor: backgroundColor ?? Colors.transparent,
        leading: Center(
          child: leading ??
              BackIconWidget(
                onClick: (){
                  onLeadingClick?.call ?? Get.back();
                },
              ),
        ),
        actions: [
          if(actions != null)...{
            ...actions,
            SizedBox(width: 10,)
          }


        ]
    );
  }
}
