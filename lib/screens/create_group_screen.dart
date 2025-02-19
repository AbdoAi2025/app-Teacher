/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/domain/grades/get_grades_list_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
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

  @override
  void initState() {
    super.initState();

    GetGradesListUseCase().execute().then((grades) {
      print("GetGradesListUseCase :$grades");
    });
    

    GetMyStudentsListUseCase().execute(GetMyStudentsRequest()).then((value) {
      print("GetMyStudentsListUseCase :$value");
    });
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
*/

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/domain/grades/get_grades_list_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
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
  int? _selectedDay;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;
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
        studentsList = value.data!.cast<Student>(); // ✅ ضبط قائمة الطلاب
      });
    });
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
          height: 300,
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

  void _selectStudents() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSheet) {
          return Container(
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: studentsList.length,
                    itemBuilder: (context, index) {
                      final student = studentsList[index];
                      return CheckboxListTile(
                        title: Text(student.name),
                        subtitle: Text(student.phone),
                        value: selectedStudentsIds.contains(student.studentId),
                        onChanged: (bool? selected) {
                          setStateSheet(() {
                            if (selected == true) {
                              selectedStudentsIds.add(student.studentId);
                            } else {
                              selectedStudentsIds.remove(student.studentId);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("إضافة الطلاب"),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _saveGroup() {
    if (_selectedDay != null && _selectedTimeFrom != null && _selectedTimeTo != null) {
      final newGroup = Group(
        id: "",
        name: _nameController.text.isEmpty ? "بدون اسم" : _nameController.text,
        studentsIds: selectedStudentsIds, // ✅ إضافة الطلاب المختارين
        day: _selectedDay!,
        timeFrom: "${_selectedTimeFrom!.hour}:${_selectedTimeFrom!.minute}",
        timeTo: "${_selectedTimeTo!.hour}:${_selectedTimeTo!.minute}", studentCount: 0,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              onPressed: _selectStudents,
              child: Text("إضافة طلاب إلى المجموعة"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveGroup,
          child: Text("حفظ المجموعة"),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_event.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_state.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/widgets/student_list_selection_widget.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../models/group.dart';
import '../models/student.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();

  late StudentsSelectionBloc studentsSelectionBloc =
  BlocProvider.of<StudentsSelectionBloc>(context);

  int? _selectedDay;
  List<Student> studentsList = [];
  List<Student> selectedStudents = [];
  List<Student> selectedStudentsIds = [];

  @override
  void initState() {
    super.initState();
  }

  /*Pickup time*/
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

  /*Select day*/
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

  void _selectStudents() {

    studentsSelectionBloc.add(LoadStudentsEvent());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ جعل `BottomSheet` قابل للتمدد
      builder: (context) {
        return SizedBox(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.66,
            child: StudentListSelectionWidget());

        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height *
                  0.66, // ✅ جعل `BottomSheet` 2/3 الشاشة
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
                    child: studentsList.isEmpty
                        ? Center(child: Text("❌ لا يوجد طلاب متاحين"))
                        : ListView.builder(
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
                                selectedStudentsIds
                                    .add(student.id as Student);
                                selectedStudents.add(student);
                              } else {
                                selectedStudentsIds.remove(student.id);
                                selectedStudents.removeWhere(
                                        (s) => s.id == student.id);
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
                      setState(
                              () {}); // ✅ تحديث `DropdownButtonFormField` بعد اختيار الطلاب
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
    // final newGroup = Group(
    //   id: "",
    //   name: _nameController.text.isEmpty ? "بدون اسم" : _nameController.text,
    //   studentsIds: selectedStudentsIds.map((e) => e.studentId,).toList(),
    //   day: _selectedDay ?? 0, // ✅ إذا لم يُحدد اليوم، يتم ضبطه على 0
    //   timeFrom: _timeFromController.text,
    //   timeTo: _timeToController.text,
    //   studentCount: selectedStudentsIds.length,
    // );
    //
    // BlocProvider.of<GroupsBloc>(context).add(AddGroupEvent(newGroup));
    // Navigator.pop(context);
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
                decoration:
                InputDecoration(labelText: "اسم المجموعة (اختياري)"),
              ),
              SizedBox(height: 20),

              /*select day*/
              DropdownButtonFormField<int>(
                value: _selectedDay,
                onChanged: (value) => setState(() => _selectedDay = value),
                decoration: InputDecoration(labelText: "اختر اليوم"),
                items: List.generate(
                  7,
                      (index) =>
                      DropdownMenuItem(
                        value: index,
                        child: Text(_getDayName(index)),
                      ),
                ),
              ),
              SizedBox(height: 20),

              /*select time from*/
              TextField(
                controller: _timeFromController,
                readOnly: true,
                decoration: InputDecoration(labelText: "وقت البدء"),
                onTap: () => _pickTime(_timeFromController),
              ),
              SizedBox(height: 20),

              /*Select time to*/
              TextField(
                controller: _timeToController,
                readOnly: true,
                decoration: InputDecoration(labelText: "وقت الانتهاء"),
                onTap: () => _pickTime(_timeToController),
              ),
              SizedBox(height: 20),

              /*Selected students list*/
              _selectedStudentsList(),

              // /// ✅ **استخدام `GestureDetector` لاختيار الطلاب**
              // GestureDetector(
              //   onTap: _selectStudents, // ✅ عند النقر، يتم فتح `BottomSheet`
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       labelText: "اختر الطلاب",
              //       suffixIcon: Icon(Icons.arrow_drop_down), // ✅ أيقونة تشير للقائمة
              //     ),
              //     child: selectedStudents.isEmpty
              //         ? Text("لم يتم اختيار أي طالب")
              //         : Wrap(
              //       children: selectedStudents
              //           .map((student) => Chip(
              //         label: Text(student.name),
              //         onDeleted: () {
              //           setState(() {
              //             selectedStudentsIds.remove(student.id);
              //             selectedStudents.remove(student);
              //           });
              //         },
              //       ))
              //           .toList(),
              //     ),
              //   ),
              // ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),

      /// ✅ **زر حفظ المجموعة في الأسفل**
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveGroup,
          child: Text("حفظ المجموعة"),
        ),
      ),
    );
  }

  /// ✅ **تحويل `day` من رقم إلى اسم اليوم**
  String _getDayName(int day) {
    const days = [
      "الأحد",
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت"
    ];
    return days[day % 7];
  }

  _selectedStudentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /*Title selected students*/
        InkWell(
            onTap: _selectStudents,
            child: Text("selected students")),

        /*Show students list*/
        _selectedStudentsState()
      ],
    );
  }

  _selectedStudentList(SelectedStudents state) {
    var items = state.students;
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
      var item = items[index];
      return Text("selected student : ${item.studentName}");
    },
        separatorBuilder: (context, index) =>
            Container(height: 1, color: Colors.red,),
        itemCount: items.length);
  }

  _selectedStudentsState() {
    return BlocListener<StudentsSelectionBloc, StudentsSelectionState>(
      listener: (context, state) {},
      child: BlocBuilder<StudentsSelectionBloc, StudentsSelectionState>(
        builder: (context, state) {
          print("_selectedStudentsState state:$state");
          if (state is SelectedStudents) {
            return _selectedStudentList(state);
          }
          return Container();
        },
      ),
    );
  }
}
