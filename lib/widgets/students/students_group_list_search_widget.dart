import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../../screens/group_details/states/group_details_student_item_ui_state.dart';
import '../../themes/txt_styles.dart';
import '../app_text_field_widget.dart';
import '../app_txt_widget.dart';
import '../groups/states/group_student_item_ui_state.dart';
import 'students_group_list_widget.dart';

class StudentsGroupListSearchWidget extends StatefulWidget {
  final String query;
  final List<GroupDetailsStudentItemUiState> students;
  final Function(GroupStudentItemUiState) onStudentItemClick;

  const StudentsGroupListSearchWidget(
      {super.key,
      required this.query,
      required this.students,
      required this.onStudentItemClick});

  @override
  State<StudentsGroupListSearchWidget> createState() =>
      _StudentsGroupListSearchWidgetState();
}

class _StudentsGroupListSearchWidgetState
    extends State<StudentsGroupListSearchWidget> {
  late List<GroupDetailsStudentItemUiState> students = widget.students;
  late final TextEditingController _controller =
      TextEditingController(text: widget.query);
  Timer? _debounce;

  late List<GroupDetailsStudentItemUiState> filteredItems = students;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appLog(
        "_StudentsGroupListSearchWidgetState build filteredItems :${filteredItems.length}");

    return Container(
        // height: Get.height * .90,
        // width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          children: [
            _allStudentsTitle(),
            _searchField(),
            Expanded(
                child: GestureDetector(
              onTapDown: (details) =>   hideKeyboard(),
              child: StudentsGroupListWidget(
                students: filteredItems,
                physics: AlwaysScrollableScrollPhysics(),
                onStudentItemClick: (item) {
                  widget.onStudentItemClick(item);
                },
              ),
            )),
          ],
        ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  _allStudentsTitle() => AppTextWidget(
        "All students".tr,
        style: AppTextStyle.title,
      );

  _searchField() {
    return AppTextFieldWidget(
      hint: "Search students...".tr,
      onChanged: _onSearchChanged,
      controller: _controller,
      textInputAction: TextInputAction.search,
    );
  }

  void _onSearchChanged(String? query) {
    appLog("_onSearchChanged query:$query ");

    if (query == null) return;

    // Cancel previous timer if still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        appLog("_onSearchChanged search query:$query ");

        appLog("_onSearchChanged filteredItems :${filteredItems.length}");
        filteredItems = students
            .where((item) =>
                    item.studentName.toLowerCase().contains(query.toLowerCase())
                // || item.studentParentPhone.contains(query.toLowerCase())
                )
            .toList();

        appLog(
            "_onSearchChanged searched filteredItems :${filteredItems.length}");
      });
    });
  }

  void hideKeyboard() {
    KeyboardUtils.hideKeyboard(context);
  }
}
