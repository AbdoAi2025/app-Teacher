/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

int? _selectedGradeId;

  final _formKey = GlobalKey<FormState>();

  void _saveStudent() {
    if (_formKey.currentState!.validate() ) {
      Student newStudent = Student(
        id: "", // سيتم تعيينه لاحقًا من الـ API
        name: _nameController.text,
        phone: _phoneController.text,
        parentPhone: _parentPhoneController.text,

       gradeId: _selectedGradeId!,  // ✅ تمرير ID فقط
        password: _passwordController.text,
        accessToken: "", // سيتم تعيينه لاحقًا من الـ API
      );

      BlocProvider.of<StudentsBloc>(context).add(AddStudentEvent(newStudent));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة طالب جديد")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, "اسم الطالب"),
                _buildTextField(_phoneController, "رقم الهاتف"),
                _buildTextField(_parentPhoneController, "رقم ولي الأمر"),
                _buildDropdownField("اختر الصف الدراسي"),
                _buildTextField(_passwordController, "كلمة المرور", isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text("إضافة الطالب"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: _selectedGradeId,
        onChanged: (value) {
          setState(() {
            _selectedGradeId = value;
          });
        },
        validator: (value) => value == null ? "يجب اختيار الصف الدراسي" : null,
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
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {


  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int? _selectedGradeId;

  final _formKey = GlobalKey<FormState>();

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      Student newStudent = Student(
        id: "",
        name: _nameController.text,
        phone: _phoneController.text,
        parentPhone: _parentPhoneController.text,
        gradeId: _selectedGradeId!, // ✅ تمرير ID كـ int وليس String
        password: _passwordController.text,
        accessToken: "",
      );

      BlocProvider.of<StudentsBloc>(context).add(AddStudentEvent(newStudent));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة طالب جديد")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, "اسم الطالب"),
                _buildTextField(_phoneController, "رقم الهاتف"),
                _buildTextField(_parentPhoneController, "رقم ولي الأمر"),
                _buildDropdownField("اختر الصف الدراسي"), // ✅ تصحيح القائمة المنسدلة
                _buildTextField(_passwordController, "كلمة المرور", isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text("إضافة الطالب"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  /// ✅ **إدخال الصف الدراسي عبر القائمة المنسدلة**
  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: _selectedGradeId, // ✅ يتم تعيين القيمة الافتراضية بشكل صحيح
        onChanged: (value) {
          setState(() {
            _selectedGradeId = value; // ✅ تأكد من أن القيمة تُحفظ كـ int
          });
        },
        validator: (value) => value == null ? "يجب اختيار الصف الدراسي" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: 1, child: Text("الصف الأول")),
          DropdownMenuItem(value: 2, child: Text("الصف الثاني")),
          DropdownMenuItem(value: 3, child: Text("الصف الثالث")),
        ],
      ),
    );
  }
}
