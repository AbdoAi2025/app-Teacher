import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

import '../../widgets/app_toolbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar("Home".tr, hasLeading: false),
      body: _content(),
    );
  }

  _content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _runningSession(),
          Expanded(child: _todayGroups())
        ],
      ),
    );
  }

  _runningSession() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      child: Column(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        children: [_runningTitle(), _timer(), _endSession() , _viewDetails()],
      ),
    );
  }

  _timer() => AppTextWidget(
        "40:00",
        style: AppTextStyle.title
            .copyWith(fontSize: 35, color: AppColors.appMainColor),
      );

  _endSession() => PrimaryButtonWidget(
        text: "End Sesssion".tr,
        onClick: () {},
      );

  _runningTitle() => AppTextWidget("Running Session".tr, style: AppTextStyle.title,);

  Widget _todayGroups() {
    return Center(
      child: AppTextWidget("today groups"),
    );
  }

  _viewDetails() => AppTextWidget("View Details" , style: AppTextStyle.title.copyWith(
    color: AppColors.appMainColor,
    decoration: TextDecoration.underline
  ));
}
