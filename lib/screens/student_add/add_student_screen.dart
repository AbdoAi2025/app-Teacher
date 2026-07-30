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
import 'package:teacher_app/data/responses/get_students_by_parent_phone_response.dart';
import 'package:teacher_app/screens/create_group/grades/select_grade_bottom_sheet.dart';
import 'package:teacher_app/screens/student_add/add_student_controller.dart';
import 'package:teacher_app/screens/student_add/states/add_student_state.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_shared/widgets/app_phone_input_text_field_widget.dart';
import '../../dialogs/user_not_subscribed_dialog.dart';
import '../../validations/phone_validation.dart';
import '../../widgets/app_text_field_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../../widgets/dropdown_icon_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

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
    _controller.onStudentsFound = _showStudentPickerBottomSheet;
  }

  AddStudentController getController() => _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: getScreenTitle()),
      body: _content(),
      bottomNavigationBar: SafeArea(child: _saveButton()),
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
                  Column(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _parentPhoneField(),
                      checkStudentsButton(),
                    ],
                  ),
                  _nameField(),
                  _phoneField(),
                  gradeField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return Obx(() {
      final enabled = getController().fieldsEnabled.value;
      return AppTextFieldWidget(
        controller: getController().nameController,
        label: AppStringsKeys.studentName.tr,
        hint: AppStringsKeys.studentName.tr,
        enabled: enabled,
        validator: MultiValidator([
          RequiredValidator(errorText: AppStringsKeys.studentNameIsRequired.tr),
        ]).call,
      );
    });
  }

  Widget _parentPhoneField() => AppPhoneInputTextFieldWidget(
        phoneController: getController().parentPhoneController,
        label: AppStringsKeys.parentPhone.tr,
        onContactSelected: (_, name) {
          if (_controller.nameController.text.isEmpty) {
            _controller.nameController.text = name;
          }
        },
        validator: MultiValidator([
          RequiredValidator(errorText: AppStringsKeys.parentPhoneIsRequired.tr),
          PhoneValidation(errorText: "Please enter valid phone number".tr),
        ]).call,
      );

  Widget _phoneField() {
    return Obx(() {
      final enabled = getController().fieldsEnabled.value;
      return AppPhoneInputTextFieldWidget(
        phoneController: getController().phoneController,
        label: AppStringsKeys.phone.tr,
        enabled: enabled,
        validator: MultiValidator([]).call,
      );
    });
  }

  Widget checkStudentsButton() {
    return Obx(() {
      final loading = getController().isSearchingByPhone.value;
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: GestureDetector(
          onTap: loading ? null : () {
            KeyboardUtils.hideKeyboard(context);
            getController().searchByParentPhone();
          },
          child: loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Check Students'.tr,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
        ),
      );
    });
  }



  Widget gradeField() {
    return Obx(() {
      final ctrl = getController();
      final isStudentSelected = ctrl.selectedStudentId.value != null;
      final gradeText = isStudentSelected
          ? ctrl.gradeDisplayName.value
          : ctrl.selectedGrade.value?.name ?? '';
      final gradeEnabled = !isStudentSelected && ctrl.fieldsEnabled.value;
      return AppTextFieldWidget(
        controller: TextEditingController(text: gradeText),
        label: AppStringsKeys.grade.tr,
        hint: AppStringsKeys.grade.tr,
        readOnly: true,
        enabled: gradeEnabled,
        suffixIcon: gradeEnabled ? DropdownIconWidget() : null,
        validator: (value) {
          if (isStudentSelected) return null;
          return RequiredValidator(
                  errorText: AppStringsKeys.gradeIsRequired.tr)
              .call(value);
        },
        onTap: gradeEnabled ? _onSelectGradesClick : null,
      );
    });
  }

  Widget _saveButton() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButtonWidget(
          onClick: onSaveClick,
          text: getSubmitButtonText(),
        ),
      );

  void _onSelectGradesClick() {
    SelectGradeBottomSheet.show(
      context,
      selectedId: getController().selectedGrade.value?.id,
      onSelected: (grade) => getController().onSelectedGrade(grade),
    );
  }

  void _showStudentPickerBottomSheet(List<StudentByParentPhoneApiModel> students) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _StudentPickerBottomSheet(
        students: students,
        onStudentSelected: (student) {
          Navigator.pop(ctx);
          getController().onStudentSelected(student);
        },
        onCreateNew: () {
          Navigator.pop(ctx);
          getController().onCreateNewStudent();
        },
      ),
    );
  }

  void onSaveSuccess(SaveStateSuccess result) {
    Get.back(result: true);
  }

  String getScreenTitle() {
    return AppStringsKeys.addStudent.tr;
  }

  String getSubmitButtonText() {
    return AppStringsKeys.addStudent.tr;
  }

  void onSaveStudentResult(AddStudentState event) {
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

  void onSaveClick() {
    getController().onSave().listen(
      (event) {
        appLog("onSaveClick :event :$event");
        if (event is AddStudentStateSubscriptionIssue) {
          hideDialogLoading();
          UserNotSubscribedDialog.showUserNotSubscribedDialog(
              message: event.message ?? "", barrierDismissible: true);
        } else {
          onSaveStudentResult(event);
        }
      },
    );
  }
}

class _StudentPickerBottomSheet extends StatelessWidget {
  final List<StudentByParentPhoneApiModel> students;
  final Function(StudentByParentPhoneApiModel) onStudentSelected;
  final VoidCallback onCreateNew;

  const _StudentPickerBottomSheet({
    required this.students,
    required this.onStudentSelected,
    required this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Select Student'.tr,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final student = students[i];
                    final alreadyAdded = student.addedToMe == true;
                    return ListTile(
                      title: Text(
                        student.studentName ?? '',
                        style: TextStyle(
                          color: alreadyAdded ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Text(
                        student.gradeName,
                        style: TextStyle(
                          color: alreadyAdded ? Colors.grey[400] : null,
                        ),
                      ),
                      trailing: alreadyAdded
                          ? Text(
                              'Already Added'.tr,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            )
                          : const Icon(Icons.chevron_right),
                      enabled: !alreadyAdded,
                      onTap: alreadyAdded ? null : () => onStudentSelected(student),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCreateNew,
                  child: Text('Create New Student'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
