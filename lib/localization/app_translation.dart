import 'translations_map.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en_US": translationsMap.map((key, model) => MapEntry(key, model.en)),
    "ar": translationsMap.map((key, model) => MapEntry(key, model.ar)),
  };
}