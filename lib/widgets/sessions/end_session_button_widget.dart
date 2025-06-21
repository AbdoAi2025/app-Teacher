import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../domain/states/end_session_state.dart';
import '../../domain/usecases/end_session_use_case.dart';
import '../../utils/message_utils.dart';
import '../dialog_loading_widget.dart';
import '../primary_button_widget.dart';

class EndSessionButtonWidget extends StatelessWidget {

  final String sessionId;
  final Function() onSessionEnded;

  const EndSessionButtonWidget({super.key, required this.sessionId, required this.onSessionEnded});

  @override
  Widget build(BuildContext context) {
    return PrimaryButtonWidget(
      text: "End Session".tr,
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
