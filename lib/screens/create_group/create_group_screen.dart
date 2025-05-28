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
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:teacher_app/bloc/create_group/create_groups_state.dart';
import 'package:teacher_app/screens/create_group/states/create_group_state.dart';
import 'package:teacher_app/screens/create_group/students_selection/states/students_selection_state.dart';
import 'package:teacher_app/screens/groups/groups_controller.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import '../../bottomsheets/week_days_selection_bottom_sheet.dart';
import '../../models/student.dart';
import '../../themes/app_colors.dart';
import '../../widgets/app_text_field_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../login/login_state.dart';
import 'create_group_controller.dart';
import 'students_selection/student_list_selection_widget.dart';
import 'students_selection/states/student_selection_item_ui_state.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final GroupsController _groupsController = Get.find();

  final CreateGroupController _controller = Get.put(CreateGroupController());

  int? _selectedDay;
  List<Student> studentsList = [];
  List<Student> selectedStudents = [];
  List<Student> selectedStudentsIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar("Create Group".tr),
      body: _content(),
      bottomNavigationBar: _saveButton(),
    );
  }

  _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _groupNameField(),
              /*select day*/
              _dayField(),
              /*select time from*/
              _timeFromField(),
              /*Select time to*/
              _timeToField(),
              /*Selected students list*/
              _selectedStudentsList(),
            ],
          ),
        ),
      ),
    );
  }

  _groupNameField() => AppTextFieldWidget(
        controller: _controller.nameController,
        label: "Group Name".tr,
        hint: "Group Name".tr,
        validator: MultiValidator([
          RequiredValidator(errorText: "Group Name is required".tr),
        ]).call,
      );

  _dayField() => Obx(() {
        var day = _controller.selectedDayRx.value;
        return AppTextFieldWidget(
          controller: TextEditingController(text: getDayName(day)),
          label: "Select Day".tr,
          hint: "Select Day".tr,
          readOnly: true,
          onTap: () {
            _selectDay();
          },
          prefixIcon: Icon(Icons.calendar_today_outlined),
          validator: MultiValidator([
            RequiredValidator(errorText: "Day is required".tr),
          ]).call,
        );
      });

  _timeField(TimeOfDay? time, String label, Function(TimeOfDay) onTimeSelected,
      {required String? Function(dynamic value) validator}) {
    return AppTextFieldWidget(
      controller: TextEditingController(text: _controller.getTimeFormat(time)),
      label: label,
      hint: label,
      readOnly: true,
      onTap: () {
        _pickTime(time, onTimeSelected);
      },
      validator: validator,
      prefixIcon: Icon(Icons.access_time),
    );
  }

  _timeFromField() => Obx(() {
        var time = _controller.selectedTimeFromRx.value;
        return _timeField(
            time,
            "Select Time From".tr,
            validator: MultiValidator([
              RequiredValidator(errorText: "Time From required".tr),
            ]).call,
            (pickedTime) => _controller.onTimeFromSelected(pickedTime));
      });

  _timeToField() => Obx(() {
        var time = _controller.selectedTimeToRx.value;
        return _timeField(
            time,
            "Select Time To".tr,
            validator: MultiValidator([
              RequiredValidator(errorText: "Time to required".tr),
            ]).call,
            (pickedTime) => _controller.onTimeToSelected(pickedTime));
      });

  _saveButton() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButtonWidget(
          onClick: _saveGroup,
          text: "Create Group".tr,
        ),
      );

  void _pickTime(TimeOfDay? initial, Function(TimeOfDay) onTimeSelected) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  /*Select day*/
  void _selectDay() {
    WeekDaysSelectionBottomSheet.showBottomSheet(
        (index) => _controller.onDaySelected(index));
  }

  void _saveGroup() {
    _controller.createGroup().listen(
      (event) {
        var result = event;
        hideDialogLoading();
        switch (result) {
          case CreateGroupStateLoading():
            showDialogLoading();
            break;
          case CreateGroupStateSuccess():
            onCreateGroupSuccess(result);
            break;
          case CreateGroupStateFormValidation():
            break;
          case CreateGroupStateError():
            showError(result);
        }
      },
    );
  }

  _selectedStudentsList() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /*Title selected students*/
        InkWell(
            onTap: _onSelectStudentsClick,
            child: Row(
              children: [
                Expanded(child: AppTextWidget("selected students".tr)),
                Icon(Icons.arrow_downward)
              ],
            )),
        /*Show students list*/
        _selectedStudentsState()
      ],
    );
  }

  void _onSelectStudentsClick() {
    var bottomSheetWidget = Obx(() {
      var value = _controller.studentsSelectionState.value;
      switch (value) {
        case StudentsSelectionStateError():
          return _errorMessage(value);
        case StudentsSelectionStateSuccess():
          return SizedBox(
              height: Get.height * .9,
              width: double.infinity,
              child: StudentListSelectionWidget(
                students: value.students,
                onSaved: (students) => _controller.onSelectedStudents(students),
              ));
      }
      return LoadingWidget();
    });

    Get.bottomSheet(bottomSheetWidget,
        backgroundColor: AppColors.white,
        isScrollControlled: true,
        useRootNavigator: true,
        // ignoreSafeArea: false,
        enableDrag: true);
  }

  _selectedStudentsState() {
    return Obx(() {
      var selectedStudents = _controller.selectedStudents.value;
      return _selectedStudentList(selectedStudents);
    });
  }

  _selectedStudentList(List<StudentSelectionItemUiState> students) {
    var items = students;

    if (items.isEmpty) {
      return _emptyStudentsSelection();
    }

    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = items[index];
          return _selectedStudentItem(item);
        },
        separatorBuilder: (context, index) => Container(
              height: 10,
            ),
        itemCount: items.length);
  }

  Widget _errorMessage(StudentsSelectionStateError value) {
    return Text(value.message);
  }

  _selectedStudentItem(StudentSelectionItemUiState item) {
    return Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AppTextWidget(item.studentName),
              Spacer(),
              InkWell(
                  onTap: () => _controller.onRemoveStudentClick(item),
                  child: Icon(Icons.remove))
            ],
          ),
        ));
  }

  void showError(CreateGroupStateError result) {
    Get.snackbar("Error", result.exception.toString());
  }

  _emptyStudentsSelection() {
    return Center(
      child: AppTextWidget("No students Selected".tr),
    );
  }

  void onCreateGroupSuccess(CreateGroupStateSuccess result) {
    _groupsController.refreshGroups();
    Get.back();
  }
}
