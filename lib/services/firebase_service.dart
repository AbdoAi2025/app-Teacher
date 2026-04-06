import 'package:teacher_app/services/firebase_analytics_service.dart';
import 'package:teacher_app/services/firebase_crashlytics_service.dart';
import 'package:teacher_app/services/firebase_messaging_service.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  static FirebaseService get instance => _instance;

  FirebaseService._internal();

  // Service instances
  FirebaseAnalyticsService get analytics => FirebaseAnalyticsService.instance;
  FirebaseCrashlyticsService get crashlytics => FirebaseCrashlyticsService.instance;
  FirebaseMessagingService get messaging => FirebaseMessagingService.instance;

  // Initialize all Firebase services
  Future<void> initializeServices() async {
    try {
      appLog("Firebase Service: Starting initialization of all services");

      // Initialize messaging service
      await messaging.initialize();

      // Get initial message if app was opened from notification
      await messaging.getInitialMessage();

      appLog("Firebase Service: All services initialized successfully");
    } catch (e) {
      appLog("Firebase Service Error during initialization: $e");
      await crashlytics.recordError(e, StackTrace.current, reason: 'Firebase service initialization failed');
    }
  }

  // User session management
  Future<void> setUser({
    required String userId,
    String? email,
    String? name,
    String? role,
  }) async {
    try {
      // Set user for analytics
      await analytics.setUserId(userId);
      if (role != null) {
        await analytics.setUserProperty('user_role', role);
      }

      // Set user for crashlytics
      await crashlytics.setUserInfo(
        userId: userId,
        email: email,
        name: name,
        role: role,
      );

      // Subscribe to user-specific messaging topics
      await messaging.subscribeToUserTopics(
        userId: userId,
        role: role,
      );

      appLog("Firebase Service: User set successfully - $userId");
    } catch (e) {
      appLog("Firebase Service Error setting user: $e");
      await crashlytics.recordError(e, StackTrace.current, reason: 'Failed to set user data');
    }
  }

  // User logout
  Future<void> clearUser({required String userId, String? role}) async {
    try {
      // Clear analytics user
      await analytics.setUserId('');

      // Clear crashlytics custom keys
      await crashlytics.setUserId('');

      // Unsubscribe from user-specific messaging topics
      await messaging.unsubscribeFromUserTopics(
        userId: userId,
        role: role,
      );

      // Delete FCM token
      await messaging.deleteToken();

      appLog("Firebase Service: User cleared successfully");
    } catch (e) {
      appLog("Firebase Service Error clearing user: $e");
      await crashlytics.recordError(e, StackTrace.current, reason: 'Failed to clear user data');
    }
  }

  // Analytics convenience methods
  Future<void> logScreen(String screenName) async {
    try {
      await analytics.logScreenView(screenName);
      await crashlytics.logUserAction(action: 'screen_view', screenName: screenName);
    } catch (e) {
      appLog("Firebase Service Error logging screen: $e");
    }
  }

  Future<void> logUserAction({
    required String action,
    String? screenName,
    Map<String, Object>? parameters,
  }) async {
    try {
      final eventParams = <String, Object>{
        'action': action,
        if (screenName != null) 'screen': screenName,
        if (parameters != null) ...parameters,
      };

      await analytics.logCustomEvent(
        eventName: 'user_action',
        parameters: eventParams,
      );
      await crashlytics.logUserAction(
        action: action,
        screenName: screenName,
        parameters: parameters?.map((key, value) => MapEntry(key, value)),
      );
    } catch (e) {
      appLog("Firebase Service Error logging user action: $e");
    }
  }

  // Error handling convenience methods
  Future<void> logError({
    required String errorType,
    required dynamic error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Log to analytics
      await analytics.logError(errorType: errorType, errorMessage: error.toString());

      // Log to crashlytics with additional context
      await crashlytics.setCustomKey('error_context', context ?? 'unknown');
      if (additionalData != null) {
        for (final entry in additionalData.entries) {
          await crashlytics.setCustomKey('error_${entry.key}', entry.value);
        }
      }
      await crashlytics.recordError(error, stackTrace ?? StackTrace.current, reason: context);

      appLog("Firebase Service: Error logged - $errorType");
    } catch (e) {
      appLog("Firebase Service Error logging error: $e");
    }
  }

  // App lifecycle events
  Future<void> logAppOpen() async {
    try {
      await analytics.logAppOpen();
      await crashlytics.log('App opened');
    } catch (e) {
      appLog("Firebase Service Error logging app open: $e");
    }
  }

  Future<void> logLogin({String? method}) async {
    try {
      await analytics.logLogin(method: method);
      await crashlytics.log('User logged in with method: ${method ?? 'unknown'}');
    } catch (e) {
      appLog("Firebase Service Error logging login: $e");
    }
  }

  // Feature usage tracking
  Future<void> logFeatureUsage({
    required String featureName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await analytics.logFeatureUsed(featureName: featureName, parameters: parameters);
      await crashlytics.logUserAction(
        action: 'feature_used',
        parameters: {'feature': featureName, if (parameters != null) ...parameters},
      );
    } catch (e) {
      appLog("Firebase Service Error logging feature usage: $e");
    }
  }

  // Student and group management events
  Future<void> logStudentAdded({required String groupId}) async {
    try {
      await analytics.logStudentAdded(groupId: groupId);
      await crashlytics.logUserAction(
        action: 'student_added',
        parameters: {'group_id': groupId},
      );
    } catch (e) {
      appLog("Firebase Service Error logging student added: $e");
    }
  }

  Future<void> logGroupCreated({required String groupType}) async {
    try {
      await analytics.logGroupCreated(groupType: groupType);
      await crashlytics.logUserAction(
        action: 'group_created',
        parameters: {'group_type': groupType},
      );
    } catch (e) {
      appLog("Firebase Service Error logging group created: $e");
    }
  }

  Future<void> logSessionTracked({
    required String sessionType,
    required String duration,
  }) async {
    try {
      await analytics.logSessionTracked(
        sessionType: sessionType,
        duration: duration,
      );
      await crashlytics.logUserAction(
        action: 'session_tracked',
        parameters: {
          'session_type': sessionType,
          'duration': duration,
        },
      );
    } catch (e) {
      appLog("Firebase Service Error logging session tracked: $e");
    }
  }

  // Payment events
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String transactionId,
    String? method,
  }) async {
    try {
      await analytics.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        method: method,
      );
      await crashlytics.logUserAction(
        action: 'purchase',
        parameters: {
          'currency': currency,
          'value': value,
          'transaction_id': transactionId,
          'method': method,
        },
      );
    } catch (e) {
      appLog("Firebase Service Error logging purchase: $e");
    }
  }

  // Language change tracking
  Future<void> logLanguageChanged({required String language}) async {
    try {
      await analytics.logLanguageChanged(language: language);
      await crashlytics.setCustomKey('app_language', language);
      await crashlytics.logUserAction(
        action: 'language_changed',
        parameters: {'language': language},
      );
    } catch (e) {
      appLog("Firebase Service Error logging language change: $e");
    }
  }

  // Messaging convenience methods
  Future<String?> getFCMToken() async {
    try {
      return messaging.fcmToken ?? await messaging.refreshToken();
    } catch (e) {
      appLog("Firebase Service Error getting FCM token: $e");
      return null;
    }
  }

  Future<void> subscribeToGroupNotifications(List<String> groupIds) async {
    try {
      for (final groupId in groupIds) {
        await messaging.subscribeToTopic('group_$groupId');
      }
      await crashlytics.logUserAction(
        action: 'subscribed_to_groups',
        parameters: {'group_count': groupIds.length},
      );
    } catch (e) {
      appLog("Firebase Service Error subscribing to group notifications: $e");
    }
  }

  Future<void> unsubscribeFromGroupNotifications(List<String> groupIds) async {
    try {
      for (final groupId in groupIds) {
        await messaging.unsubscribeFromTopic('group_$groupId');
      }
      await crashlytics.logUserAction(
        action: 'unsubscribed_from_groups',
        parameters: {'group_count': groupIds.length},
      );
    } catch (e) {
      appLog("Firebase Service Error unsubscribing from group notifications: $e");
    }
  }

  // Performance and device context
  Future<void> setDeviceContext({
    String? deviceModel,
    String? osVersion,
    String? appVersion,
  }) async {
    try {
      await crashlytics.setPerformanceContext(
        deviceModel: deviceModel,
        osVersion: osVersion,
        appVersion: appVersion,
      );

      if (deviceModel != null) {
        await analytics.setUserProperty('device_model', deviceModel);
      }
      if (osVersion != null) {
        await analytics.setUserProperty('os_version', osVersion);
      }
      if (appVersion != null) {
        await analytics.setUserProperty('app_version', appVersion);
      }

      appLog("Firebase Service: Device context set");
    } catch (e) {
      appLog("Firebase Service Error setting device context: $e");
    }
  }

  // Testing and debugging
  Future<void> testCrashlytics() async {
    try {
      await crashlytics.testCrash();
    } catch (e) {
      appLog("Firebase Service Error testing crashlytics: $e");
    }
  }

  // Cleanup
  void dispose() {
    messaging.dispose();
  }
}