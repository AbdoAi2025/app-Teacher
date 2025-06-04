/// data : [{"sessionId":"1309e4d3-2343-4127-ab64-cde46841e022","createdAt":"2025-06-02T22:55:05.921+00:00","sessionStatus":0,"groupId":"164d24b6-35d0-42ad-a149-52515087ae94","groupName":"group1 grade4 thru from 9-11","timeFrom":"09:00","timeTo":"11:00","gradeNameEn":"Grade4","gradeNameAr":"الصف الرابع"}]

class GetMySessionsResponse {
  GetMySessionsResponse({
      this.data,});

  GetMySessionsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MySessionItemApiModel.fromJson(v));
      });
    }
  }
  List<MySessionItemApiModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// sessionId : "1309e4d3-2343-4127-ab64-cde46841e022"
/// createdAt : "2025-06-02T22:55:05.921+00:00"
/// sessionStatus : 0
/// groupId : "164d24b6-35d0-42ad-a149-52515087ae94"
/// groupName : "group1 grade4 thru from 9-11"
/// timeFrom : "09:00"
/// timeTo : "11:00"
/// gradeNameEn : "Grade4"
/// gradeNameAr : "الصف الرابع"

class MySessionItemApiModel {
  MySessionItemApiModel({
      this.sessionId, 
      this.sessionName,
      this.createdAt,
      this.sessionStatus, 
      this.groupId, 
      this.groupName, 
      this.timeFrom, 
      this.timeTo, 
      this.gradeNameEn, 
      this.gradeNameAr
    ,});

  MySessionItemApiModel.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    sessionName = json['sessionName'];
    createdAt = json['createdAt'];
    sessionStatus = json['sessionStatus'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];
    gradeNameEn = json['gradeNameEn'];
    gradeNameAr = json['gradeNameAr'];
  }
  String? sessionId;
  String? sessionName;
  String? createdAt;
  int? sessionStatus;
  String? groupId;
  String? groupName;
  String? timeFrom;
  String? timeTo;
  String? gradeNameEn;
  String? gradeNameAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['sessionName'] = sessionName;
    map['createdAt'] = createdAt;
    map['sessionStatus'] = sessionStatus;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['timeFrom'] = timeFrom;
    map['timeTo'] = timeTo;
    map['gradeNameEn'] = gradeNameEn;
    map['gradeNameAr'] = gradeNameAr;
    return map;
  }

}