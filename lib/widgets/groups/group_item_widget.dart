import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../screens/groups/groups_state.dart';

class GroupItemWidget extends StatelessWidget {

  final GroupItemUiState uiState;
  final Function(GroupItemUiState) onClick;

  const GroupItemWidget({super.key, required this.uiState, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        title: AppTextWidget(
          uiState.groupName,
          style: AppTextStyle.title,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            AppTextWidget("${"Date".tr}:${uiState.date}"),
            AppTextWidget("${"Time From".tr}:${uiState.timeFrom} - ${"Time to".tr} : ${uiState.timeTo}"),
          ],
        ),
        trailing:
        Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          onClick(uiState);
        },
      ),
    );
  }
}
