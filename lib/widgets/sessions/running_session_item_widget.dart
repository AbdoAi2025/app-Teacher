import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/sessions/end_session_button_widget.dart';
import '../../navigation/app_navigator.dart';
import '../../screens/home/states/running_session_item_ui_state.dart';
import '../../screens/session_details/args/session_details_args_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class RunningSessionItemWidget extends StatefulWidget {
  final RunningSessionItemUiState item;
  final Function() onSessionEnded;

  const RunningSessionItemWidget(
      {super.key, required this.item, required this.onSessionEnded});

  @override
  State<RunningSessionItemWidget> createState() =>
      _RunningSessionItemWidgetState();
}

class _RunningSessionItemWidgetState extends State<RunningSessionItemWidget> {
  late RunningSessionItemUiState item = widget.item;

  late Timer _timer;
  String _elapsed = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final startTime = item.date;
    if (startTime != null) {
      final now = DateTime.now();
      final isPast = now.isAfter(startTime);
      final diff = now.difference(startTime);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      final seconds = diff.inSeconds % 60;
      setState(() {
        String hoursFormatted = hours.toString().padLeft(2, '0');
        String minutesFormatted = minutes.toString().padLeft(2, '0');
        String secondsFormatted = seconds.toString().padLeft(2, '0');
        _elapsed = "$hoursFormatted:$minutesFormatted:$secondsFormatted";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var  groupName =  item.groupName ?? "";
    return InkWell(
      onTap: () =>  onViewSessionDetails(item),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Row(
            children: [Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              _title(),
                if (groupName.isNotEmpty) _groupName(groupName),
              _timerView(),
            ],)), _endSession(item)],
          ),

          // _viewDetails(item)
        ],
      ),
    );
  }

  _timerView() => AppTextWidget(
        _elapsed,
        style: AppTextStyle.title
            .copyWith(fontSize: 16, color: AppColors.appMainColor),
      );

  _endSession(RunningSessionItemUiState item) => EndSessionButtonWidget(
        sessionId: item.id,
        onSessionEnded: () {
          widget.onSessionEnded();
        },
      );

  _viewDetails(RunningSessionItemUiState uiState) => InkWell(
        onTap: () {
          onViewSessionDetails(uiState);
        },
        child: AppTextWidget(AppStringsKeys.viewDetails.tr,
            style: AppTextStyle.title.copyWith(
                color: AppColors.appMainColor,
                decoration: TextDecoration.underline)),
      );

  void onViewSessionDetails(RunningSessionItemUiState uiState) {
    AppNavigator.navigateToSessionDetails(SessionDetailsArgsModel(uiState.id));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _groupName(String groupName) {
    return AppTextWidget(
      groupName,
      style: AppTextStyle.value,
      maxLines: 1,
      fontSize: 12,
    );
  }

  Widget _title() {
    return AppTextWidget(
      AppStringsKeys.sessionInProgress.tr,
      style: AppTextStyle.title.copyWith(color: AppColors.green),
    );
  }
}
