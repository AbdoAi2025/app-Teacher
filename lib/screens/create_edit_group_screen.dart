


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/domain/grades/get_grades_list_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';

class CreateEditGroupScreen extends StatefulWidget {
  final Group? group;

  const CreateEditGroupScreen({super.key, this.group});

  @override
  _CreateEditGroupScreenState createState() => _CreateEditGroupScreenState();
}

class _CreateEditGroupScreenState extends State<CreateEditGroupScreen> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();

  String? _selectedClassroom;
  int? _selectedDay;

  List<StudentListItemApiModel> students = [];
  List<StudentListItemApiModel> selectedStudents = [];
  List<GradeApiModel> grades = [];



  @override
  void initState() {
    super.initState();

    /*text load grades*/
    GetGradesListUseCase().execute().then((value) {
      print("GetGradesListUseCase :${value.data?.length}");
      grades = value.data ?? List.empty();
    });


    /*Test load student without groups*/
    GetMyStudentsListUseCase().execute(GetMyStudentsRequest(hasGroups: false)).then((value) {
      print("GetMyStudentsListUseCase :${value.data?.length}");

       students = value.data ?? List.empty();

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

  void _saveGroup() {
     if (_selectedDay != null && _selectedClassroom != null && _timeFromController.text.isNotEmpty && _timeToController.text.isNotEmpty) {
      final newGroup = Group(
         id: widget.group?.id ?? DateTime.now().toString(),
        name: _nameController.text.isEmpty ?"بدون اسم": _nameController.text,
        day: _selectedDay!,
       timeFrom: _timeFromController.text, //     timeTo: _timeToController.text,
        studentsIds: [], studentCount: 5 , timeTo: '',
     );

       if (widget.group == null) {
         BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
      } else {
        BlocProvider.of<GroupsBloc>(context).add(UpdateGroupEvent(newGroup));
       }

     Navigator.pop(context);
    }
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
      body: SingleChildScrollView(
        child: Padding(
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




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/domain/grades/get_grades_list_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';

class CreateEditGroupScreen extends StatefulWidget {
  final Group? group;

  const CreateEditGroupScreen({super.key, this.group});

  @override
  _CreateEditGroupScreenState createState() => _CreateEditGroupScreenState();
}

class _CreateEditGroupScreenState extends State<CreateEditGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();

  int? _selectedDay;
  List<StudentListItemApiModel> students = [];
  List<StudentListItemApiModel> selectedStudents = [];
  List<GradeApiModel> grades = [];
  List<StudentListItemApiModel> selectedStudentsIds = [];

  @override
  void initState() {
    super.initState();

    /// ✅ **تحميل قائمة الصفوف الدراسية**
    GetGradesListUseCase().execute().then((value) {
      setState(() {
        grades = value.data ?? [];
      });
    });

    /// ✅ **تحميل الطلاب غير المسجلين في مجموعات**
    GetMyStudentsListUseCase().execute(GetMyStudentsRequest(hasGroups: false)).then((value) {
      setState(() {
        students = value.data ?? [];
      });
    });

    if (widget.group != null) {
      _nameController.text = widget.group!.name ?? "";
      _selectedDay = widget.group!.day;
      _timeFromController.text = widget.group!.timeFrom;
      _timeToController.text = widget.group!.timeTo;

    }
  }

  /// ✅ **فتح `TimePicker` لاختيار وقت البدء أو الانتهاء**
  void _pickTime(TextEditingController controller) async {
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

  /// ✅ **فتح `BottomSheet` لاختيار اليوم**
  void _selectDay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: List.generate(7, (index) {
              return ListTile(
                title: Text(_getDayName(index)),
                onTap: () {
                  setState(() {
                    _selectedDay = index;
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

  /// ✅ **فتح `BottomSheet` لاختيار الطلاب**
  void _selectStudents() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ جعل `BottomSheet` قابل للتمدد
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.66, // ✅ جعل `BottomSheet` 2/3 الشاشة
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "اختر الطلاب للمجموعة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Expanded(
                    child: students.isEmpty
                        ? Center(child: Text("❌ لا يوجد طلاب متاحين"))
                        : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return CheckboxListTile(
                          title: Text(student.studentName ?? ""),
                          subtitle: Text(student.studentPhone ?? ""),
                          value: selectedStudentsIds.contains(student.studentId),
                          onChanged: (bool? selected) {
                            setStateSheet(() {
                              if (selected == true) {
                                selectedStudentsIds.add(student.studentId as StudentListItemApiModel);
                              } else {
                                selectedStudentsIds.remove(student.studentId);
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
                      setState(() {}); // ✅ تحديث `DropdownButtonFormField` بعد اختيار الطلاب
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

  /// ✅ **حفظ أو تحديث المجموعة**
  void _saveGroup() {
    final newGroup = Group(
      id: widget.group?.id ?? DateTime.now().toString(),
      name: _nameController.text.isEmpty ? "بدون اسم" : _nameController.text,
      day: _selectedDay ?? 0,
      timeFrom: _timeFromController.text,
      timeTo: _timeToController.text,
      studentCount: selectedStudentsIds.length, studentsIds: [],
    );

    if (widget.group == null) {
      BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
    } else {
      BlocProvider.of<GroupsBloc>(context).add(UpdateGroupEvent(newGroup));
    }

    Navigator.pop(context);
  }

  /// ✅ **حذف المجموعة**
  void _deleteGroup() {
    if (widget.group != null) {
      BlocProvider.of<GroupsBloc>(context).add(DeleteGroupEvent(widget.group!.id));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group == null ? "إنشاء مجموعة جديدة" : "تعديل المجموعة")),
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

              /// ✅ **اختيار اليوم**
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

              /// ✅ **اختيار وقت البداية**
              TextField(
                controller: _timeFromController,
                readOnly: true,
                decoration: InputDecoration(labelText: "وقت البداية"),
                onTap: () => _pickTime(_timeFromController),
              ),
              SizedBox(height: 20),

              /// ✅ **اختيار وقت النهاية**
              TextField(
                controller: _timeToController,
                readOnly: true,
                decoration: InputDecoration(labelText: "وقت النهاية"),
                onTap: () => _pickTime(_timeToController),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _selectStudents,
                child: Text("اختر الطلاب"),
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
      ),
    );
  }

  /// ✅ **تحويل `day` من رقم إلى اسم اليوم**
  String _getDayName(int day) {
    const days = ["الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"];
    return days[day % 7];
  }
}
