import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/group.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final ApiService apiService;
  List<Group> groups = []; // ✅ قائمة محلية للمجموعات

  GroupsBloc({required this.apiService}) : super(GroupsInitial()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<AddGroupEvent>(_onAddGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<DeleteAllGroupsEvent>(_onDeleteAllGroups);
  }

  /// ✅ **تحميل جميع المجموعات من API**
  Future<void> _onLoadGroups(LoadGroupsEvent event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading()); // 🔄 إظهار تحميل البيانات
    try {
      final response = await apiService.fetchGroups(); // ✅ جلب البيانات من API
      groups = (response as List).map((g) => Group.fromJson(g as Map<String, dynamic>)).toList();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث الواجهة بالبيانات الجديدة
    } catch (e) {
      emit(GroupsError("❌ فشل تحميل المجموعات: $e")); // ❌ في حال فشل الاتصال
    }
  }

  /// ✅ **إضافة مجموعة جديدة**
  Future<void> _onAddGroup(AddGroupEvent event, Emitter<GroupsState> emit) async {
    try {
      await apiService.createGroup(event.group); // ✅ إرسال البيانات إلى API
      await _fetchUpdatedGroups(emit); // ✅ تحديث القائمة بعد الإضافة
    } catch (e) {
      emit(GroupsError("❌ فشل إضافة المجموعة: $e"));
    }
  }

  /// ✅ **تحديث بيانات المجموعة**
  Future<void> _onUpdateGroup(UpdateGroupEvent event, Emitter<GroupsState> emit) async {
    try {
      await apiService.updateGroup(event.group); // ✅ إرسال البيانات إلى API
      await _fetchUpdatedGroups(emit); // ✅ تحديث القائمة بعد التعديل
    } catch (e) {
      emit(GroupsError("❌ فشل تحديث المجموعة: $e"));
    }
  }

  /// ✅ **حذف مجموعة معينة**
  Future<void> _onDeleteGroup(DeleteGroupEvent event, Emitter<GroupsState> emit) async {
    try {
      await apiService.deleteGroup(event.group.id); // ✅ حذف المجموعة عبر API
      await _fetchUpdatedGroups(emit); // ✅ تحديث القائمة بعد الحذف
    } catch (e) {
      emit(GroupsError("❌ فشل حذف المجموعة: $e"));
    }
  }

  /// ✅ **حذف جميع المجموعات**
  Future<void> _onDeleteAllGroups(DeleteAllGroupsEvent event, Emitter<GroupsState> emit) async {
    try {
      await apiService.deleteAllGroups(); // ✅ إرسال طلب حذف كل البيانات
      await _fetchUpdatedGroups(emit); // ✅ تحميل البيانات بعد الحذف
    } catch (e) {
      emit(GroupsError("❌ فشل حذف جميع المجموعات: $e"));
    }
  }

  /// ✅ **جلب البيانات المحدثة من API**
  Future<void> _fetchUpdatedGroups(Emitter<GroupsState> emit) async {
    try {
      final response = await apiService.fetchGroups();
      groups = (response as List).map((g) => Group.fromJson(g as Map<String, dynamic>)).toList();
      emit(GroupsLoaded(List.from(groups))); // ✅ تحديث القائمة بالبيانات الجديدة
    } catch (e) {
      emit(GroupsError("❌ فشل تحديث البيانات بعد الإضافة: $e"));
    }
  }
}
