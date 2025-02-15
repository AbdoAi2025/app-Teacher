/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../bloc/students/students_state.dart';
import '../models/student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentsBloc>(context).add(LoadStudentsEvent()); // ✅ تحميل الطلاب عند بدء الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الطلاب"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteAllStudentsDialog(context), // ✅ استدعاء الدالة بعد إضافتها
          ),
        ],
      ),
      body: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is StudentsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentsLoaded) {
            return _buildStudentsList(state.students);
          } else {
            return Center(child: Text("❌ فشل تحميل الطلاب"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /// ✅ **عرض قائمة الطلاب**
  Widget _buildStudentsList(List<Student> students) {
    return students.isEmpty
        ? Center(child: Text("❌ لا يوجد طلاب مسجلين ❌", style: TextStyle(fontSize: 18)))
        : ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return _buildStudentTile(context, students[index]);
      },
    );
  }

  Widget _buildStudentTile(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.phone, color: Colors.green, size: 18), SizedBox(width: 6), Text(student.phone)]),
            Row(children: [Icon(Icons.school, color: Colors.blue, size: 18), SizedBox(width: 6), Text(student.gradeId.toString())]),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteStudentDialog(context, student),
        ),
      ),
    );
  }

  /// ✅ **إضافة طالب جديد**
  void _showAddStudentDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _parentPhoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    int? _selectedGradeId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إضافة طالب جديد"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, "اسم الطالب"),
              _buildTextField(_phoneController, "رقم الهاتف"),
              _buildTextField(_parentPhoneController, "رقم ولي الأمر"),
              _buildDropdownField("اختر الصف الدراسي", (value) => _selectedGradeId = value),
              _buildTextField(_passwordController, "كلمة المرور", isPassword: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty &&
                  _parentPhoneController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _selectedGradeId != null) {
                Student newStudent = Student(
                  id: DateTime.now().toString(),
                  name: _nameController.text,
                  phone: _phoneController.text,
                  parentPhone: _parentPhoneController.text,
                  gradeId: _selectedGradeId!,
                  password: _passwordController.text,
                  accessToken: "",
                );

                BlocProvider.of<StudentsBloc>(context).add(AddStudentEvent(newStudent));

                Navigator.pop(context);
              }
            },
            child: Text("إضافة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ✅ **إضافة رسالة تأكيد عند حذف جميع الطلاب**
  void _showDeleteAllStudentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حذف جميع الطلاب؟"),
        content: Text("هل أنت متأكد أنك تريد حذف جميع الطلاب؟ لا يمكن التراجع عن هذا الإجراء."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BlocProvider.of<StudentsBloc>(context).add(DeleteAllStudentsEvent());
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ✅ **إضافة رسالة تأكيد عند حذف طالب**
  void _showDeleteStudentDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حذف الطالب؟"),
        content: Text("هل أنت متأكد أنك تريد حذف الطالب ${student.name}؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BlocProvider.of<StudentsBloc>(context).add(DeleteStudentEvent(student.id));
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: null,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: 1073741824, child: Text("الصف الأول")),
          DropdownMenuItem(value: 1073741825, child: Text("الصف الثاني")),
          DropdownMenuItem(value: 1073741826, child: Text("الصف الثالث")),
        ],
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../bloc/students/students_state.dart';
import '../models/student.dart';
import 'add_student_screen.dart'; // ✅ استيراد صفحة إضافة الطالب

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentsBloc>(context).add(LoadStudentsEvent()); // ✅ تحميل الطلاب عند بدء الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الطلاب"),
      ),
      body: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is StudentsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentsLoaded) {
            return _buildStudentsList(state.students);
          } else {
            return Center(child: Text("❌ فشل تحميل الطلاب"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.navigateToAddStudent(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /// ✅ **عرض قائمة الطلاب**
  Widget _buildStudentsList(List<Student> students) {
    return students.isEmpty
        ? Center(child: Text("❌ لا يوجد طلاب مسجلين ❌", style: TextStyle(fontSize: 18)))
        : ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return _buildStudentTile(context, students[index]);
      },
    );
  }

  /// ✅ **عرض معلومات الطالب مع زر الحذف**
  Widget _buildStudentTile(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.phone, color: Colors.green, size: 18), SizedBox(width: 6), Text(student.phone)]),
            Row(children: [Icon(Icons.school, color: Colors.blue, size: 18), SizedBox(width: 6), Text(student.gradeId.toString())]),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            BlocProvider.of<StudentsBloc>(context).add(DeleteStudentEvent(student.id));
          },
        ),
      ),
    );
  }
}
