import 'package:teacher_app/appSetting/appSetting.dart';

class GradeModel {
  final int? id;
  final String nameEn;
  final String nameAr;

  GradeModel({required this.id, required this.nameEn, required this.nameAr});

  String get name => AppSetting.isArabic ? nameAr :nameEn;

}
