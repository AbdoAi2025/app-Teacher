/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded && state.groups.isNotEmpty) {
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(group.name ?? "مجموعة بدون اسم"),
                    subtitle: Text("الصف: ${group.classroom}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(group: group),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("لا توجد مجموعات متاحة"));
          }
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import 'group_details_screen.dart';
import 'create_edit_group_screen.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GroupsBloc>(context).add(LoadGroupsEvent()); // ✅ تحميل البيانات عند فتح الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المجموعات الدراسية")),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded && state.groups.isNotEmpty) {
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    title: Text(
                      group.name ?? "مجموعة بدون اسم",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text("📅 التاريخ: ${_formatDate(group.startTime)}"),
                        Text("🕒 الوقت: ${_formatTime(group.startTime)}"),
                        Text("🏫 الصف: ${group.classroom}", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(group: group),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("❌ لا توجد مجموعات متاحة ❌", style: TextStyle(fontSize: 18)),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CreateEditGroupScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}"; // ✅ إظهار التاريخ فقط
  }

  String _formatTime(DateTime date) {
    return "${date.hour}:${date.minute}"; // ✅ إظهار الوقت فقط
  }
}
