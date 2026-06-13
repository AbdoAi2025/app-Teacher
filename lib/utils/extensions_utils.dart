
import 'localization_utils.dart';
import 'localized_name_model.dart';


extension NameLocalizedExtension on LocalizedNameModel {
  String toLocalizedName() {
    return LocalizationUtils.isArabic() ? nameAr ?? ""  : nameEn ?? "";
  }
}

extension StringExtension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

extension NullableStringExtension on String? {
  String ifNullOrEmpty(String fallback) => (this == null || this!.isEmpty) ? fallback : this!;
}