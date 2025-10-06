/// data : {"active":true, "subscriptionExpireDate": "2025-10-18T13:00:00.000+00:00"}
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
  bool? subscribed;
  String? subscriptionExpireDate;

  Data({this.active, this.subscriptionExpireDate});

  Data.fromJson(dynamic json) {
    active = json['active'];
    subscribed = json['subscribed'];
    subscriptionExpireDate = json['subscriptionExpireDate'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active'] = active;
    map['isSubscribed'] = subscribed;
    map['subscriptionExpireDate'] = subscriptionExpireDate;
    return map;
  }

}