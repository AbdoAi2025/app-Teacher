/// name : "string"
/// groupId : "string"

class StartSessionRequest {
  StartSessionRequest({
      this.name, 
      this.groupId,});

  StartSessionRequest.fromJson(dynamic json) {
    name = json['name'];
    groupId = json['groupId'];
  }
  String? name;
  String? groupId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['groupId'] = groupId;
    return map;
  }

}