
import '../../models/group_item_model.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {} // ✅ أضف هذه السطر

class GroupsLoaded extends GroupsState {
  final List<GroupItemModel> groups;
  GroupsLoaded(this.groups);
}

class GroupsError extends GroupsState {
  final String message;
  GroupsError(this.message);
}
