/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/students/students_bloc.dart';
import '../bloc/students/students_event.dart';
import '../bloc/students/students_state.dart';
import '../models/student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentsBloc>(context).add(LoadStudentsEvent()); // ✅ تحميل الطلاب عند بدء الشاشة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الطلاب"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteAllStudentsDialog(context), // ✅ استدعاء الدالة بعد إضافتها
          ),
        ],
      ),
      body: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is StudentsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentsLoaded) {
            return _buildStudentsList(state.students);
          } else {
            return Center(child: Text("❌ فشل تحميل الطلاب"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /// ✅ **عرض قائمة الطلاب**
  Widget _buildStudentsList(List<Student> students) {
    return students.isEmpty
        ? Center(child: Text("❌ لا يوجد طلاب مسجلين ❌", style: TextStyle(fontSize: 18)))
        : ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return _buildStudentTile(context, students[index]);
      },
    );
  }

  Widget _buildStudentTile(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.phone, color: Colors.green, size: 18), SizedBox(width: 6), Text(student.phone)]),
            Row(children: [Icon(Icons.school, color: Colors.blue, size: 18), SizedBox(width: 6), Text(student.gradeId.toString())]),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteStudentDialog(context, student),
        ),
      ),
    );
  }

  /// ✅ **إضافة طالب جديد**
  void _showAddStudentDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _parentPhoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    int? _selectedGradeId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إضافة طالب جديد"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, "اسم الطالب"),
              _buildTextField(_phoneController, "رقم الهاتف"),
              _buildTextField(_parentPhoneController, "رقم ولي الأمر"),
              _buildDropdownField("اختر الصف الدراسي", (value) => _selectedGradeId = value),
              _buildTextField(_passwordController, "كلمة المرور", isPassword: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty &&
                  _parentPhoneController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _selectedGradeId != null) {
                Student newStudent = Student(
                  id: DateTime.now().toString(),
                  name: _nameController.text,
                  phone: _phoneController.text,
                  parentPhone: _parentPhoneController.text,
                  gradeId: _selectedGradeId!,
                  password: _passwordController.text,
                  accessToken: "",
                );

                BlocProvider.of<StudentsBloc>(context).add(AddStudentEvent(newStudent));

                Navigator.pop(context);
              }
            },
            child: Text("إضافة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ✅ **إضافة رسالة تأكيد عند حذف جميع الطلاب**
  void _showDeleteAllStudentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حذف جميع الطلاب؟"),
        content: Text("هل أنت متأكد أنك تريد حذف جميع الطلاب؟ لا يمكن التراجع عن هذا الإجراء."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BlocProvider.of<StudentsBloc>(context).add(DeleteAllStudentsEvent());
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ✅ **إضافة رسالة تأكيد عند حذف طالب**
  void _showDeleteStudentDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حذف الطالب؟"),
        content: Text("هل أنت متأكد أنك تريد حذف الطالب ${student.name}؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              BlocProvider.of<StudentsBloc>(context).add(DeleteStudentEvent(student.id));
              Navigator.pop(context);
            },
            child: Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: null,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: 1073741824, child: Text("الصف الأول")),
          DropdownMenuItem(value: 1073741825, child: Text("الصف الثاني")),
          DropdownMenuItem(value: 1073741826, child: Text("الصف الثالث")),
        ],
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/screens/students_list/students_controller.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/close_icon_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/error_view_widget.dart';
import 'package:teacher_app/widgets/search_icon_widget.dart';
import 'package:teacher_app/widgets/students/students_list_pagination_widget.dart';
import '../../navigation/app_navigator.dart';
import '../../themes/app_colors.dart';
import '../../utils/message_utils.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/dialog_loading_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_text_field.dart';
import '../student_details/args/student_details_arg_model.dart';
import 'states/students_state.dart';
import '../../widgets/students/student_item_widget.dart';
import '../../widgets/students/student_item_widget.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  StudentsController controller = Get.put(StudentsController());

  bool searchState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: RefreshIndicator(
              onRefresh: () async {
                refresh();
              },
              child: _content()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppNavigator.navigateToAddStudent();
          },
          backgroundColor: AppColors.appMainColor,
          child: Icon(Icons.add, color: Colors.white),
        ));
  }

  _appBar() {
    if (searchState) {
      return AppToolbarWidget.appBar(
          titleWidget: SearchTextField(
            controller: TextEditingController(),
            onChanged: controller.onSearchChanged,
          ),
          hasLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  setState(() {
                    searchState = false;
                    controller.onCloseSearch();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CloseIconWidget(),
                ))
          ]);
    }

    return AppToolbarWidget.appBar(
        title: "Students".tr,
        hasLeading: false,
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  searchState = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SearchIconWidget(),
              ))
        ]);
  }

  Widget _content() {
    return Obx(() {
      var state = controller.state.value;

      switch (state) {
        case StudentsStateLoading():
          return Center(child: LoadingWidget());
        case StudentsStateSuccess():
          return _studentsList(state);
        case StudentsStateError():
          return _error(state);
      }

      return _emptyView();
    });
  }

  refresh() {
    controller.refreshStudents();
  }

  Widget _studentsList(StudentsStateSuccess state) {
    var items = state.uiStates;

    if (items.isEmpty) {
      return _emptyView();
    }

    return _studentsListView(state);
  }

  Widget _emptyView() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Center(
        child: EmptyViewWidget(
          message: "No students found".tr,
        ),
      ),
    );
  }

  Widget _error(StudentsStateError state) {
    return Center(
        child: ErrorViewWidget(
          message: state.message?.toString() ?? "",
          onRetry: refresh,
        ));
  }

  onStudentItemClick(StudentItemUiState p1) {
    AppNavigator.navigateToStudentDetails(StudentDetailsArgModel(id: p1.id));
  }

  onDeleteStudentClick(StudentItemUiState uiState) {
    showConfirmationMessage("${"Are you sure to delete ?".tr} ${uiState.name}",
        () {
      showDialogLoading();
      controller.deleteStudent(uiState).listen(
        (event) {
          hideDialogLoading();
          if (event.isSuccess) {
            return;
          }
          if (event.isError) {
            showErrorMessage(event.error?.toString());
          }
        },
      );
    });
  }

  _studentsListView(StudentsStateSuccess state) {
    return StudentsListPaginationWidget(
        items: state.uiStates,
        onItemSelected: onStudentItemClick,
        isLoading: state.isLoadingMore,
        totalRecord: state.totalRecords,
        separatorBuilder: (context, index) => SizedBox(height: 15),
        getMoreItems: () {
          controller.getMoreStudents();
        });
  }


}
