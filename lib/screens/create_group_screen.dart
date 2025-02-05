import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';
import '../models/student.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedClassroom;

  void _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _selectClassroom() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                title: Text("الصف الأول"),
                onTap: () {
                  setState(() {
                    _selectedClassroom = "الصف الأول";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("الصف الثاني"),
                onTap: () {
                  setState(() {
                    _selectedClassroom = "الصف الثاني";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveGroup() {
    if (_selectedDateTime != null && _selectedClassroom != null) {
      final newGroup = Group(
        id: DateTime.now().toString(),
        name: _nameController.text.isEmpty ? null : _nameController.text,
        startTime: _selectedDateTime!,
        classroom: _selectedClassroom!,
        students: [], // ✅ تأكد من أن القائمة فارغة عند إنشاء المجموعة
      );

      BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إنشاء مجموعة جديدة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "اسم المجموعة (اختياري)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: Text(_selectedDateTime == null ? "اختر وقت الدرس" : "${_selectedDateTime!.toLocal()}"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectClassroom,
              child: Text(_selectedClassroom ?? "اختر الصف الدراسي"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGroup,
              child: Text("حفظ المجموعة"),
            ),
          ],
        ),
      ),
    );
  }
}
