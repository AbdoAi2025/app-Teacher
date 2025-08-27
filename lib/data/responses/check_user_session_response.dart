/// data : {"active":true}
/// status : "success"

class CheckUserSessionResponse {
  CheckUserSessionResponse({
      this.data, 
      this.status,});

  CheckUserSessionResponse.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }
  Data? data;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    return map;
  }

}

/// active : true

class Data {

  bool? active;
  bool? isSubscribed;

  Data({this.active,});

  Data.fromJson(dynamic json) {
    active = json['active'];
    isSubscribed = json['isSubscribed'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active'] = active;
    map['isSubscribed'] = isSubscribed;
    return map;
  }

}