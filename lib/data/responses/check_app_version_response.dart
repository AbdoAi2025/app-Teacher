/// status : "string"
/// data : {"forceUpdate":true}

class CheckAppVersionResponse {
  CheckAppVersionResponse({
      this.status, 
      this.data,});

  CheckAppVersionResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? status;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// forceUpdate : true

class Data {
  Data({
      this.forceUpdate,});

  Data.fromJson(dynamic json) {
    forceUpdate = json['forceUpdate'];
  }
  bool? forceUpdate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['forceUpdate'] = forceUpdate;
    return map;
  }

}