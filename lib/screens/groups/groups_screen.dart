import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../utils/message_utils.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/close_icon_widget.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
import '../../widgets/search_icon_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/sort_icon_widget.dart';
import '../group_details/args/group_details_arg_model.dart';
import 'groups_controller.dart';
import 'groups_state.dart';

class GroupsScreen extends StatefulWidget {


  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {

  GroupsController controller = Get.put(GroupsController());
  bool searchState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),//AppToolbarWidget.appBar(title: "Groups".tr, hasLeading: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GestureDetector(
              onTapDown: (v){KeyboardUtils.hideKeyboard(context);},
              child: _content()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppNavigator.navigateToCreateGroup();
          },
          backgroundColor: AppColors.appMainColor,
          child: Icon(Icons.add, color: Colors.white),
        )
    );
  }

  _appBar() {
    if (searchState) {
      return _searchAppBar();
    }
    return _appBarWithActions();
  }

  _appBarWithActions() =>AppToolbarWidget.appBar(
      title: "Groups".tr,
      hasLeading: false,
      actions: [
        _searchIcon(),
        _sortIcon(),
      ]
  );

  _searchAppBar() => AppToolbarWidget.appBar(
      titleWidget: SearchTextField(
        controller: TextEditingController(),
        onChanged: controller.onSearchChanged,
      ),
      hasLeading: false,
      actions: [
        InkWell(
            onTap: () {
              setState(() {
                searchState = false;
                controller.onCloseSearch();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CloseIconWidget(),
            ))
      ]
  );

  _searchIcon() =>  InkWell(
      onTap: () {
        setState(() {
          searchState = true;
        });
      },
      child: SearchIconWidget()
  );

  _sortIcon() =>  InkWell(
      onTap: onSortClick,
      child: SortIconWidget()
  );

 Widget _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case GroupsStateLoading():
          return Center(child: LoadingWidget());
        case GroupsStateSuccess():
          return _groupsList(state);
        case GroupsStateError():
          return Center(child: AppErrorWidget(message: state.message, onRetry: refresh,));
      }
    });
  }

  refresh() {
    controller.refreshGroups();
  }

  _groupsList(GroupsStateSuccess state) {
    var items = state.uiStates;
    if (items.isEmpty) {
      return _emptyView();
    }
    return RefreshIndicator(

      onRefresh: () async {
        controller.refreshGroups();
      },

      child: ListView.separated(itemBuilder: (context, index) {

        var uiState = items[index];

        if (uiState is GroupItemTitleUiState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextWidget(uiState.title, style: AppTextStyle.title,),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GroupItemWidget(
            uiState: uiState,
            onClick: onGroupItemClick,
            onDeleteClick: onDeleteClick,
          ),
        );
      },
          separatorBuilder: (context, index) => SizedBox(height: 15,),
          itemCount: items.length),
    );
  }

  onGroupItemClick(GroupItemUiState p1) {
    AppNavigator.navigateToGroupDetails(GroupDetailsArgModel(id: p1.groupId));
  }

  _emptyView() {
    return Center(
        child: EmptyViewWidget(message: "No Groups Found".tr));
  }

  onDeleteClick(GroupItemUiState uiState) {
    showConfirmationMessage(
        "${"Are you sure to delete ?".tr} ${uiState.groupName}", () {
      showDialogLoading();
      controller.deleteGroup(uiState).listen((event) {
        hideDialogLoading();
        if (event.isSuccess) {
          return;
        }
        if (event.isError) {
          showErrorMessage(event.error?.toString());
        }
      },);
    });
  }

  void onSortClick() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextWidget("Sort".tr),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    InkWell(onTap: onSortByDayClick , child: AppTextWidget("By Day".tr)),
                    InkWell(onTap: onSortByGradeClick ,  child: AppTextWidget("By grade".tr)),
                    InkWell(onTap: onSortResetClick ,  child: AppTextWidget("Reset".tr)),
                  ],
                ),
              ),
            ],
          ),
        );
      },);
  }

  void onSortByDayClick() {
    Get.back();
    controller.sortByDay();
  }

  void onSortByGradeClick() {
    Get.back();
    controller.sortByGrade();
  }

  void onSortResetClick() {
    Get.back();
    controller.resetSort();
  }
}
