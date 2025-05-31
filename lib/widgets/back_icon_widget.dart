import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/generated/assets.dart';
import 'package:teacher_app/themes/padding.dart';

class BackIconWidget extends StatelessWidget {

  final Function()? onClick;

  const BackIconWidget({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onClick != null) {
            onClick?.call();
          } else {
            Get.back();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: paddingSmall, vertical: paddingSmall),
          child: Transform.flip(
              flipX: !AppSetting.isArabic,
              child: SvgPicture.asset(Assets.svgArrowRight)),
        ));
  }
}
