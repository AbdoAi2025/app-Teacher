/// id : "4250055f-fe01-4d4a-9c38-8e5a65594f60"

class StartSessionResponse {
  StartSessionResponse({
      this.id,});

  StartSessionResponse.fromJson(dynamic json) {
    id = json['id'];
  }
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

}