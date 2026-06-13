import 'package:get/get.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

enum GenderEnum {
  MALE("MALE"),
  FEMALE("FEMALE");

  const GenderEnum(this.value);

  final String value;

  String toJson() => name;

  static GenderEnum fromJson(String json) {
    return GenderEnum.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GenderEnum.MALE,
    );
  }

  String get displayName {
    switch (this) {
      case GenderEnum.MALE:
        return AppStringsKeys.male.tr;
      case GenderEnum.FEMALE:
        return AppStringsKeys.female.tr;
    }
  }
}