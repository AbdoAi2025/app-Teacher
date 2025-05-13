/// id : "string"

class AddGroupResponse {
  AddGroupResponse({
      this.id,});

  AddGroupResponse.fromJson(dynamic json) {
    id = json['id'];
  }
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

}