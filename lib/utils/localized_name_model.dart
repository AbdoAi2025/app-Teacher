import 'package:teacher_app/utils/localization_utils.dart';

class LocalizedNameModel {
  final String nameEn;
  final String nameAr;
  LocalizedNameModel({required this.nameEn, required this.nameAr});


  get name => LocalizationUtils.isArabic() ? nameAr : nameEn;
}
