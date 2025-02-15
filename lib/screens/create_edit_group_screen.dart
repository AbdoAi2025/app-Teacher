import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';

class CreateEditGroupScreen extends StatefulWidget {
  final Group? group;

  CreateEditGroupScreen({this.group});

  @override
  _CreateEditGroupScreenState createState() => _CreateEditGroupScreenState();
}

class _CreateEditGroupScreenState extends State<CreateEditGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();

  String? _selectedClassroom;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameController.text = widget.group!.name ?? "";
      _selectedDay = widget.group!.day;
      _timeFromController.text = widget.group!.timeFrom;
      _timeToController.text = widget.group!.timeTo;
    }
  }

  void _selectTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        controller.text = "${pickedTime.hour}:${pickedTime.minute}";
      });
    }
  }

  void _saveGroup() {
    // if (_selectedDay != null && _selectedClassroom != null && _timeFromController.text.isNotEmpty && _timeToController.text.isNotEmpty) {
    //   final newGroup = Group(
    //     id: widget.group?.id ?? DateTime.now().toString(),
    //     name: _nameController.text.isEmpty ?"بدون اسم": _nameController.text,
    //     day: _selectedDay!,
    //     timeFrom: _timeFromController.text,
    //     timeTo: _timeToController.text,
    //     studentsIds: [],
    //   );
    //
    //   if (widget.group == null) {
    //     BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
    //   } else {
    //     BlocProvider.of<GroupsBloc>(context).add(UpdateGroupEvent(newGroup));
    //   }
    //
    //   Navigator.pop(context);
    // }
  }

  void _deleteGroup() {
    if (widget.group != null) {
      BlocProvider.of<GroupsBloc>(context).add(DeleteGroupEvent(widget.group! as String));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group == null ? "إنشاء مجموعة جديدة" : "تعديل المجموعة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "اسم المجموعة (اختياري)"),
            ),
            SizedBox(height: 20),

            /// ✅ اختيار اليوم من القائمة المنسدلة
            DropdownButtonFormField<int>(
              value: _selectedDay,
              onChanged: (value) => setState(() => _selectedDay = value),
              decoration: InputDecoration(labelText: "اختر اليوم"),
              items: List.generate(
                7,
                    (index) => DropdownMenuItem(
                  value: index,
                  child: Text(_getDayName(index)),
                ),
              ),
            ),
            SizedBox(height: 20),

            /// ✅ اختيار الصف الدراسي
            DropdownButtonFormField<String>(
              value: _selectedClassroom,
              onChanged: (value) => setState(() => _selectedClassroom = value),
              decoration: InputDecoration(labelText: "اختر الصف الدراسي"),
              items: ["الصف الأول", "الصف الثاني"]
                  .map((classroom) => DropdownMenuItem(value: classroom, child: Text(classroom)))
                  .toList(),
            ),
            SizedBox(height: 20),

            /// ✅ اختيار وقت البداية
            TextField(
              controller: _timeFromController,
              readOnly: true,
              decoration: InputDecoration(labelText: "وقت البداية"),
              onTap: () => _selectTime(_timeFromController),
            ),
            SizedBox(height: 20),

            /// ✅ اختيار وقت النهاية
            TextField(
              controller: _timeToController,
              readOnly: true,
              decoration: InputDecoration(labelText: "وقت النهاية"),
              onTap: () => _selectTime(_timeToController),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveGroup,
              child: Text(widget.group == null ? "حفظ المجموعة" : "تحديث المجموعة"),
            ),

            if (widget.group != null) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteGroup,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("حذف المجموعة", style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// ✅ **تحويل `day` من رقم إلى اسم اليوم**
  String _getDayName(int day) {
    const days = ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"];
    return days[day % 7];
  }
}
