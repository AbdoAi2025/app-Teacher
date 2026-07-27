import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

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

  String get createdDateFormat => createdAt != null
      ? DateFormat('dd MMM yyyy', Get.locale?.languageCode).format(createdAt!)
      : '';

  String get localizedStatus => status?.tr ?? '';

  EnrollRequestData copyWith({String? status}) {
    return EnrollRequestData(
      id: id,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      toUserId: toUserId,
      toUserName: toUserName,
      studentId: studentId,
      studentName: studentName,
      gradeId: gradeId,
      gradeNameAr: gradeNameAr,
      gradeNameEn: gradeNameEn,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

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