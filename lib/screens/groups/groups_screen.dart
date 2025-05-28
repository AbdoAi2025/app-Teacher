import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/groups/group_item_widget.dart';
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
        body: _content()
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
          itemBuilder: (context, index) => GroupItemWidget(uiState: items[index], onClick: onGroupItemClick,),
          separatorBuilder: (context, index) => SizedBox(height: 15,),
          itemCount: items.length),
    );
  }

  onGroupItemClick(GroupItemUiState p1) {

  }

  _emptyView() {
    return Center(
        child: Text("لا توجد مجموعات متاحة",
            style: TextStyle(fontSize: 18)));
  }
}
