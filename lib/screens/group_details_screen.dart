


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import '../models/student.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  void _toggleAttendance(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(attended: !student.attended);
    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _toggleHomework(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(homeworkDone: !student.homeworkDone);
    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _deleteStudent(BuildContext context, Group group, Student student) {
    BlocProvider.of<GroupsBloc>(context).add(DeleteStudentFromGroupEvent(group, student));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupsLoaded) {
          // ✅ تحديث `UI` فورًا بعد أي تغيير في الطلاب
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(group.name ?? "تفاصيل المجموعة"),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add, size: 28),
              onPressed: () => _showAddStudentDialog(context,group),
            ),
          ],
        ),
        body: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            final updatedGroup = (state is GroupsLoaded)
                ? state.groups.firstWhere((g) => g.id == group.id, orElse: () => group)
                : group;

            return updatedGroup.students.isEmpty
                ? Center(child: Text("❌ لا يوجد طلاب في هذه المجموعة ❌", style: TextStyle(fontSize: 18)))
                : ListView.builder(
              itemCount: updatedGroup.students.length,
              itemBuilder: (context, index) {
                final student = updatedGroup.students[index];
                return _buildStudentTile(context, updatedGroup, student);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Group group, Student student) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("📞 ${student.phone}", style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            FittedBox(
              child: Row(
                children: [
                  _buildStatusButton(
                    icon: student.attended ? Icons.check_circle : Icons.cancel,
                    label: student.attended ? "حضر" : "غائب",
                    color: student.attended ? Colors.green : Colors.red,
                    onTap: () => _toggleAttendance(context, group, student),
                  ),
                  SizedBox(width: 6),
                  _buildStatusButton(
                    icon: student.homeworkDone ? Icons.book : Icons.bookmark_border,
                    label: student.homeworkDone ? "تم" : "لم يتم",
                    color: student.homeworkDone ? Colors.blue : Colors.grey,
                    onTap: () => _toggleHomework(context, group, student),
                  ),
                  SizedBox(width: 6),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteStudent(context, group, student),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size(50, 35),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  void _showAddStudentDialog(BuildContext context, Group group) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _gradeController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("إضافة طالب جديد", style: TextStyle(fontWeight: FontWeight.bold)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, "اسم الطالب"),
                _buildTextField(_phoneController, "رقم الهاتف"),
                _buildTextField(_gradeController, "الصف الدراسي"),
                _buildTextField(_passwordController, "كلمة المرور"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: StadiumBorder()),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _gradeController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {

                  Student newStudent = Student(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    phone: _phoneController.text,
                    grade: _gradeController.text,
                    password: _passwordController.text,
                  );

                  // ✅ إرسال الحدث إلى `GroupsBloc`
                  BlocProvider.of<GroupsBloc>(context, listen: false).add(AddStudentToGroupEvent(group, newStudent));

                  Navigator.pop(context); // ✅ إغلاق الـ Dialog بعد الإضافة
                }
              },
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
*/


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import '../models/student.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  void _toggleAttendance(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      attended: !student.attended,
      name: student.name,  // ✅ الاحتفاظ بالاسم الحالي
      phone: student.phone, // ✅ الاحتفاظ برقم الهاتف الحالي
      grade: student.grade, // ✅ الاحتفاظ بالصف الدراسي الحالي
      password: student.password, // ✅ الاحتفاظ بكلمة المرور الحالية
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _toggleHomework(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      homeworkDone: !student.homeworkDone,
      name: student.name, // ✅ الاحتفاظ بالاسم الحالي
      phone: student.phone, // ✅ الاحتفاظ برقم الهاتف الحالي
      grade: student.grade, // ✅ الاحتفاظ بالصف الدراسي الحالي
      password: student.password, // ✅ الاحتفاظ بكلمة المرور الحالية
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }


  void _deleteStudent(BuildContext context, Group group, Student student) {
    BlocProvider.of<GroupsBloc>(context).add(DeleteStudentFromGroupEvent(group, student));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name ?? "تفاصيل المجموعة"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, size: 28),
            onPressed: () => _showAddStudentDialog(context, group),
          ),
        ],
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          final updatedGroup = (state is GroupsLoaded)
              ? state.groups.firstWhere((g) => g.id == group.id, orElse: () => group)
              : group;

          return updatedGroup.students.isEmpty
              ? Center(child: Text("❌ لا يوجد طلاب في هذه المجموعة ❌", style: TextStyle(fontSize: 18)))
              : ListView.builder(
            itemCount: updatedGroup.students.length,
            itemBuilder: (context, index) {
              final student = updatedGroup.students[index];
              return _buildStudentTile(context, updatedGroup, student);
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Group group, Student student) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: GestureDetector(
          onTap: () => _showEditStudentDialog(context, group, student),
          child: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        subtitle: Text("📞 ${student.phone} - الصف: ${student.grade}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(student.attended ? Icons.check_circle : Icons.cancel,
                  color: student.attended ? Colors.green : Colors.red),
              onPressed: () => _toggleAttendance(context, group, student),
            ),
            IconButton(
              icon: Icon(student.homeworkDone ? Icons.book : Icons.bookmark_border,
                  color: student.homeworkDone ? Colors.blue : Colors.grey),
              onPressed: () => _toggleHomework(context, group, student),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteStudent(context, group, student),
            ),
          ],
        ),
      ),
    );
  }





  void _showEditStudentDialog(BuildContext context, Group group, Student student) {
    final TextEditingController _nameController = TextEditingController(text: student.name);
    final TextEditingController _phoneController = TextEditingController(text: student.phone);
    final TextEditingController _gradeController = TextEditingController(text: student.grade);
    final TextEditingController _passwordController = TextEditingController(text: student.password);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تعديل بيانات الطالب", style: TextStyle(fontWeight: FontWeight.bold)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, "اسم الطالب"),
                _buildTextField(_phoneController, "رقم الهاتف"),
                _buildTextField(_gradeController, "الصف الدراسي"),
                _buildTextField(_passwordController, "كلمة المرور"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: StadiumBorder()),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _gradeController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {

                  Student updatedStudent = student.copyWith(
                    name: _nameController.text,
                    phone: _phoneController.text,
                    grade: _gradeController.text,
                    password: _passwordController.text,
                  );

                  BlocProvider.of<GroupsBloc>(context, listen: false).add(UpdateStudentInGroupEvent(group, updatedStudent));

                  Navigator.pop(context);
                }
              },
              child: Text("حفظ التعديلات", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog(BuildContext context, Group group) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _gradeController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("إضافة طالب جديد", style: TextStyle(fontWeight: FontWeight.bold)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, "اسم الطالب"),
                _buildTextField(_phoneController, "رقم الهاتف"),
                _buildTextField(_gradeController, "الصف الدراسي"),
                _buildTextField(_passwordController, "كلمة المرور"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: StadiumBorder()),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _gradeController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {

                  Student newStudent = Student(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    phone: _phoneController.text,
                    grade: _gradeController.text,
                    password: _passwordController.text,
                  );

                  BlocProvider.of<GroupsBloc>(context, listen: false).add(AddStudentToGroupEvent(group, newStudent));

                  Navigator.pop(context);
                }
              },
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
*/


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import '../models/student.dart';
import 'add_student_screen.dart'; // ✅ صفحة جديدة لإضافة طالب

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  void _toggleAttendance(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      attended: !student.attended,
      name: student.name,
      phone: student.phone,
      grade: student.grade,
      password: student.password,
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _toggleHomework(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      homeworkDone: !student.homeworkDone,
      name: student.name,
      phone: student.phone,
      grade: student.grade,
      password: student.password,
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _deleteStudent(BuildContext context, Group group, Student student) {
    BlocProvider.of<GroupsBloc>(context).add(DeleteStudentFromGroupEvent(group, student));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name ?? "تفاصيل المجموعة"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentScreen(group: group)), // ✅ فتح صفحة جديدة لإضافة طالب
            ),
          ),
        ],
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          final updatedGroup = (state is GroupsLoaded)
              ? state.groups.firstWhere((g) => g.id == group.id, orElse: () => group)
              : group;

          return updatedGroup.students.isEmpty
              ? Center(child: Text("❌ لا يوجد طلاب في هذه المجموعة ❌", style: TextStyle(fontSize: 18)))
              : ListView.builder(
            itemCount: updatedGroup.students.length,
            itemBuilder: (context, index) {
              final student = updatedGroup.students[index];
              return _buildStudentTile(context, updatedGroup, student);
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Group group, Student student) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text("📞 ${student.phone} - 📚 الصف: ${student.grade}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteStudent(context, group, student),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton(
                  icon: student.homeworkDone ? Icons.check_circle : Icons.cancel,
                  label: student.homeworkDone ? "تم الواجب" : "لم يتم الواجب",
                  color: student.homeworkDone ? Colors.blue : Colors.red,
                  onTap: () => _toggleHomework(context, group, student),
                ),
                _buildStatusButton(
                  icon: student.attended ? Icons.check_circle : Icons.close,
                  label: student.attended ? "حضر" : "غائب",
                  color: student.attended ? Colors.green : Colors.red,
                  onTap: () => _toggleAttendance(context, group, student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
import '../models/student.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart'; // ✅ استيراد شاشة تعديل الطالب

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  void _toggleAttendance(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      attended: !student.attended,
      name: student.name,
      phone: student.phone,
      grade: student.grade,
      password: student.password,
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _toggleHomework(BuildContext context, Group group, Student student) {
    Student updatedStudent = student.copyWith(
      homeworkDone: !student.homeworkDone,
      name: student.name,
      phone: student.phone,
      grade: student.grade,
      password: student.password,
    );

    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(group, updatedStudent));
  }

  void _confirmDeleteStudent(BuildContext context, Group group, Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("حذف الطالب"),
          content: Text("هل أنت متأكد أنك تريد حذف هذا الطالب؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<GroupsBloc>(context).add(DeleteStudentFromGroupEvent(group, student));
                Navigator.pop(context);
              },
              child: Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name ?? "تفاصيل المجموعة"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentScreen(group: group)),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          final updatedGroup = (state is GroupsLoaded)
              ? state.groups.firstWhere((g) => g.id == group.id, orElse: () => group)
              : group;

          return updatedGroup.students.isEmpty
              ? Center(child: Text("❌ لا يوجد طلاب في هذه المجموعة ❌", style: TextStyle(fontSize: 18)))
              : ListView.builder(
            itemCount: updatedGroup.students.length,
            itemBuilder: (context, index) {
              final student = updatedGroup.students[index];
              return _buildStudentTile(context, updatedGroup, student);
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Group group, Student student) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudentScreen(group: group, student: student)),
              ),
              child: ListTile(
                title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📞 ${student.phone}"),
                    Text("📚 ${student.grade}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteStudent(context, group, student),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton(
                  icon: student.homeworkDone ? Icons.check_circle : Icons.cancel,
                  label: student.homeworkDone ? "تم الواجب" : "لم يتم الواجب",
                  color: student.homeworkDone ? Colors.blue : Colors.red,
                  onTap: () => _toggleHomework(context, group, student),
                ),
                _buildStatusButton(
                  icon: student.attended ? Icons.check_circle : Icons.close,
                  label: student.attended ? "حضر" : "غائب",
                  color: student.attended ? Colors.green : Colors.red,
                  onTap: () => _toggleAttendance(context, group, student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
