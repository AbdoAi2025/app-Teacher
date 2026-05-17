import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_group_details_response.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/states/group_details_ui_state.dart';
import 'package:teacher_app/screens/home/states/running_session_item_ui_state.dart';
import 'package:teacher_app/screens/session_details/args/session_details_args_model.dart';
import 'package:teacher_app/screens/student_details/args/student_details_arg_model.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/day_info_chip_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/sessions/running_session_item_widget.dart';
import 'package:teacher_app/widgets/sessions/session_item/session_item_widget.dart';
import 'package:teacher_app/widgets/sessions/start_session_button_widget.dart';
import '../../bottomsheets/setting_bottom_sheet.dart';
import '../../widgets/back_icon_widget.dart';
import '../../themes/txt_styles.dart';
import '../../utils/LogUtils.dart';
import '../../widgets/groups/states/group_student_item_ui_state.dart';
import '../../widgets/sessions/sessions_empty_widget.dart';
import '../../widgets/students/students_group_list_search_widget.dart';
import '../group_edit/args/edit_group_args_model.dart';
import 'group_details_controller.dart';
import 'states/group_details_state.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends LifecycleWidgetState<GroupDetailsScreen> {

  final GroupDetailsController controller = Get.put(GroupDetailsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.appBarBackgroundColor,
        body: SafeArea(
          child: Obx(() {
            final state = controller.state.value;
            switch (state) {
              case GroupDetailsStateLoading():
                return Column(children: [_header(null), const Expanded(child: Center(child: LoadingWidget()))]);
              case GroupDetailsStateInvalidArgs():
                return Column(children: [_header(null), const Expanded(child: Center(child: Text("Invalid Args")))]);
              case GroupDetailsStateSuccess():
                return _successBody(state);
              case GroupDetailsStateError():
                return Column(children: [_header(null), Expanded(child: Center(child: Text(state.exception.toString())))]);
            }
          }),
        ),
      ),
    );
  }

  Widget _header(GroupDetailsUiState? uiState) {
    final hasTimings = uiState != null && uiState.timings.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.color_E2E2E2, width: 0.8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 8, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackIconWidget(),
                const SizedBox(width: 4),
                Expanded(
                  child: uiState != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppTextWidget(
                              uiState.groupName.isNotEmpty
                                  ? uiState.groupName
                                  : "Group Details".tr,
                              style: AppTextStyle.appToolBarTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (uiState.grade.isNotEmpty)
                              AppTextWidget(uiState.grade, style: AppTextStyle.subTitle),
                          ],
                        )
                      : AppTextWidget("Group Details".tr, style: AppTextStyle.appToolBarTitle),
                ),
                if (uiState != null) _settingsIconButton(uiState),
              ],
            ),
          ),
          // ── Timings ────────────────────────────────────────────
          if (hasTimings) _timingsInHeader(uiState),
        ],
      ),
    );
  }

  Widget _timingsInHeader(GroupDetailsUiState uiState) {
    final timings = uiState.timings;
    final first = timings.first;
    final rest = timings.skip(1).toList();

    if (rest.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: _timing(first, uiState),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        minTileHeight: 40,
        title: _timing(first, uiState),
        children: rest.map((t) => Padding(
          padding: EdgeInsetsDirectional.only(bottom: 8 , end: 40),
          child: _timing(t, uiState),
        )).toList(),
      ),
    );
  }

  Widget _successBody(GroupDetailsStateSuccess state) {
    final uiState = state.uiState;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(uiState),
        if (uiState.activeSession != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _sessionSection(uiState),
          ),
        const SizedBox(height: 4),
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: AppColors.appMainColor,
          indicatorWeight: 2.5,
          dividerColor: AppColors.color_E2E2E2,
          labelColor: AppColors.appMainColor,
          unselectedLabelColor: AppColors.textSecondaryColor,
          labelStyle: AppTextStyle.label.copyWith(fontSize: 14),
          unselectedLabelStyle: AppTextStyle.label.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: [
            Tab(text: "${"Students".tr} (${uiState.students.length})"),
            Obx(() => Tab(text: "${"Sessions".tr} (${controller.sessions.length})")),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              _studentsTab(uiState),
              _sessionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Active Session ───────────────────────────────────────────────────────

  Widget _sessionSection(GroupDetailsUiState uiState) {
    final activeSession = uiState.activeSession;
    if (activeSession == null) return const SizedBox.shrink();
    appLog("GroupDetailsScreen _sessionSection activeSession:$activeSession");
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.getColoredBackgroundRounded(
        16,
        AppColors.color_008E73.withValues(alpha: .1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: RunningSessionItemWidget(
        item: RunningSessionItemUiState(
          id: activeSession.sessionId ?? "",
          date: AppDateUtils.parseStringToDateTime(activeSession.startDate ?? ""),
        ),
        onSessionEnded: () => controller.reload(),
      ),
    );
  }


  Widget _timing(GroupDetailsTiming t, GroupDetailsUiState uiState) {
    final day = "${AppDateUtils.getDayName(t.day ?? -1).tr} : ${t.timeFrom ?? ''} - ${t.timeTo ?? ''}";
    return Row(
      spacing: 10,
      children: [
        Expanded(child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DayInfoChipWidget(text: day),
          ],
        )),
        if (t.id != null && !uiState.hasActiveSession)
          _startSession(t.id!, uiState),
      ],
    );
  }

  Widget _startSession(int timingId, GroupDetailsUiState uiState) => Center(
    child: StartSessionButtonWidget(
      timingId: timingId.toString(),
      studentsCount: uiState.students.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      textStyle: AppTextStyle.value.copyWith(color: AppColors.white, fontSize: 12),
      onSessionStarted: () => controller.reload(),
    ),
  );

  // ─── Students Tab ─────────────────────────────────────────────────────────

  Widget _studentsTab(GroupDetailsUiState uiState) {
    return StudentsGroupListSearchWidget(
      query: "",
      students: uiState.students,
      onStudentItemClick: onStudentItemClick,
      onAddStudents: onEditClick,
    );
  }

  // ─── Sessions Tab ─────────────────────────────────────────────────────────

  Widget _sessionsTab() {
    return Obx(() {
      if (controller.sessionsLoading.value) {
        return const Center(child: LoadingWidget());
      }
      final sessions = controller.sessions;
      if (sessions.isEmpty) return const SessionsEmptyWidget();

      return RefreshIndicator(
        onRefresh: controller.loadSessions,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) => SessionItemWidget(
            uiState: sessions[index],
            onClick: (s) => AppNavigator.navigateToSessionDetails(
              SessionDetailsArgsModel(s.id),
            ),
          ),
        ),
      );
    });
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  Widget _settingsIconButton(GroupDetailsUiState uiState) {
    return IconButton(
      icon: Icon(Icons.settings, color: AppColors.appMainColor),
      onPressed: () => _showSettingsBottomSheet(uiState),
    );
  }

  void _showSettingsBottomSheet(GroupDetailsUiState uiState) {
    SettingBottomSheet.show(
      context: context,
      itemsModels: [
        SettingItemModel.editItem(onEditClick),
        SettingItemModel.upgradeItem(onUpgradeClick),
        SettingItemModel.deleteItem(() => onDeleteClick(uiState)),
      ],
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  onEditClick() async {
    final uiState = controller.getGroupDetailsUiState();
    final args = EditGroupArgsModel(
      groupId: uiState?.groupId ?? "",
      groupName: uiState?.groupName ?? "",
      gradeName: uiState?.grade ?? "",
      gradeId: uiState?.gradeId ?? 0,
      timings: uiState?.timings ?? [],
      students: uiState?.students ?? List.empty(),
    );
    await AppNavigator.navigateToEditGroup(args);
  }

  onUpgradeClick() async {
    final uiState = controller.getGroupDetailsUiState();
    final args = EditGroupArgsModel(
      groupId: uiState?.groupId ?? "",
      groupName: uiState?.groupName ?? "",
      gradeName: uiState?.grade ?? "",
      gradeId: uiState?.gradeId ?? 0,
      timings: uiState?.timings ?? [],
      students: uiState?.students ?? List.empty(),
    );
    final result = await AppNavigator.navigateToUpgradeGroup(args);
    if (result == true) controller.reload();
  }

  onDeleteClick(GroupDetailsUiState uiState) {
    showConfirmationMessage(
      "${"Are you sure to delete ?".tr} ${uiState.groupName}",
      () {
        showDialogLoading();
        controller.deleteGroup(uiState).listen((event) {
          hideDialogLoading();
          if (event.isSuccess) {
            Get.back();
            return;
          }
          if (event.isError) {
            showErrorMessage(event.error?.toString());
          }
        });
      },
    );
  }

  void onStudentItemClick(GroupStudentItemUiState uiState) {
    AppNavigator.navigateToStudentDetails(StudentDetailsArgModel(id: uiState.id));
  }

  @override
  void onResumedNavigatedBack() {
    controller.onResume();
  }
}