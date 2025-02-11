/*import '../../models/group.dart';
import '../../models/student.dart';

abstract class GroupsEvent {}

class LoadGroupsEvent extends GroupsEvent {}

class AddGroupEvent extends GroupsEvent {
  final Group group;
  AddGroupEvent(this.group);
}

class AddStudentToGroupEvent extends GroupsEvent {
  final Group group;
  final Student newStudent;

  AddStudentToGroupEvent(this.group, this.newStudent);
}

class DeleteStudentFromGroupEvent extends GroupsEvent {
  final Group group;
  final Student student;

  DeleteStudentFromGroupEvent(this.group, this.student, {required String groupId});
}

class UpdateStudentInGroupEvent extends GroupsEvent {
  final Group group;
  final Student updatedStudent;

  UpdateStudentInGroupEvent(this.group, this.updatedStudent);
}
class DeleteAllGroupsEvent extends GroupsEvent {}

class UpdateGroupEvent extends GroupsEvent {
  final Group updatedGroup;

  UpdateGroupEvent(this.updatedGroup);



}

class DeleteGroupEvent extends GroupsEvent {
  final Group group;

  DeleteGroupEvent(this.group);
}

*/


import '../../models/group.dart';
import '../../models/student.dart';

abstract class GroupsEvent {}

class LoadGroupsEvent extends GroupsEvent {}

class AddGroupEvent extends GroupsEvent {
  final Group group;
  AddGroupEvent(this.group);
}

class AddStudentToGroupEvent extends GroupsEvent {
  final String groupId; // ✅ استخدام `groupId` بدلاً من الكائن `Group`
  final Student newStudent;

  AddStudentToGroupEvent({required this.groupId, required this.newStudent});
}

class DeleteStudentFromGroupEvent extends GroupsEvent {
  final String groupId; // ✅ استخدام `groupId` فقط
  final String studentId; // ✅ حذف عبر `studentId` فقط

  DeleteStudentFromGroupEvent({required this.groupId, required this.studentId});
}

class UpdateStudentInGroupEvent extends GroupsEvent {
  final String groupId; // ✅ تحديث الطالب داخل المجموعة عبر `groupId`
  final Student updatedStudent;

  UpdateStudentInGroupEvent({required this.groupId, required this.updatedStudent});
}

class DeleteAllGroupsEvent extends GroupsEvent {}

class UpdateGroupEvent extends GroupsEvent {
  final Group updatedGroup;
  UpdateGroupEvent(this.updatedGroup);
}

class DeleteGroupEvent extends GroupsEvent {
  final String groupId; // ✅ حذف المجموعة عبر `groupId`
  DeleteGroupEvent(this.groupId);
}
