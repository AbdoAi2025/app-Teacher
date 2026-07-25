import 'package:teacher_app/utils/safe_json_access.dart';

class GetEnrollRequestsResponse {
  final EnrollRequestsPageData? data;

  GetEnrollRequestsResponse({this.data});

  factory GetEnrollRequestsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return GetEnrollRequestsResponse(
      data: dataJson is Map<String, dynamic>
          ? EnrollRequestsPageData.fromJson(dataJson)
          : null,
    );
  }
}

class EnrollRequestsPageData {
  final int? totalPages;
  final int? totalItems;
  final List<EnrollRequestData>? items;

  EnrollRequestsPageData({this.totalPages, this.totalItems, this.items});

  factory EnrollRequestsPageData.fromJson(Map<String, dynamic> json) {
    return EnrollRequestsPageData(
      totalPages: json.tryInt('totalPages'),
      totalItems: json.tryInt('totalItems'),
      items: json.tryList('items')
          ?.whereType<Map<String, dynamic>>()
          .map(EnrollRequestData.fromJson)
          .toList(),
    );
  }
}

class EnrollRequestData {
  final int? id;
  final String? fromUserId;
  final String? fromUserName;
  final String? toUserId;
  final String? toUserName;
  final String? studentId;
  final String? studentName;
  final int? gradeId;
  final String? gradeNameAr;
  final String? gradeNameEn;
  final String? status;
  final DateTime? createdAt;

  EnrollRequestData({
    this.id,
    this.fromUserId,
    this.fromUserName,
    this.toUserId,
    this.toUserName,
    this.studentId,
    this.studentName,
    this.gradeId,
    this.gradeNameAr,
    this.gradeNameEn,
    this.status,
    this.createdAt,
  });

  factory EnrollRequestData.fromJson(Map<String, dynamic> json) {
    return EnrollRequestData(
      id: json.tryInt('id'),
      fromUserId: json.tryString('fromUserId'),
      fromUserName: json.tryString('fromUserName'),
      toUserId: json.tryString('toUserId'),
      toUserName: json.tryString('toUserName'),
      studentId: json.tryString('studentId'),
      studentName: json.tryString('studentName'),
      gradeId: json.tryInt('gradeId'),
      gradeNameAr: json.tryString('gradeNameAr'),
      gradeNameEn: json.tryString('gradeNameEn'),
      status: json.tryString('status'),
      createdAt: json.tryString('createdAt') != null
          ? DateTime.tryParse(json.tryString('createdAt')!)
          : null,
    );
  }
}