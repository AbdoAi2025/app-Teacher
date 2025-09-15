/// ids : [""]

class DeleteStudentActivityRequest {
  DeleteStudentActivityRequest({
      this.ids,});

  DeleteStudentActivityRequest.fromJson(dynamic json) {
    ids = json['ids'] != null ? json['ids'].cast<String>() : [];
  }
  List<String>? ids;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ids'] = ids;
    return map;
  }

}