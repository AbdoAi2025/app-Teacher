import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/bloc/create_group/create_groups_event.dart';
import 'package:teacher_app/bloc/create_group/create_groups_state.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import '../../services/api_service.dart';
import '../../models/group.dart';
import '../groups/groups_event.dart';
import '../groups/groups_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupsEvent, CreateGroupsState> {


  final GroupsRepository groupsRepository = GroupsRepository();

  List<Group> groups = [];

  CreateGroupBloc() : super(CreateGroupsInitial()) {
    // on<LoadMyStudentsWithoutGroupsEvent>(_onLoadMyStudentsWithoutGroups);
    // on<LoadGradesEvent>(_onLoadGrades);
  }




  /*Add group*/
  Future<void> _onAddGroup(CreateGroupsEvent event, Emitter<CreateGroupsState> emit) async {
    // try {
    //   await apiService.createGroup(event.group); // ✅ إرسال البيانات إلى API
    //
    //   final groups = await apiService.fetchGroups(); // ✅ تحديث القائمة بعد الإضافة
    //
    //   emit(GroupsLoaded(groups)); // ✅ تحديث الحالة بـ المجموعات الجديدة
    //
    //   await _fetchUpdatedGroups(emit); // ✅ تحديث القائمة بعد الإضافة
    // } catch (e) {
    //   emit(GroupsError("❌ فشل إضافة المجموعة: $e"));
    // }
  }

}
