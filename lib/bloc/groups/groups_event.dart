import '../../models/group.dart';
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

  DeleteStudentFromGroupEvent(this.group, this.student);
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

  get group => null;

}

class DeleteGroupEvent extends GroupsEvent {
  final Group group;

  DeleteGroupEvent(this.group);
}

