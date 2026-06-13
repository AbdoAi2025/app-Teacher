import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import '../../screens/group_details/states/group_details_student_item_ui_state.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../utils/app_background_styles.dart';
import '../app_txt_widget.dart';
import '../groups/states/group_student_item_ui_state.dart';
import 'students_group_list_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class StudentsGroupListSearchWidget extends StatefulWidget {
  final String query;
  final List<GroupDetailsStudentItemUiState> students;
  final Function(GroupStudentItemUiState) onStudentItemClick;
  final VoidCallback? onAddStudents;

  const StudentsGroupListSearchWidget({
    super.key,
    required this.query,
    required this.students,
    required this.onStudentItemClick,
    this.onAddStudents,
  });

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hideKeyboard(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 15),
        child: Column(
          spacing: 10,
          children: [
            _searchBar(),
            Expanded(
              child: StudentsGroupListWidget(
                students: filteredItems,
                physics: const AlwaysScrollableScrollPhysics(),
                onStudentItemClick: widget.onStudentItemClick,
                onAddStudents: widget.onAddStudents,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: AppBackgroundStyle.backgroundWithShadow(),
      // decoration: BoxDecoration(
      //   color: AppColors.color_F5F5F5,
      //   borderRadius: BorderRadius.circular(14),
      // ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        style: AppTextStyle.value,
        decoration: InputDecoration(
          hintText: AppStringsKeys.search.tr,
          hintStyle: AppTextStyle.value.copyWith(color: AppColors.textSecondaryColor),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondaryColor,
            // size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: AppColors.textSecondaryColor, size: 18),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _countLabel() {
    final count = filteredItems.length;
    final total = students.length;
    final label = _controller.text.isEmpty
        ? "$count ${AppStringsKeys.students.tr}"
        : "$count / $total ${AppStringsKeys.students.tr}";
    return AppTextWidget(label, style: AppTextStyle.small);
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => filteredItems = students);
  }

  void _onSearchChanged(String? query) {
    if (query == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredItems = query.isEmpty
            ? students
            : students
                .where((item) =>
                    item.studentName.toLowerCase().contains(query.toLowerCase()))
                .toList();
      });
    });
  }

  void _hideKeyboard() => KeyboardUtils.hideKeyboard(context);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }
}