import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Groups".tr),
        body: _content(),
        floatingActionButton:  FloatingActionButton(
          onPressed: () {
            AppNavigator.navigateToCreateGroup(context);
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white),
        )
    );
  }

  _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case GroupsStateLoading():
          return Center(child: LoadingWidget());
        case GroupsStateSuccess():
          return _groupsList(state);
        case GroupsStateError():
          return Center(
              child: AppErrorWidget(message: state.message, onRetry: refresh,));
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
      onRefresh: () async{
        controller.refreshGroups();
      },
      child: ListView.separated(
          itemBuilder: (context, index) => GroupItemWidget(
            uiState: items[index],
            onClick: onGroupItemClick,
            onDeleteClick: onDeleteClick,
            onEditClick: onEditClick,
          ),
          separatorBuilder: (context, index) => SizedBox(height: 5,),
          itemCount: items.length),
    );
  }

  onGroupItemClick(StudentItemUiState p1) {
      AppNavigator.navigateToGroupDetails(GroupDetailsArgModel(id: p1.groupId));
  }

  _emptyView() {
    return Center(
        child: Text("لا توجد مجموعات متاحة",
            style: TextStyle(fontSize: 18)));
  }

  onDeleteClick(StudentItemUiState p1) {

  }

  onEditClick(StudentItemUiState p1) {

  }
}
