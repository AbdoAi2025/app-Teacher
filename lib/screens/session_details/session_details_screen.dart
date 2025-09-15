import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/presentation/bottom_sheets/students_list_selections_bottom_sheet.dart';
import 'package:teacher_app/screens/create_group/students_selection/states/student_selection_item_ui_state.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_visibility_widget.dart';
import 'package:teacher_app/widgets/cancel_icon_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../domain/events/sessions_events.dart';
import '../../utils/LogUtils.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/close_icon_widget.dart';
import '../../widgets/done_icon_widget.dart';
import '../../widgets/edit_icon_widget.dart';
import '../../widgets/lifecycle_widget.dart';
import '../../widgets/search_icon_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/sessions/end_session_button_widget.dart';
import '../../widgets/sessions/session_info/session_info_widget.dart';
import 'session_details_controller.dart';
import 'states/session_details_state.dart';
import 'states/update_session_activities_state.dart';
import 'widgets/student_activity_item_widget.dart';

class SessionDetailsScreen extends StatefulWidget {
  const SessionDetailsScreen({super.key});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends LifecycleWidgetState<SessionDetailsScreen> {

  bool searchState = false;
  bool isEditable = false;

  final SessionDetailsController controller = Get.put(SessionDetailsController());

  @override
  void initState() {
    super.initState();
    controller.eventListeners.add(_onSessionEventUpdated);
  }

  void _onSessionEventUpdated(SessionsEventsState event) {
    if(event is SessionsEventsStateDeleted){
       onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        resizeToAvoidBottomInset: false,
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
          Expanded(child: _activities(uiState, uiState.isSessionActive())),
          _sessionInfoSection(uiState),
          if (uiState.isSessionActive()) _enSessionButton(uiState)
        ]);
  }

  _sessionInfoSection(SessionDetailsUiState uiState) {
    return SessionInfoWidget(
      uiState: uiState,
      onAddStudentToSession: () =>onAddStudentToSessionClick(uiState),
    );
  }

  _activities(SessionDetailsUiState uiState, bool isActive) {
    List<SessionActivityItemUiState> activities = uiState.activities;

    return ListView.separated(
        itemBuilder: (context, index) {
          return _activityItem(uiState, activities[index], isActive);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        itemCount: activities.length);
  }

  _activityItem(SessionDetailsUiState sessionDetailsUiState,
      SessionActivityItemUiState uiState, bool isActive) {
    return StudentActivityItemWidget(
      key: UniqueKey(),
      uiState: uiState,
      sessionDetailsUiState: sessionDetailsUiState,
      isActive: isActive,
      isEditable: isEditable,
      onDeleteClick: onDeleteReportClick,
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
    // controller.onDoneAll().listen((state) {
    //   hideDialogLoading();
    //   onUpdateResultHandler(state);
    //
    //   if (state is UpdateSessionActivitiesStateSuccess) {
    //     setState(() {
    //       isEditable = false;
    //     });
    //   }
    // });
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



  _appBar() {
    if (searchState) {
      return AppToolbarWidget.appBar(
          titleWidget: SearchTextField(
            controller: TextEditingController(),
            onChanged: onSearchChanged,
          ),
          actions: [_closeIcon()]);
    }
    return AppToolbarWidget.appBar(
        title: "Session Details".tr, actions: [
          _deleteIcon(),
          _searchIcon()]);
  }

  onSearchChanged(String? query) {
    if (query == null) return;
    controller.onSearchChanged(query);
  }

  Widget _searchIcon() {
    return InkWell(
        onTap: () {
          setState(() {
            searchState = true;
          });
        },
        child: SearchIconWidget());
  }

  Widget _closeIcon() {
    return InkWell(
        onTap: () {
          setState(() {
            searchState = false;
            controller.onSearchClosed();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: CloseIconWidget(),
        ));
  }

  @override
  void onResumedNavigatedBack() {
    appLog("SessionDetailsScreen _onVisible");
    controller.onResume();
  }

  onBack(){
    appLog("SessionDetailsScreen onBack");
    AppNavigator.back();
  }

  onAddStudentToSessionClick(SessionDetailsUiState uiState) {
    controller.onAddStudentToSessionClick(uiState);
    var bottomSheet = StudentsListSelectionsBottomSheet(
        studentsSelectionState : controller.studentsSelectionState,
        onSaveClick: (items) { onSessionStudentsSelected(uiState, items);});
    bottomSheet.show(context);
  }

  void onSessionStudentsSelected(SessionDetailsUiState uiState , List<StudentSelectionItemUiState> items) {
      showConfirmationMessage("Are you sure you want to add students to this session?".tr, (){
        showDialogLoading();
        controller.addStudentToSession(uiState ,  items )
        .listen((result){
          hideDialogLoading();
          Get.back();
          controller.onRefresh();
        });
      });
  }

  _deleteIcon() => DeleteIconWidget(onClick: () {
     showConfirmationMessage("Are you sure you want to delete the session".tr, (){
       showDialogLoading();
       controller.deleteSession().listen((result){
         appLog("_deleteIcon result : ${result.toString()}");
         hideDialogLoading();
         if(result.isSuccess){
           AppNavigator.back();
         }else
           if(result.isError) {
           showErrorMessage(result.error?.toString());
         }
       });
     });
  });

  @override
  void dispose() {
    super.dispose();
    appLog("dispose");
    appLog("controller.eventListeners.length : ${controller.eventListeners.length}");
    controller.eventListeners.remove(_onSessionEventUpdated);
  }


  onDeleteReportClick(SessionActivityItemUiState uiState) {
    showDialogLoading();
    controller.deleteStudentActivity(uiState).listen((result){
      hideDialogLoading();

      if(result.isError) {
        showErrorMessage(result.error?.toString());
      }
    });


  }
}
