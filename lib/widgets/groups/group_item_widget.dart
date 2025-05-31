import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../screens/groups/groups_state.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupItemUiState uiState;
  final Function(GroupItemUiState) onClick;
  final Function(GroupItemUiState) onEditClick;
  final Function(GroupItemUiState) onDeleteClick;

  const GroupItemWidget(
      {super.key,
      required this.uiState,
      required this.onClick,
      required this.onEditClick,
      required this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(uiState);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _groupName(),
                  Spacer(),
                  _deleteIcon(),
                  _editIcon(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [_date(), _time()],
                  )),
                  _arrowIcon()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _arrowIcon() => Icon(Icons.arrow_forward_ios, color: Colors.grey);

  _date() => AppTextWidget("${"Date".tr}:${uiState.date}");

  _time() => AppTextWidget(
      "${"Time".tr}: ${uiState.timeFrom} - ${uiState.timeTo}");

  _groupName() => AppTextWidget(
        uiState.groupName,
        style: AppTextStyle.title,
      );

  _deleteIcon() => InkWell(
      onTap: () => onDeleteClick(uiState),
      child: Icon(Icons.delete));

  _editIcon() => InkWell(
      onTap: () => onEditClick(uiState),
      child: Icon(Icons.edit));
}
