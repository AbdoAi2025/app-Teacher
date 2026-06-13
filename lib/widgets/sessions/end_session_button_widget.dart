import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/info_chip_widget.dart';

import '../../domain/states/end_session_state.dart';
import '../../domain/usecases/end_session_use_case.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../utils/message_utils.dart';
import '../dialog_loading_widget.dart';
import '../primary_button_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class EndSessionButtonWidget extends StatelessWidget {

  final String sessionId;
  final String groupId;
  final Function() onSessionEnded;

  const EndSessionButtonWidget({super.key, required this.sessionId, required this.groupId, required this.onSessionEnded});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>   onEndSession(),
      child: content(context),
    );

    return InfoChipWidget(
      icon: Icons.stop,
      color: AppColors.color_E75260,
      size: 30,
    );

    return PrimaryButtonWidget(
      text: AppStringsKeys.endSession.tr,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      textStyle: AppTextStyle.value.copyWith(color: AppColors.white , fontSize: 12),
      onClick: () {
        onEndSession();
      },
    );
  }

  void onEndSession( ) {
    endSession(sessionId).listen((event) {
      hideDialogLoading();
      switch (event) {
        case EndSessionStateLoading():
          showDialogLoading();
          break;
        case EndSessionStateSuccess():
          onSessionEnded();
          break;
        case EndSessionStateError():
          showErrorMessage(event.exception.toString());
          break;
      }
    });
  }

  Stream<EndSessionState> endSession(String sessionId) async* {
    yield EndSessionStateLoading();
    var result = await EndSessionUseCase().execute(sessionId, groupId);
    if(result.isSuccess){
      yield EndSessionStateSuccess(result.data ?? "");
    }else{
      yield EndSessionStateError(result.error);
    }
  }

  content(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.color_E75260.withValues(alpha: .1),
      child: Icon(Icons.stop , color: AppColors.color_E75260),
    );
  }
}
