import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../domain/states/start_session_state.dart';
import '../../domain/usecases/start_session_use_case.dart';
import '../../utils/message_utils.dart';
import '../dialog_loading_widget.dart';
import '../primary_button_widget.dart';

class StartSessionButtonWidget extends StatelessWidget{

  final String groupId;
  final String name;
  final Function() onSessionStarted;
  const StartSessionButtonWidget({super.key, required this.groupId,required this.name, required this.onSessionStarted});


  @override
  Widget build(BuildContext context) {
   return PrimaryButtonWidget(
      text: "Start session".tr,
      onClick: () {
        onStartSession();
      },
    );
  }

  void onStartSession() {
    startSession().listen((event) {
      hideDialogLoading();
      switch (event) {
        case StartSessionStateLoading():
          showDialogLoading();
          break;
        case StartSessionStateSuccess():
          onSessionStarted();
          break;
        case StartSessionStateError():
          ShowErrorMessage(event.exception.toString());
          break;
      }
    });
  }

  Stream<StartSessionState> startSession() async* {
    yield StartSessionStateLoading();
    var result = await StartSessionUseCase().execute(name, groupId);
    if(result.isSuccess){
      yield StartSessionStateSuccess(result.data ?? "");
    }else{
      yield StartSessionStateError(result.error);
    }
  }

}
