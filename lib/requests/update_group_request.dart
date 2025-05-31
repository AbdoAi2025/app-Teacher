import 'add_group_request.dart';

/// groupId : "string"
/// name : "string"
/// studentsIds : ["string"]
/// day : 1073741824
/// timeFrom : "string"
/// timeTo : "string"

class UpdateGroupRequest extends AddGroupRequest {

  String? groupId;

  UpdateGroupRequest({
    this.groupId,
    super.name,
    super.studentsIds,
    super.day,
    super.timeFrom,
    super.timeTo,
    super.gradeId,
  });


  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['groupId'] = groupId;
    return map;
  }
}