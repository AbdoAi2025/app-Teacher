
/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/domain/grades/get_grades_list_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import '../apimodels/grade_api_model.dart';
import '../apimodels/student_list_item_api_model.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';
import '../models/student.dart';

class CreateGroupScreen extends StatefulWidget {

  final Group? group;

  const CreateGroupScreen ({super.key, this.group});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();


}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();

  String? _selectedClassroom;
  int? _selectedDay;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;

  List<StudentListItemApiModel> students = [];
  List<StudentListItemApiModel> selectedStudents = [];
  List<GradeApiModel> grades = [];


  List<Student> studentsList = [];
  List<String> selectedStudentsIds = [];

  @override
  void initState() {
    super.initState();

    // تحميل قائمة الدرجات
    GetGradesListUseCase().execute().then((grades) {
      print("GetGradesListUseCase :$grades");
    });

    // تحميل الطلاب من API
    GetMyStudentsListUseCase().execute(GetMyStudentsRequest()).then((value) {
      setState(() {
        studentsList = value.data?.map((s) => Student.fromJson(s.toJson())).toList() ?? [];
      });
    });

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
          height: 400,
          child: Column(
            children: List.generate(7, (index) {
              return ListTile(
                title: Text("اليوم ${index + 1}"),
                onTap: () {
                  setState(() {
                    _selectedDay = index + 1;
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

  /// ✅ **عرض قائمة الطلاب في BottomSheet مع إمكانية التحديد**
  void _selectStudents() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // `BottomSheet` full screen
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(16.0),

              child: Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30,),
                  Text("Select Students To Group", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),
                  SizedBox(height: 10),
                  Expanded(
                    child: studentsList.isEmpty
                        ? Center(child: Text("There are not any students "))
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentsList.length,
                      itemBuilder: (context, index) {
                        final student = studentsList[index];
                        return CheckboxListTile(
                          title: Text(student.name),
                          subtitle: Text(student.phone),
                          value: selectedStudentsIds.contains(student.id),
                          onChanged: (bool? selected) {
                            setStateSheet(() {
                              if (selected == true) {
                                selectedStudentsIds.add(student.id);
                              } else {
                                selectedStudentsIds.remove(student.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // ✅ تحديث الشاشة بعد الاختيار
                      Navigator.pop(context);
                    },
                    child: Text("إضافة الطلاب المختارين"),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveGroup() {
    if (_selectedDay != null && _selectedTimeFrom != null && _selectedTimeTo != null) {
      final newGroup = Group(
        id: "",
        name: _nameController.text.isEmpty ? "بدون اسم" : _nameController.text,
        studentsIds: selectedStudentsIds,
        day: _selectedDay!,
        timeFrom: "${_selectedTimeFrom!.hour}:${_selectedTimeFrom!.minute}",
        timeTo: "${_selectedTimeTo!.hour}:${_selectedTimeTo!.minute}",
        studentCount: selectedStudentsIds.length,
      );

      BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إنشاء مجموعة جديدة")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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

              //   ElevatedButton(
              //   onPressed: () => _pickTime(true),
              // child: Text(_selectedTimeFrom == null ? "اختر وقت البدء" : "${_selectedTimeFrom!.format(context)}"),
              // ),
              //SizedBox(height: 20),
              //ElevatedButton(
              // onPressed: () => _pickTime(false),
              // child: Text(_selectedTimeTo == null ? "اختر وقت الانتهاء" : "${_selectedTimeTo!.format(context)}"),
              // ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _selectStudents,
                child: Text("إضافة طلاب إلى المجموعة"),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveGroup,
          child: Text( widget.group == null ? "حفظ المجموعة" : "تحديث المجموعة"),
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

*/



