import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedDay;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;

  void _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _selectedTimeFrom = pickedTime;
        } else {
          _selectedTimeTo = pickedTime;
        }
      });
    }
  }

  void _selectDay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: List.generate(7, (index) {
              return ListTile(
                title: Text("اليوم ${index + 1}"),
                onTap: () {
                  setState(() {
                    _selectedDay = index + 1; // API يتعامل مع الأيام بأرقام 1-7
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ),
        );
      },
    );
  }

  void _saveGroup() {
    // if (_selectedDay != null && _selectedTimeFrom != null && _selectedTimeTo != null) {
    //   final newGroup = Group(
    //     id: "", // سيُنشأ في الـ API
    //     name: _nameController.text.isEmpty ? "بدون اسم" : _nameController.text,
    //     studentsIds: [], // ✅ API يحتاج قائمة `studentsIds`
    //     day: _selectedDay!,
    //     timeFrom: "${_selectedTimeFrom!.hour}:${_selectedTimeFrom!.minute}",
    //     timeTo: "${_selectedTimeTo!.hour}:${_selectedTimeTo!.minute}",
    //   );
    //
    //   BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
    //   Navigator.pop(context);
    // }
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
              onPressed: _selectDay,
              child: Text(_selectedDay == null ? "اختر يوم الدرس" : "اليوم $_selectedDay"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickTime(true),
              child: Text(_selectedTimeFrom == null ? "اختر وقت البدء" : "${_selectedTimeFrom!.format(context)}"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickTime(false),
              child: Text(_selectedTimeTo == null ? "اختر وقت الانتهاء" : "${_selectedTimeTo!.format(context)}"),
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


//✅ تحديث Student لإضافة attended و homeworkDone