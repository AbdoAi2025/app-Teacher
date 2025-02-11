import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../models/student.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  EditStudentScreen({required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _parentPhoneController;
  int? _selectedGradeId;
  late TextEditingController _passwordController ;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _phoneController = TextEditingController(text: widget.student.phone);
    _parentPhoneController = TextEditingController(text: widget.student.parentPhone);
    _selectedGradeId = widget.student.gradeId as int?;// ✅ استخدم الـ ID بدلاً من كائن `Grade`
    _passwordController=TextEditingController(text: widget.student.password);
  }

  void _saveChanges() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty && _selectedGradeId != null) {
      Student updatedStudent = Student(
        id: widget.student.id, // ✅ استخدام ID الطالب الحالي
        name: _nameController.text,
        phone: _phoneController.text,
        parentPhone: _parentPhoneController.text,
        password: _passwordController.text,
        gradeId: _selectedGradeId!,
        accessToken: widget.student.accessToken, // ✅ الاحتفاظ بالتوكن كما هو
      );

      BlocProvider.of<StudentsBloc>(context).add(UpdateStudentEvent(
          studentId: updatedStudent.id, // ✅ تمرير `studentId` الصحيح
        updatedStudent: updatedStudent));

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل بيانات الطالب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_nameController, "اسم الطالب"),
            _buildTextField(_phoneController, "رقم الهاتف"),
            _buildTextField(_parentPhoneController, "رقم ولي الأمر"),
            _buildDropdownField("اختر الصف الدراسي"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("حفظ التعديلات"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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