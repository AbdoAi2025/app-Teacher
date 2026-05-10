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

class EndSessionButtonWidget extends StatelessWidget {

  final String sessionId;
  final Function() onSessionEnded;

  const EndSessionButtonWidget({super.key, required this.sessionId, required this.onSessionEnded});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () =>   onEndSession(),
      child: CircleAvatar(
        backgroundColor: AppColors.color_E75260.withValues(alpha: .1),
        child: Icon(Icons.stop , color: AppColors.color_E75260),
      ),
    );

    return InfoChipWidget(
      icon: Icons.stop,
      color: AppColors.color_E75260,
      size: 30,
    );

    return PrimaryButtonWidget(
      text: "End Session".tr,
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
    var result = await EndSessionUseCase().execute(sessionId);
    if(result.isSuccess){
      yield EndSessionStateSuccess(result.data ?? "");
    }else{
      yield EndSessionStateError(result.error);
    }
  }
}
