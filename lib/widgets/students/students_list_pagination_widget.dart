import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/students/student_item_widget.dart';
import '../../screens/students_list/states/student_item_ui_state.dart';
import '../pagination_list_widget.dart';

// ignore: must_be_immutable
class StudentsListPaginationWidget extends PaginationListWidget<StudentItemUiState> {

  final Function(StudentItemUiState) onItemSelected;

  const StudentsListPaginationWidget({
    super.key,
    required this.onItemSelected,
    required super.items,
    super.totalRecord,
    super.getMoreItems,
    super.isLoading,
    super.reversed,
    super.separatorBuilder,
  });

  @override
  Widget getItemWidget(StudentItemUiState item, index) {
    return StudentItemWidget(uiState: item, onItemClick: onItemSelected);
  }
}
