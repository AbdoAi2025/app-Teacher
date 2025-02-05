import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';
import '../models/student.dart';

class AddStudentScreen extends StatelessWidget {
  final Group group;

  AddStudentScreen({required this.group});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            _buildTextField(_passwordController, "كلمة المرور"),
            SizedBox(height: 20),
            ElevatedButton(
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

                  BlocProvider.of<GroupsBloc>(context).add(AddStudentToGroupEvent(group, newStudent));

                  Navigator.pop(context);
                }
              },
              child: Text("إضافة الطالب"),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
