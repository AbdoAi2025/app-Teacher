import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
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
    BlocProvider.of<GroupsBloc>(context)
        .add(LoadGroupsEvent()); // ✅ تحميل البيانات عند فتح الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المجموعات الدراسية")),
      body: BlocListener<GroupsBloc, GroupsState>(listener: (context, state) {
          if (state is GroupsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message,
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            if (state is GroupsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            else if (state is GroupsLoaded && state.groups.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<GroupsBloc>(context)
                      .add(LoadGroupsEvent()); // ✅ تحديث البيانات عند السحب
                },
                child: ListView.builder(
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          group.name ?? "مجموعة بدون اسم",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text("📅 اليوم: ${_getDayName(group.day)}"),
                            Text(
                                "🕒 من ${group.timeFrom ?? "غير محدد"} إلى ${group.timeTo ?? "غير محدد"}"),
                          ],
                        ),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroupDetailsScreen(group: group),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text("❌ لا توجد مجموعات متاحة ❌",
                    style: TextStyle(fontSize: 18)),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.navigateToCreateGroup(context).then((_) {
            BlocProvider.of<GroupsBloc>(context)
                .add(LoadGroupsEvent()); // ✅ إعادة تحميل البيانات بعد الرجوع
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// ✅ **تحويل `day` من رقم إلى اسم اليوم**
  String _getDayName(int day) {
    const days = [
      "الأحد",
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت"
    ];
    return days[day % 7];
  }
}
