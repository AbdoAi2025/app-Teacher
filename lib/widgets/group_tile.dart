import 'package:flutter/material.dart';

import '../models/group_item_model.dart';

class GroupTile extends StatelessWidget {
  final GroupItemModel group;

  GroupTile({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(group.name ?? "مجموعة بدون اسم"),
      //  subtitle: Text("الصف: ${group.classroom}"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // هنا يمكنك توجيه المستخدم إلى تفاصيل المجموعة
        },
      ),
    );
  }
}
