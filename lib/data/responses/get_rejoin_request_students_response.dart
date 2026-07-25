import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetRejoinRequestStudentsResponse {
  final RejoinRequestStudentsPageData? data;

  GetRejoinRequestStudentsResponse({this.data});

  factory GetRejoinRequestStudentsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return GetRejoinRequestStudentsResponse(
      data: dataJson is Map<String, dynamic>
          ? RejoinRequestStudentsPageData.fromJson(dataJson)
          : null,
    );
  }
}

class RejoinRequestStudentsPageData {
  final int? totalPages;
  final int? totalItems;
  final List<RejoinRequestStudentData>? items;

  RejoinRequestStudentsPageData({this.totalPages, this.totalItems, this.items});

  factory RejoinRequestStudentsPageData.fromJson(Map<String, dynamic> json) {
    return RejoinRequestStudentsPageData(
      totalPages: json.tryInt('totalPages'),
      totalItems: json.tryInt('totalItems'),
      items: json.tryList('items')
          ?.whereType<Map<String, dynamic>>()
          .map(RejoinRequestStudentData.fromJson)
          .toList(),
    );
  }
}

class RejoinRequestStudentData {
  final int? id;
  final int? joinRequestId;
  final String? studentId;
  final String? studentName;
  final String? parentId;
  final int? gradeId;
  final String? gradeNameAr;
  final String? gradeNameEn;
  final String? status;
  final DateTime? createdAt;

  RejoinRequestStudentData({
    this.id,
    this.joinRequestId,
    this.studentId,
    this.studentName,
    this.parentId,
    this.gradeId,
    this.gradeNameAr,
    this.gradeNameEn,
    this.status,
    this.createdAt,
  });

  String get createdDateFormat => createdAt != null
      ? DateFormat('dd MMM yyyy', Get.locale?.languageCode).format(createdAt!)
      : '';

  String get localizedStatus => status?.tr ?? '';

  factory RejoinRequestStudentData.fromJson(Map<String, dynamic> json) {
    return RejoinRequestStudentData(
      id: json.tryInt('id'),
      joinRequestId: json.tryInt('joinRequestId'),
      studentId: json.tryString('studentId'),
      studentName: json.tryString('studentName'),
      parentId: json.tryString('parentId'),
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