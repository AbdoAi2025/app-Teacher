import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


const String prodBaseUrl = "https://assistant-app-2136afb92d95.herokuapp.com";
const String devBaseUrl = "https://assistant-app-backend-dev-dc445a76bc87.herokuapp.com/";
const String defaultLocalBaseUrl = "http://192.168.8.185:8080";

class AppMode {

  AppMode._();

  static const int dev = 0;
  static const int prod = 1;
  static const int local = 2;

  static const int defaultMode = kDebugMode ? local : prod;

  static final RxInt _currentMode = (defaultMode).obs;

  static int get mode => _currentMode.value;
  static set mode(int newMode) => _currentMode.value = newMode;

  static bool get isDev => mode == AppMode.dev;
  static bool get isProd => mode == AppMode.prod;
  static bool get isLocal => mode == AppMode.local;
  static bool get isDebug => kDebugMode;

  static RxInt get currentModeObservable => _currentMode;
}

class EnvironmentService {

  static const String _environmentKey = 'app_environment';
  static const String _customLocalUrlKey = 'custom_local_base_url';
  static final RxString _cachedCustomLocalUrl = defaultLocalBaseUrl.obs;

  static get baseUrl => switch (AppMode.mode) {
    AppMode.dev => devBaseUrl,
    AppMode.local => _cachedCustomLocalUrl.value,
    _ => prodBaseUrl
  };

  static Future<int> getEnvironment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_environmentKey) ?? (kDebugMode ? AppMode.local : AppMode.prod);
    } catch (e) {
      return AppMode.defaultMode;
    }
  }

  static Future<bool> setEnvironment(int environment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_environmentKey, environment);
    } catch (e) {
      return false;
    }
  }

  static String getEnvironmentName(int environment) {
    switch (environment) {
      case AppMode.dev:
        return 'Development';
      case AppMode.prod:
        return 'Production';
      case AppMode.local:
        return 'Local';
      default:
        return 'Unknown';
    }
  }

  static List<int> getAllEnvironments() {
    return [AppMode.dev, AppMode.prod, AppMode.local];
  }

  static Future<String> getCustomLocalUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_customLocalUrlKey) ?? defaultLocalBaseUrl;
    } catch (e) {
      return defaultLocalBaseUrl;
    }
  }

  static Future<bool> setCustomLocalUrl(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_customLocalUrlKey, url);
      if (success) {
        _cachedCustomLocalUrl.value = url;
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  static Future<void> loadCustomLocalUrl() async {
    try {
      final url = await getCustomLocalUrl();
      _cachedCustomLocalUrl.value = url;
    } catch (e) {
      _cachedCustomLocalUrl.value = defaultLocalBaseUrl;
    }
  }

  static String get currentCustomLocalUrl => _cachedCustomLocalUrl.value;
}