import '../utils/LogUtils.dart';

extension SafeJsonAccess on Map<String, dynamic> {

  T? getValueOrNull<T>(String key) {
    try {
      final value = this[key];
      return value;
    } catch (e) {
      appLog('SafeJsonAccess getValueOrNull Error reading key "$key": $e');
      return null;
    }
  }

  List<T>? tryList<T>(String key) {
    try {
      final value =   this[key]?.cast<T>();
      return value;
    } catch (e) {
      appLog('SafeJsonAccess getValueOrNull Error reading key "$key": $e');
      return null;
    }
  }

  String? tryString(String key) {
    try {
      String? value = getValueOrNull(key);
      return value;
    } catch (e) {
      appLog('SafeJsonAccess tryString Error reading key "$key": $e');
      return null;
    }
  }

  double? tryDouble(String key) {
    try {
      String value = this[key].toString();
      return double.tryParse(value ?? "");
    } catch (e) {
      appLog('SafeJsonAccess tryDouble Error reading key "$key": $e');
      return null;
    }
  }

  int? tryInt(String key) {
    try {
      final value = this[key].toString();
      return int.tryParse(value );
    } catch (e) {
      appLog('SafeJsonAccess tryInt Error reading key "$key": $e');
      return null;
    }
  }

  bool? tryBool(String key) {
    try {
      final value = this[key].toString();
      return bool.tryParse(value);
    } catch (e) {
      appLog('SafeJsonAccess tryBool Error reading key "$key": $e');
      return null;
    }
  }

  T? getValueOrNullMultiKey<T>(List<String> keys){
    for (var element in keys) {
      dynamic value = getValueOrNull(element);
      if(value != null)
        return value;
    }
    return null;
  }
  double? tryDoubleOrNullMultiKey<T>(List<String> keys){
    for (var element in keys) {
      dynamic value = tryDouble(element);
      if(value != null)
        return value;
    }
    return null;
  }

}
