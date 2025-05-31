
import 'localization_utils.dart';
import 'localized_name_model.dart';


extension NameLocalizedExtension on LocalizedNameModel {
  String toLocalizedName() {
    return LocalizationUtils.isArabic() ? nameAr ?? ""  : nameEn ?? "";
  }
}