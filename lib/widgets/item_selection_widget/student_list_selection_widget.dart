import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../../widgets/primary_button_widget.dart';
import 'item_selection_ui_state.dart';

class ItemSelectionWidget extends StatefulWidget {

  final String title;
  final List<ItemSelectionUiState> items;
  final Function(List<ItemSelectionUiState>) onSaved;
  final bool isSingleSelection;

  const ItemSelectionWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onSaved,
    this.isSingleSelection = false
  });

  @override
  State<ItemSelectionWidget> createState() =>
      _ItemSelectionWidgetState();
}

class _ItemSelectionWidgetState
    extends State<ItemSelectionWidget> {
  late List<ItemSelectionUiState> items = widget.items.map((e) => e.copyWith()).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          _title(),
          Expanded(
            child: _showStudentList(),
          ),
          _saveButton()
        ],
      ),
    );
  }

  Widget _showStudentList() {
    // return AppTextWidget("items : ${items.length}");
    return ListView.separated(
      shrinkWrap: true,
        itemBuilder: (context, index) => _studentItem(items[index]),
        separatorBuilder: (context, index) => _separator(),
        itemCount: items.length
    );
  }


  Widget _studentItem(ItemSelectionUiState item) {
    return InkWell(
      onTap: ()=> onSelected(item),
      child: Row(
        spacing: 20,
        children: [
          _checkbox(item),
          Expanded(child: AppTextWidget(item.name)),
        ],
      ),
    );
  }

  Widget _separator() => Container(
        color: AppColors.colorSeparator,
        height: .5,
        width: double.infinity,
      );

  _checkbox(ItemSelectionUiState item) {
    appLog("_checkbox : ${item.id} , ${item.isSelected}");

    return Checkbox(
      value: item.isSelected,
      onChanged: (value) {
        onSelected(item);
      },
    );
  }

  void onSelected(ItemSelectionUiState item) {
    setState(() {
      appLog("onSelected items:${item.id} , ${item.isSelected}");
      if(widget.isSingleSelection) {
        for (var element in items) {
          element.isSelected = item.id == element.id;
          appLog("onSelected element:${element.id} , ${element.isSelected}");
        }
      }else {
        item.isSelected = !item.isSelected;
      }
    });
  }

  _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: "Save".tr,
        onClick: () {
          onSaveClick();
        },
      ),
    );
  }

  void onSaveClick() {
    var selectedStudents = items.where((element) => element.isSelected).toList();
    widget.onSaved(selectedStudents);
    Get.back();
  }

  _title() {
    return AppTextWidget(widget.title ?? "Select Student to group".tr , style: AppTextStyle.appToolBarTitle,);
  }



}
