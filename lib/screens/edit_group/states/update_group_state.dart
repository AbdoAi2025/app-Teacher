


import '../../create_group/states/create_group_state.dart';

sealed class UpdateGroupState implements CreateGroupState{}
class UpdateGroupStateGroupNotFound extends UpdateGroupState {}
