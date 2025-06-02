/// data : [{"id":"4250055f-fe01-4d4a-9c38-8e5a65594f60","startDate":"2025-06-01T22:31:07.017+00:00"},{"id":"4acf4dee-115e-4538-855f-f174f8abd185","startDate":"2025-06-02T12:06:00.633+00:00"}]

class GetRunningSessionsResponse {
  GetRunningSessionsResponse({
      this.data,});

  GetRunningSessionsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RunningSessionsItemApiModel.fromJson(v));
      });
    }
  }
  List<RunningSessionsItemApiModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "4250055f-fe01-4d4a-9c38-8e5a65594f60"
/// startDate : "2025-06-01T22:31:07.017+00:00"

class RunningSessionsItemApiModel {
  RunningSessionsItemApiModel({
      this.id, 
      this.startDate,});

  RunningSessionsItemApiModel.fromJson(dynamic json) {
    id = json['id'];
    startDate = json['startDate'];
  }
  String? id;
  String? startDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['startDate'] = startDate;
    return map;
  }

}