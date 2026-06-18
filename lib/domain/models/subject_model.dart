import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class SubjectModel {
  final int id;
  final String nameEn;
  final String nameAr;

  SubjectModel({required this.id, required this.nameEn, required this.nameAr});

  String get name => AppSetting.isArabic ? nameAr : nameEn;

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json.tryInt('id') ?? 0,
      nameEn: json.tryString('nameEn') ?? '',
      nameAr: json.tryString('nameAr') ?? '',
    );
  }
}