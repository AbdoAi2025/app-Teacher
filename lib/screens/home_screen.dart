/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/bloc/students/students_event.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../bloc/students/students_bloc.dart';
import 'groups_screen.dart';
import 'students_screen.dart';
import 'create_group_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    GroupsScreen(),
    StudentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الصفحة الرئيسية"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteGroupDialog(context);
            },
          ),


        ],


      ),


      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded) {
            return _screens[_currentIndex];
          } else {
            return Center(child: Text("❌ حدث خطأ أثناء تحميل البيانات ❌"));
          }
        },
      ),

      floatingActionButton: Visibility(
        visible: _currentIndex == 0, // ✅ زر الإضافة يظهر فقط في صفحة المجموعات
        child: FloatingActionButton(
          onPressed: () {
           Navigator.push(
           // Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CreateGroupScreen()),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "المجموعات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الطلاب",
          ),
        ],
      ),
    );

  }

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

            //  BlocProvider.of<StudentsBloc>(context).add(DeleteAllStudentsEvent() as StudentsEvent);
              //Navigator.pop(context);

            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'groups_screen.dart';
import 'students_screen.dart';
import 'create_edit_group_screen.dart';
import 'group_details_screen.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // ✅ تعريف متغير حالة لحفظ المؤشر الحالي

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // ✅ تحديث المؤشر عند الضغط على `BottomNavigationBar`
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الصفحة الرئيسية")),
      body: _currentIndex == 0 ? _buildGroupsScreen() : StudentsScreen(), // ✅ تبديل بين الصفحات
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateEditGroupScreen()),
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
                      Text(
                        "📅 ${_formatDate(group.startTime)}",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "🕒 ${_formatTime(group.startTime)}",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "🏫 ${group.classroom}",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}"; // ✅ إظهار التاريخ فقط
  }

  String _formatTime(DateTime date) {
    return "${date.hour}:${date.minute}"; // ✅ إظهار الساعة فقط
  }
}
