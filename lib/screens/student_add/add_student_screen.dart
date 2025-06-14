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
import 'package:teacher_app/screens/create_group/grades/grades_selection_state.dart';
import 'package:teacher_app/screens/student_add/add_student_controller.dart';
import 'package:teacher_app/screens/student_add/states/add_student_state.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import '../../themes/app_colors.dart';
import '../../widgets/app_text_field_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../../widgets/item_selection_widget/student_list_selection_widget.dart';
import '../student_edit/states/update_student_state.dart';
import '../students_list/students_controller.dart';

class AddStudentScreen extends StatefulWidget {

  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => AddStudentScreenState();
}

class AddStudentScreenState extends State<AddStudentScreen> {

  final AddStudentController _controller = Get.put(AddStudentController());

  @override
  void initState() {
    super.initState();
  }

  AddStudentController getController() => _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(getScreenTitle()),
      body: _content(),
      bottomNavigationBar: _saveButton(),
    );
  }

  _content() {
    return GestureDetector(
      onTapDown: (details) => KeyboardUtils.hideKeyboard(context),
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: getController().formKey,
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _nameField(),
                  _parentPhoneField(),
                  _phoneField(),
                  _gradeField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _nameField() => AppTextFieldWidget(
        controller: getController().nameController,
        label: "Student Name".tr,
        hint: "Student Name".tr,
        validator: MultiValidator([
          RequiredValidator(errorText: "Student Name is required".tr),
        ]).call,
      );

  _parentPhoneField() => AppTextFieldWidget(
        controller: getController().parentPhoneController,
        label: "Parent Phone".tr,
        hint: "Parent Phone".tr,
        validator: MultiValidator([
          RequiredValidator(errorText: "Parent Phone is required".tr),
        ]).call,
      );

  _phoneField() => AppTextFieldWidget(
        controller: getController().phoneController,
        label: "Phone".tr,
        hint: "Phone".tr,
        validator: MultiValidator([]).call,
      );

  _gradeField() {
    return Obx(() {
      return AppTextFieldWidget(
        controller: TextEditingController(
            text: getController().selectedGrade.value?.name),
        label: "Grade".tr,
        hint: "Grade".tr,
        readOnly: true,
        suffixIcon: Icon(Icons.arrow_downward),
        validator: MultiValidator([
          RequiredValidator(errorText: "Grade is required".tr),
        ]).call,
        onTap: _onSelectGradesClick,
      );
    });
  }

  _saveButton() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButtonWidget(
          onClick: onSaveGroupClick,
          text: getSubmitButtonText(),
        ),
      );

  void _onSelectGradesClick() {
    var bottomSheetWidget = Obx(() {
      _controller.checkGradesState();
      var value = getController().gradeSelectionState.value;
      switch (value) {
        case GradesSelectionStateError():
          return _errorMessageView(value.message);
        case GradesSelectionStateSuccess():
          return SizedBox(
              // height: Get.height * .9,
              width: double.infinity,
              child: ItemSelectionWidget(
                items: value.items,
                title: "Select Grade",
                isSingleSelection: true,
                onSaved: (selectedItems) =>
                    getController().onSelectedGrade(selectedItems.firstOrNull),
              ));
      }
      return LoadingWidget();
    });

    Get.bottomSheet(bottomSheetWidget,
        backgroundColor: AppColors.white,
        // isScrollControlled: true,
        useRootNavigator: true,
        // ignoreSafeArea: false,
        enableDrag: true);
  }

  void onSaveSuccess(SaveStateSuccess result) {
    Get.back(result: true);
  }

  String getScreenTitle() {
    return "Add Student".tr;
  }

  String getSubmitButtonText() {
    return "Add Student".tr;
  }

  void onSaveGroupResult(AddStudentState event) {
    var result = event;
    hideDialogLoading();
    switch (result) {
      case AddStudentStateLoading():
        showDialogLoading();
        break;
      case SaveStateSuccess():
        onSaveSuccess(result);
        break;
      case AddStudentStateFormValidation():
        break;
      case AddStudentStateError():
        showErrorMessagePopup(result.exception?.toString() ?? "");
    }
  }

  Widget _errorMessageView(String message) {
    return AppTextWidget(message);
  }

  void onSaveGroupClick() {
    getController().onSave().listen(
      (event) {
        onSaveGroupResult(event);
      },
    );
  }
}
