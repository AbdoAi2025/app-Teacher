import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/screens/create_group_screen.dart';
import 'groups_screen.dart';
import 'students_screen.dart';
import 'create_edit_group_screen.dart';
import 'group_details_screen.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الرئيسية"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteGroupDialog(context);
            },
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildGroupsScreen() : StudentsScreen(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateGroupScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "المجموعات"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "الطلاب"),
        ],
      ),
    );
  }

  Widget _buildGroupsScreen() {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GroupsLoaded) {
          if (state.groups.isEmpty) {
            return Center(child: Text("❌ لا توجد مجموعات ❌", style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, index) {
              final Group group = state.groups[index];
              return Card(
                elevation: 6,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GroupDetailsScreen(group: group)),
                  ),
                  title: Text(group.name ?? "بدون اسم", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 اليوم: ${_getDayName(group.day)}", style: TextStyle(color: Colors.black)),
                      Text("🕒 من: ${group.timeFrom} - إلى: ${group.timeTo}", style: TextStyle(color: Colors.black54)),
                    //  Text("🏫 ${group.classroom}", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey[700]),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateEditGroupScreen(group: group)),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("❌ حدث خطأ أثناء تحميل البيانات ❌"));
        }
      },
    );
  }

  /// ✅ **تحويل رقم اليوم إلى اسم اليوم**
  String _getDayName(int day) {
    const days = ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"];
    return days[day % 7];
  }

  /// ✅ **إظهار نافذة تأكيد حذف جميع المجموعات**
  void _showDeleteGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حذف جميع المجموعات؟"),
        content: Text("هل أنت متأكد من أنك تريد حذف جميع المجموعات؟ لا يمكن التراجع عن هذا الإجراء."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BlocProvider.of<GroupsBloc>(context).add(DeleteAllGroupsEvent());
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
