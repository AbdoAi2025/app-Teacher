/// groupId : ""

class SessionListArgsModel {
  SessionListArgsModel({
      this.groupId,});

  SessionListArgsModel.fromJson(dynamic json) {
    groupId = json['groupId'];
  }
  String? groupId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    return map;
  }

}