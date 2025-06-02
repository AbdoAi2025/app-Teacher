import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/cancel_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/done_icon_widget.dart';
import '../../widgets/edit_icon_widget.dart';
import '../../widgets/sessions/end_session_button_widget.dart';
import '../../widgets/sessions/timer_counter_widget.dart';
import 'session_details_controller.dart';
import 'states/session_details_state.dart';
import 'states/update_session_activities_state.dart';
import 'widgets/student_activity_item_widget.dart';

class SessionDetailsScreen extends StatefulWidget {
  const SessionDetailsScreen({super.key});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  bool isEditable = false;

  final SessionDetailsController controller =
      Get.put(SessionDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Session Details".tr,
            actions: [_actions()]),
        body: RefreshIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _content(),
          ),
        ));
  }

  _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case SessionDetailsStateLoading():
          return _showLoading();
          break;
        case SessionDetailsStateNotFound():
          return _showNotFound();
          break;
        case SessionDetailsStateInvalidArgs():
          return _showInvalidArgs();
          break;
        case SessionDetailsStateError():
          return _showError(state);
          break;
        case SessionDetailsStateSuccess():
          return _showDetails(state.uiState);
        default:
          return _showNotFound();
      }
    });
  }

  Widget _showLoading() {
    return LoadingWidget();
  }

  _showNotFound() {
    return ErrorWidget("Session Not Found".tr);
  }

  _showInvalidArgs() {
    return ErrorWidget("Invalid Args".tr);
  }

  _showError(SessionDetailsStateError state) {
    return ErrorWidget(state.exception.toString() ?? "");
  }

  _showDetails(SessionDetailsUiState uiState) {
    return Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _activities(uiState.activities)),
          _sessionInfoSection(uiState),
          if (uiState.isSessionActive()) _enSessionButton(uiState)
        ]);
  }

  _sessionInfoSection(SessionDetailsUiState uiState) {
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.getColoredBackgroundRounded(
          12, AppColors.sectionBackgroundColor),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _groupInfoTitle(uiState),
          _sessionStartData(uiState),
          _sessionStatus(uiState),
        ],
      ),
    );
  }

  _groupInfoTitle(SessionDetailsUiState uiState) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Group:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          uiState.groupName,
          style: AppTextStyle.value,
        )
      ],
    );
  }

  _sessionStartData(SessionDetailsUiState uiState) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Start Date:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          AppDateUtils.parsDateToString(
              uiState.sessionCreatedAt, "yyy-MM-dd HH:mm"),
          style: AppTextStyle.value,
        ),

        if(uiState.isSessionActive())
        TimerCounterWidget(
          dateTime: uiState.sessionCreatedAt,
          textStyle:AppTextStyle.title
              .copyWith(fontSize: 25,
              color: AppColors.appMainColor),
        )
      ],
    );
  }

  _sessionStatus(SessionDetailsUiState uiState) {
    var statusColor = uiState.sessionStatus == SessionStatus.active
        ? AppColors.activeColor
        : AppColors.inactiveColor;

    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Session Status".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          uiState.sessionStatus.label.tr,
          style: AppTextStyle.label.copyWith(color: statusColor),
        )
      ],
    );
  }

  _activities(List<SessionActivityItemUiState> activities) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _activityItem(activities[index]);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        itemCount: activities.length);
  }

  _activityItem(SessionActivityItemUiState uiState) {
    return StudentActivityItemWidget(
      key: UniqueKey(),
      uiState: uiState,
      isEditable: isEditable,
      onChanged: (uiState) {
        controller.onItemChanged(uiState);
      },
      onDone: (uiState) {
        onDoneItem(uiState);
      },
    );
  }

  void onRefresh() {
    controller.onRefresh();
  }

  _actions() {
    if (isEditable) {
      return Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [_doneIcon(), _cancelIcon()],
      );
    }

    return _editIcon();
  }

  _editIcon() {
    return EditIconWidget(
      onClick: onEditClick,
    );
  }

  onEditClick() {
    setState(() {
      isEditable = true;
    });
  }

  _doneIcon() {
    return DoneIconWidget(
      onClick: onDoneClick,
    );
  }

  onDoneClick() {
    controller.onDoneAll().listen((state) {
      hideDialogLoading();
      onUpdateResultHandler(state);

      if (state is UpdateSessionActivitiesStateSuccess) {
        setState(() {
          isEditable = false;
        });
      }
    });
  }

  _cancelIcon() {
    return CancelIconWidget(
      onClick: onCancelClick,
    );
  }

  onCancelClick() {
    setState(() {
      isEditable = false;
    });
  }

  void onDoneItem(SessionActivityItemUiState uiState) {
    controller.onItemDone(uiState).listen((state) {
      hideDialogLoading();
      onUpdateResultHandler(state);
    });
  }

  void onUpdateResultHandler(UpdateSessionActivitiesState state) {
    switch (state) {
      case UpdateSessionActivitiesStateLoading():
        showDialogLoading();
        break;
      case UpdateSessionActivitiesStateSuccess():
        break;
      case UpdateSessionActivitiesStateError():
        showSuccessMessage(state.exception.toString());
    }
  }

  _enSessionButton(SessionDetailsUiState uiState) {
    return SizedBox(
      width: double.infinity,
      child: EndSessionButtonWidget(
        sessionId: uiState.id,
        onSessionEnded: () {
          onRefresh();
        },
      ),
    );
  }
}
