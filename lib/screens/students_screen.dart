/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../bloc/students/students_state.dart';
import '../models/student.dart';

class StudentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الطلاب"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteAllStudentsDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentsLoaded && state.students.isNotEmpty) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return _buildStudentTile(context, student);
              },
            );
          } else {
            return Center(child: Text("❌ لا يوجد طلاب مسجلين ❌", style: TextStyle(fontSize: 18)));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddStudentScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(student.phone, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.school, color: Colors.blue, size: 18),
                  SizedBox(width: 6),
                  Text(student.grade, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteStudentDialog(context, student),
          ),
        ),
      ),
    );
  }

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
              BlocProvider.of<StudentsBloc>(context).add(DeleteStudentEvent(student));
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _addStudent(BuildContext context) {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _gradeController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      BlocProvider.of<StudentsBloc>(context, listen: false).add(
        AddStudentEvent(
          Student(
            id: DateTime.now().toString(),
            name: _nameController.text,
            phone: _phoneController.text,
            grade: _gradeController.text,
            password: _passwordController.text,
          ),
        ),
      );
      Navigator.pop(context); //  يبقى في نفس الشاشة بدلاً من الرجوع إلى `HomeScreen`
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة طالب جديد")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, "اسم الطالب"),
            _buildTextField(_phoneController, "رقم الهاتف"),
            _buildTextField(_gradeController, "الصف الدراسي"),
            _buildTextField(_passwordController, "كلمة المرور", isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: StadiumBorder()),
              onPressed: () => _addStudent(context),
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      {bool isPassword = false}) {
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
}
*/

import 'package:flutter/material.dart';
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
            onPressed: () => _showDeleteAllStudentsDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentsLoaded && state.students.isNotEmpty) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return _buildStudentTile(context, student);
              },
            );
          } else {
            return Center(child: Text("❌ لا يوجد طلاب مسجلين ❌", style: TextStyle(fontSize: 18)));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(student.phone, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.school, color: Colors.blue, size: 18),
                  SizedBox(width: 6),
                  Text(student.grade, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteStudentDialog(context, student),
          ),
        ),
      ),
    );
  }

  /// ✅ **إضافة رسالة تأكيد عند حذف الطالب**
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
              BlocProvider.of<StudentsBloc>(context).add(DeleteStudentEvent(student.id as Student)); // ✅ حذف الطالب عبر الـ API
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
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

  /// ✅ **إضافة شاشة إدخال طالب جديد**
  void _showAddStudentDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _gradeController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إضافة طالب جديد"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "اسم الطالب")),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: "رقم الهاتف")),
            TextField(controller: _gradeController, decoration: InputDecoration(labelText: "الصف الدراسي")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "كلمة المرور")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              BlocProvider.of<StudentsBloc>(context).add(
                AddStudentEvent(
                  Student(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    phone: _phoneController.text,
                    grade: _gradeController.text,
                    password: _passwordController.text,
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text("إضافة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
