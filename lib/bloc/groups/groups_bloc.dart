
/*import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/group.dart';
import '../../models/student.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  List<Group> groups = [];
  final Box _groupsBox = Hive.box('groupsBox'); // ✅ صندوق تخزين المجموعات

  GroupsBloc() : super(GroupsInitial()) {
    on<LoadGroupsEvent>((event, emit) {
      emit(GroupsLoading());
      _loadGroupsFromHive();
      emit(GroupsLoaded(groups));
    });

    on<AddGroupEvent>((event, emit) {
      groups.add(event.group);
      _saveGroupsToHive();
      emit(GroupsLoaded(groups));
    });

    on<AddStudentToGroupEvent>((event, emit) {
      final updatedGroups = groups.map((g) {
        if (g.id == event.group.id) {
          return g.copyWith(
            students: List.from(g.students)
              ..add(event.newStudent),
          );
        }
        return g;
      }).toList();

      groups = updatedGroups;
      _saveGroupsToHive(); // ✅ حفظ التعديلات في `Hive`
      emit(
          GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا بعد الإضافة
    });

    on<DeleteStudentFromGroupEvent>((event, emit) {
      for (var g in groups) {
        if (g.id == event.group.id) {
          g.students.removeWhere((s) => s.id == event.student.id);
        }
      }
      _saveGroupsToHive();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الـ UI فورًا
    });

    on<DeleteAllGroupsEvent>((event, emit) {
      groups.clear();
      _saveGroupsToHive();
      emit(GroupsLoaded(groups));
    });

    // ✅ تحديث بيانات الطالب داخل المجموعة
    on<UpdateStudentInGroupEvent>((event, emit) {
      final updatedGroups = groups.map((g) {
        if (g.id == event.group.id) {
          return g.copyWith(
            students: g.students.map((s) {
              return (s.id == event.updatedStudent.id)
                  ? event.updatedStudent.copyWith()
                  : s;
            }).toList(),
          );
        }
        return g;
      }).toList();

      groups = updatedGroups;
      _saveGroupsToHive(); // ✅ حفظ التعديلات في `Hive`
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا
    });


    void _loadGroupsFromHive() {
      final storedGroups = _groupsBox.get('groups', defaultValue: []);
      if (storedGroups.isNotEmpty) {
        groups = List<Group>.from(
          storedGroups.map((g) => Group.fromMap(Map<String, dynamic>.from(g))),
        );
        emit(GroupsLoaded(groups));
      }
    }

    void _saveGroupsToHive() {
      final groupMaps = groups.map((g) => g.toMap()).toList();
      _groupsBox.put('groups', groupMaps);
    }
  }
}
*/



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/group.dart';
import '../../models/student.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  List<Group> groups = [];
  final Box _groupsBox = Hive.box('groupsBox'); // ✅ صندوق تخزين المجموعات

  GroupsBloc() : super(GroupsInitial()) {
    on<LoadGroupsEvent>((event, emit) {
      emit(GroupsLoading());
      _loadGroupsFromHive();
      emit(GroupsLoaded(groups));
    });

    on<AddGroupEvent>((event, emit) {
      groups.add(event.group);
      _saveGroupsToHive();
      emit(GroupsLoaded(groups));
    });

    on<AddStudentToGroupEvent>((event, emit) {
      final updatedGroups = groups.map((g) {
        if (g.id == event.group.id) {
          return g.copyWith(
            students: List.from(g.students)..add(event.newStudent),
          );
        }
        return g;
      }).toList();

      groups = updatedGroups;
      _saveGroupsToHive(); // ✅ حفظ التعديلات في `Hive`
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا بعد الإضافة
    });

    on<DeleteStudentFromGroupEvent>((event, emit) {
      for (var g in groups) {
        if (g.id == event.group.id) {
          g.students.removeWhere((s) => s.id == event.student.id);
        }
      }
      _saveGroupsToHive();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الـ UI فورًا
    });

    on<DeleteAllGroupsEvent>((event, emit) {
      groups.clear();
      _saveGroupsToHive();
      emit(GroupsLoaded(groups));
    });


    on<UpdateGroupEvent>((event, emit) {
      final updatedGroups = groups.map((g) {
        return g.id == event.updatedGroup.id ? event.updatedGroup : g;
      }).toList();

      groups = updatedGroups;
      _saveGroupsToHive();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا بعد التعديل
    });

    on<DeleteGroupEvent>((event, emit) {
      groups.removeWhere((g) => g.id == event.group.id);
      _saveGroupsToHive();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا بعد الحذف
    });



    // ✅ تحديث بيانات الطالب داخل المجموعة
    on<UpdateStudentInGroupEvent>((event, emit) {
      final updatedGroups = groups.map((g) {
        if (g.id == event.group.id) {
          return g.copyWith(
            students: g.students.map((s) {
              return (s.id == event.updatedStudent.id)
                  ? s.copyWith(
                name: event.updatedStudent.name,
                phone: event.updatedStudent.phone,
                grade: event.updatedStudent.grade,
                password: event.updatedStudent.password,
                attended: event.updatedStudent.attended,
                homeworkDone: event.updatedStudent.homeworkDone,
              )
                  : s;
            }).toList(),
          );
        }
        return g;
      }).toList();

      groups = updatedGroups;
      _saveGroupsToHive(); // ✅ حفظ التعديلات في `Hive`
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة فورًا
    });
  }

  void _loadGroupsFromHive() {
    final storedGroups = _groupsBox.get('groups', defaultValue: []);
    if (storedGroups.isNotEmpty) {
      groups = List<Group>.from(
        storedGroups.map((g) => Group.fromMap(Map<String, dynamic>.from(g))),
      );
      emit(GroupsLoaded(groups));
    }
  }

  void _saveGroupsToHive() {
    final groupMaps = groups.map((g) => g.toMap()).toList();
    _groupsBox.put('groups', groupMaps);
  }
}

