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
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/close_icon_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/error_view_widget.dart';
import 'package:teacher_app/widgets/filters/current_filters_display_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import 'package:teacher_app/widgets/search_icon_widget.dart';
import 'package:teacher_app/widgets/students/students_list_pagination_widget.dart';
import '../../navigation/app_navigator.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../utils/Keyboard_utils.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/sort_icon_widget.dart';
import '../../widgets/filters/grade_filter_chip_widget.dart';
import '../../widgets/filters/has_group_filter_chip_widget.dart';
import 'widgets/students_empty_view_widget.dart';
import '../student_details/args/student_details_arg_model.dart';
import 'states/students_state.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends LifecycleWidgetState<StudentsScreen> {

  StudentsController controller = Get.put(StudentsController());
  bool searchState = false;
  TextEditingController searchController = TextEditingController();
  String currentSearchText = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: GestureDetector(
              onTapDown: (v) {
                KeyboardUtils.hideKeyboard(context);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(15),
                child: RefreshIndicator(
                    onRefresh: () async {
                      refresh();
                    },
                    child: _content()),
              )),
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
      return _searchAppBar();
    }
    return _appBarWithActions();
  }

  _appBarWithActions() => AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    automaticallyImplyLeading: false,
    toolbarHeight: 0,
  );

  _searchAppBar() => AppToolbarWidget.appBar(
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
      ]
  );

  _searchIcon() =>  InkWell(
      onTap: () {
        setState(() {
          searchState = true;
        });
      },
      child: SearchIconWidget()
  );

  _sortIcon() =>  InkWell(
      onTap: onSortClick,
      child: SortIconWidget()
  );

  Widget _content() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(height: 12),
            _header(),
            SizedBox(height: 12),
            _searchAndSortBar(),
            SizedBox(height: 16),
          ],
        ),
        Expanded(
          child: Obx(() {
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
          }),
        ),
      ],
    );
  }


  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _filterIcon(),
        ),
        Container(
          width: 1,
          height: 35,
          color: AppColors.color_DBD5CC.withValues(alpha: 0.6),
          padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 4),
          margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 4),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                CurrentFiltersDisplayWidget(filterManager: controller.dateFilterManager),
                _gradeFilterChip(),
                _hasGroupFilterChip(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _title() {
    return AppTextWidget(
      "Students".tr,
      style: AppTextStyle.title.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.colorBlack,
      ),
    );
  }

  _filterChips() {
    return Wrap(
      spacing: 15,
      children: [
        CurrentFiltersDisplayWidget(filterManager: controller.dateFilterManager,),
        _gradeFilterChip(),
      ],
    );
  }

  Widget _gradeFilterChip() {
    return GradeFilterChipWidget(
      selectedGrade: controller.selectedGradeFilter,
      onSelected: controller.onGradeFilterSelected,
      onReset: controller.resetGradeFilter,
    );
  }

  Widget _hasGroupFilterChip() {
    return HasGroupFilterChipWidget(
      hasGroupFilter: controller.hasGroupFilter,
      onCycle: controller.onHasGroupFilterCycle,
      onReset: controller.resetHasGroupFilter,
    );
  }

  Widget _searchAndSortBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.colorOffWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.color_DBD5CC.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _searchField(),
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 32,
            color: AppColors.color_DBD5CC.withValues(alpha: 0.5),
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Sort button
          _unifiedActionButton(
            icon: Icons.sort_rounded,
            color: AppColors.primaryButtonColor,
            onTap: onSortClick,
            tooltip: 'Sort'.tr,
          ),
        ],
      ),
    );
  }

  Widget _unifiedActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  _searchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          currentSearchText = value;
        });
        controller.onSearchChanged(value);
      },
      style: AppTextStyle.label.copyWith(
        fontSize: 14,
        color: AppColors.colorBlack,
      ),
      decoration: InputDecoration(
        hintText: 'Search students...'.tr,
        hintStyle: AppTextStyle.label.copyWith(
          color: AppColors.textSecondaryColor,
          fontSize: 14,
        ),
        prefixIcon: Container(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondaryColor,
            size: 20,
          ),
        ),
        suffixIcon: currentSearchText.isNotEmpty
            ? Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                currentSearchText = '';
              });
              searchController.text = '';
              controller.onCloseSearch();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.textSecondaryColor,
                size: 20,
              ),
            ),
          ),
        )
            : null,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
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
    return Center(
      child: StudentsEmptyViewWidget(onRetry: refresh),
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



  _studentsListView(StudentsStateSuccess state) {
    return StudentsListPaginationWidget(
        items: state.uiStates,
        onItemSelected: onStudentItemClick,
        isLoading: state.isLoadingMore,
        totalRecord: state.totalRecords,
        padding: EdgeInsets.only(bottom: 15),
        separatorBuilder: (context, index) => SizedBox(height: 15),
        getMoreItems: () {
          controller.getMoreStudents();
        });
  }

  void onSortClick() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextWidget("Sort".tr),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  InkWell(onTap: onSortByGroupClick , child: AppTextWidget("By group".tr)),
                  InkWell(onTap: onSortByGradeClick ,  child: AppTextWidget("By grade".tr)),
                  InkWell(onTap: onSortResetClick ,  child: AppTextWidget("Reset".tr)),
                ],
              ),
            ),
          ],
        ),
      );
    },);
  }

  void onSortByGroupClick() {
    Get.back();
    controller.sortByGroup();
  }

  void onSortByGradeClick() {
    Get.back();
    controller.sortByGrade();
  }

  void onSortResetClick() {
    Get.back();
    controller.resetSort();
  }

  @override
  void onResumedNavigatedBack() {
    controller.onResume();
  }

  Widget _filterIcon() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.appMainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.tune_rounded,
        size: 18,
        color: AppColors.appMainColor,
      ),
    );
  }




}
