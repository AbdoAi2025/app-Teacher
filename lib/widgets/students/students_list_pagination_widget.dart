import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
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

    if(item is StudentItemTitleUiState){
      return AppTextWidget(item.title.isEmpty ? "Without group".tr : item.title , style: AppTextStyle.title,);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: StudentItemWidget(uiState: item, onItemClick: onItemSelected),
    );
  }
}
