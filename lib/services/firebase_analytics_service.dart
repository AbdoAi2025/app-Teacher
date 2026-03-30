import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalyticsService _instance = FirebaseAnalyticsService._internal();
  static FirebaseAnalyticsService get instance => _instance;

  late final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver _observer;

  FirebaseAnalyticsService._internal() {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  FirebaseAnalyticsObserver get observer => _observer;

  // User Events
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      appLog("Firebase Analytics: User ID set to $userId");
    } catch (e) {
      appLog("Firebase Analytics Error setting user ID: $e");
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      appLog("Firebase Analytics: User property set - $name: $value");
    } catch (e) {
      appLog("Firebase Analytics Error setting user property: $e");
    }
  }

  // Screen Tracking
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      appLog("Firebase Analytics: Screen view logged - $screenName");
    } catch (e) {
      appLog("Firebase Analytics Error logging screen view: $e");
    }
  }

  // Authentication Events
  Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      appLog("Firebase Analytics: Login logged - method: $method");
    } catch (e) {
      appLog("Firebase Analytics Error logging login: $e");
    }
  }

  Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method ?? 'unknown');
      appLog("Firebase Analytics: Sign up logged - method: $method");
    } catch (e) {
      appLog("Firebase Analytics Error logging sign up: $e");
    }
  }

  // Session Management
  Future<void> logSessionStart() async {
    try {
      await _analytics.logEvent(
        name: 'session_start',
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Session start logged");
    } catch (e) {
      appLog("Firebase Analytics Error logging session start: $e");
    }
  }

  // Student & Group Management Events
  Future<void> logStudentAdded({required String groupId}) async {
    try {
      await _analytics.logEvent(
        name: 'student_added',
        parameters: {
          'group_id': groupId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Student added logged - groupId: $groupId");
    } catch (e) {
      appLog("Firebase Analytics Error logging student added: $e");
    }
  }

  Future<void> logGroupCreated({required String groupType}) async {
    try {
      await _analytics.logEvent(
        name: 'group_created',
        parameters: {
          'group_type': groupType,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Group created logged - type: $groupType");
    } catch (e) {
      appLog("Firebase Analytics Error logging group created: $e");
    }
  }

  Future<void> logSessionTracked({required String sessionType, required String duration}) async {
    try {
      await _analytics.logEvent(
        name: 'session_tracked',
        parameters: {
          'session_type': sessionType,
          'duration': duration,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Session tracked - type: $sessionType, duration: $duration");
    } catch (e) {
      appLog("Firebase Analytics Error logging session tracked: $e");
    }
  }

  // Payment Events
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String transactionId,
    String? method,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        parameters: {
          'method': method ?? 'unknown',
        },
      );
      appLog("Firebase Analytics: Purchase logged - $value $currency");
    } catch (e) {
      appLog("Firebase Analytics Error logging purchase: $e");
    }
  }

  // Feature Usage Events
  Future<void> logFeatureUsed({required String featureName, Map<String, Object>? parameters}) async {
    try {
      final eventParams = <String, Object>{
        'feature_name': featureName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        if (parameters != null) ...parameters,
      };

      await _analytics.logEvent(
        name: 'feature_used',
        parameters: eventParams,
      );
      appLog("Firebase Analytics: Feature used logged - $featureName");
    } catch (e) {
      appLog("Firebase Analytics Error logging feature used: $e");
    }
  }

  // Error Events
  Future<void> logError({required String errorType, String? errorMessage}) async {
    try {
      await _analytics.logEvent(
        name: 'app_error',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage ?? 'unknown',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Error logged - $errorType");
    } catch (e) {
      appLog("Firebase Analytics Error logging error event: $e");
    }
  }

  // Custom Events
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      appLog("Firebase Analytics: Custom event logged - $eventName");
    } catch (e) {
      appLog("Firebase Analytics Error logging custom event: $e");
    }
  }

  // App Lifecycle Events
  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      appLog("Firebase Analytics: App open logged");
    } catch (e) {
      appLog("Firebase Analytics Error logging app open: $e");
    }
  }

  // Language and Localization Events
  Future<void> logLanguageChanged({required String language}) async {
    try {
      await _analytics.logEvent(
        name: 'language_changed',
        parameters: {
          'language': language,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      appLog("Firebase Analytics: Language changed logged - $language");
    } catch (e) {
      appLog("Firebase Analytics Error logging language change: $e");
    }
  }
}