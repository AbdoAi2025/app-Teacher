import 'package:teacher_app/data/responses/get_group_details_response.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetMyGroupsResponse {
  GetMyGroupsResponse({this.data});

  factory GetMyGroupsResponse.fromJson(Map<String, dynamic> json) {
    return GetMyGroupsResponse(
      data: json.tryList('data')
          ?.whereType<Map<String, dynamic>>()
          .map(GroupData.fromJson)
          .toList(),
    );
  }

  List<GroupData>? data;

  Map<String, dynamic> toJson() => {
        if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
      };
}

class GroupData {
  GroupData({
    this.groupId,
    this.groupName,
    this.studentCount,
    this.sessionsCount,
    this.gradeId,
    this.gradeNameEn,
    this.gradeNameAr,
    this.timings,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      groupId: json.tryString('groupId'),
      groupName: json.tryString('groupName'),
      studentCount: json.tryInt('studentCount'),
      sessionsCount: json.tryInt('sessionsCount'),
      gradeId: json.tryInt('gradeId'),
      gradeNameEn: json.tryString('gradeNameEn'),
      gradeNameAr: json.tryString('gradeNameAr'),
      timings: json.tryList('timings')
          ?.whereType<Map<String, dynamic>>()
          .map(GroupDetailsTiming.fromJson)
          .toList(),
    );
  }

  String? groupId;
  String? groupName;
  int? studentCount;
  int? sessionsCount;
  int? gradeId;
  String? gradeNameEn;
  String? gradeNameAr;
  List<GroupDetailsTiming>? timings;

  GroupDetailsTiming? get firstTiming => timings?.isNotEmpty == true ? timings!.first : null;

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'groupName': groupName,
        'studentCount': studentCount,
        'sessionsCount': sessionsCount,
        'gradeId': gradeId,
        'gradeNameEn': gradeNameEn,
        'gradeNameAr': gradeNameAr,
        'timings': timings?.map((t) => t.toJson()).toList(),
      };
}