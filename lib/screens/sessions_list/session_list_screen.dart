import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/localization/localArabic.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/session_details/args/session_details_args_model.dart';
import 'package:teacher_app/widgets/app_visibility_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/sessions/session_item/session_item_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import 'session_lisit_controller.dart';
import 'states/session_item_ui_state.dart';
import 'states/session_lisit_state.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends LifecycleWidgetState<SessionListScreen> {
  bool isEditable = false;

  final SessionListController controller = Get.put(SessionListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar(title: "Sessions".tr),
        body: RefreshIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _content(),
            ),
          ),
        ));
  }

  _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case SessionListStateLoading():
          return _showLoading();
        case SessionListStateError():
          return _showError(state);
        case SessionListStateSuccess():
          return _showDetails(state.uiStates);
        default:
          return _showNotFound();
      }
    });
  }

  Widget _showLoading() {
    return Center(child: LoadingWidget());
  }

  _showNotFound() {
    return ErrorWidget("Session Not Found".tr);
  }

  _showInvalidArgs() {
    return ErrorWidget("Invalid Args".tr);
  }

  _showError(SessionListStateError state) {
    return ErrorWidget(state.exception.toString() ?? "");
  }

  _showDetails(List<SessionItemUiState> uiState) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SessionItemWidget(uiState: uiState[index], onClick: onSessionClick);
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      itemCount: uiState.length,
    );
  }

  void onRefresh() {
    controller.onRefresh();
  }

  onSessionClick(SessionItemUiState p1) {
    AppNavigator.navigateToSessionDetails(SessionDetailsArgsModel(p1.id , controller.getStudentId()));
  }

  @override
  void onResumedNavigatedBack() {
    controller.onResume();
  }
}
