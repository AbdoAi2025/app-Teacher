import 'localArabic.dart';
import 'localeEnglish.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en_US": enUS,
    "ar": ar,
  };
}