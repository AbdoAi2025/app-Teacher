/// hasGroups : true

class GetMyStudentsRequest {


  GetMyStudentsRequest({
      this.hasGroups,});

  GetMyStudentsRequest.fromJson(dynamic json) {
    hasGroups = json['hasGroups'];
  }
  bool? hasGroups;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasGroups'] = hasGroups;
    return map;
  }

}