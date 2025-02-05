import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';
import '../models/student.dart';

class EditStudentScreen extends StatefulWidget {
  final Group group;
  final Student student;

  EditStudentScreen({required this.group, required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _gradeController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _phoneController = TextEditingController(text: widget.student.phone);
    _gradeController = TextEditingController(text: widget.student.grade);
    _passwordController = TextEditingController(text: widget.student.password);
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
            _buildTextField(_gradeController, "الصف الدراسي"),
            _buildTextField(_passwordController, "كلمة المرور"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<GroupsBloc>(context).add(
                  UpdateStudentInGroupEvent(
                    widget.group,
                    widget.student.copyWith(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      grade: _gradeController.text,
                      password: _passwordController.text,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
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
      child: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
    );
  }
}
