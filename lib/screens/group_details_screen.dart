import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups/groups_bloc.dart';
import '../bloc/groups/groups_event.dart';
import '../bloc/groups/groups_state.dart';
import '../models/group.dart';
import '../models/student.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  /// ✅ **تحديث حضور الطالب**
  void _toggleAttendance(BuildContext context, String groupId, Student student) {
    Student updatedStudent = student.copyWith(attended: !student.attended);
    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(
        groupId: updatedStudent.id,  updatedStudent:updatedStudent));
  }

  /// ✅ **تحديث إنجاز الواجب**
  void _toggleHomework(BuildContext context, String groupId, Student student) {
    Student updatedStudent = student.copyWith(homeworkDone: !student.homeworkDone);
    BlocProvider.of<GroupsBloc>(context).add(UpdateStudentInGroupEvent(
        groupId: updatedStudent.id, updatedStudent: updatedStudent));
  }

  /// ✅ **تأكيد حذف الطالب**
  void _confirmDeleteStudent(BuildContext context, String groupId, String studentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("حذف الطالب"),
          content: Text("هل أنت متأكد أنك تريد حذف الطالب؟"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
            TextButton(
              onPressed: () {
                BlocProvider.of<GroupsBloc>(context).add(DeleteStudentFromGroupEvent(groupId: groupId, studentId: studentId));
                Navigator.pop(context);
              },
              child: Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name ?? "تفاصيل المجموعة"),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoaded) {
            final updatedGroup = state.groups.firstWhere((g) => g.id == group.id, orElse: () => group);
            return _buildStudentList(updatedGroup);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// ✅ **عرض قائمة الطلاب**
  Widget _buildStudentList(Group updatedGroup) {
    return updatedGroup.studentsIds.isEmpty
        ? Center(child: Text("❌ لا يوجد طلاب في هذه المجموعة ❌", style: TextStyle(fontSize: 18)))
        : ListView.builder(
      itemCount: updatedGroup.studentsIds.length,
      itemBuilder: (context, index) {
        final student = updatedGroup.studentsIds[index];
        return _buildStudentTile(context, updatedGroup.id, student);
      },
    );
  }

  /// ✅ **عرض معلومات الطالب مع خيارات الحضور والواجب والحذف**
  Widget _buildStudentTile(BuildContext context, String groupId, Student student) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudentScreen( student: student)),
              ),
              child: ListTile(
                title: Text(student.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📞 ${student.phone}"),
                    Text("📚 ${student.gradeId}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteStudent(context, groupId, student.id),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton(
                  icon: student.homeworkDone ? Icons.check_circle : Icons.cancel,
                  label: student.homeworkDone ? "تم الواجب" : "لم يتم الواجب",
                  color: student.homeworkDone ? Colors.blue : Colors.red,
                  onTap: () => _toggleHomework(context, groupId, student),
                ),
                _buildStatusButton(
                  icon: student.attended ? Icons.check_circle : Icons.close,
                  label: student.attended ? "حضر" : "غائب",
                  color: student.attended ? Colors.green : Colors.red,
                  onTap: () => _toggleAttendance(context, groupId, student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ **زر تغيير الحالة (حضور/غياب - واجب تم/لم يتم)**
  Widget _buildStatusButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
