import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class FirebaseCrashlyticsService {
  static final FirebaseCrashlyticsService _instance = FirebaseCrashlyticsService._internal();
  static FirebaseCrashlyticsService get instance => _instance;

  late final FirebaseCrashlytics _crashlytics;

  FirebaseCrashlyticsService._internal() {
    _crashlytics = FirebaseCrashlytics.instance;
    _initializeCrashlytics();
  }

  // Initialize crashlytics with debug mode handling
  void _initializeCrashlytics() {
    if (kDebugMode) {
      // Disable crashlytics collection in debug mode
      _crashlytics.setCrashlyticsCollectionEnabled(false);
      appLog("Firebase Crashlytics: Disabled in debug mode");
    } else {
      // Enable crashlytics collection in release mode
      _crashlytics.setCrashlyticsCollectionEnabled(true);
      appLog("Firebase Crashlytics: Enabled in release mode");
    }
  }

  // User Information
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      appLog("Firebase Crashlytics: User ID set to $userId");
    } catch (e) {
      appLog("Firebase Crashlytics Error setting user ID: $e");
    }
  }

  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
      appLog("Firebase Crashlytics: Custom key set - $key: $value");
    } catch (e) {
      appLog("Firebase Crashlytics Error setting custom key: $e");
    }
  }

  Future<void> setUserInfo({
    String? userId,
    String? email,
    String? name,
    String? role,
  }) async {
    try {
      if (userId != null) await setUserId(userId);
      if (email != null) await setCustomKey('user_email', email);
      if (name != null) await setCustomKey('user_name', name);
      if (role != null) await setCustomKey('user_role', role);

      appLog("Firebase Crashlytics: User info updated");
    } catch (e) {
      appLog("Firebase Crashlytics Error setting user info: $e");
    }
  }

  // Error Logging
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
    Iterable<Object> information = const [],
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
        information: information,
      );
      appLog("Firebase Crashlytics: Error recorded - ${exception.toString()}");
    } catch (e) {
      appLog("Firebase Crashlytics Error recording error: $e");
    }
  }

  // Exception Handling
  Future<void> recordFlutterError(FlutterErrorDetails errorDetails) async {
    try {
      await _crashlytics.recordFlutterError(errorDetails);
      appLog("Firebase Crashlytics: Flutter error recorded");
    } catch (e) {
      appLog("Firebase Crashlytics Error recording Flutter error: $e");
    }
  }

  Future<void> recordFlutterFatalError(FlutterErrorDetails errorDetails) async {
    try {
      await _crashlytics.recordFlutterFatalError(errorDetails);
      appLog("Firebase Crashlytics: Flutter fatal error recorded");
    } catch (e) {
      appLog("Firebase Crashlytics Error recording Flutter fatal error: $e");
    }
  }

  // App-specific Error Logging
  Future<void> logAuthenticationError({
    required String errorType,
    String? errorMessage,
    String? userId,
  }) async {
    try {
      await setCustomKey('error_type', 'authentication');
      await setCustomKey('auth_error_type', errorType);
      if (userId != null) await setCustomKey('failed_user_id', userId);

      await recordError(
        Exception('Authentication Error: $errorType'),
        StackTrace.current,
        reason: errorMessage ?? 'Authentication failed',
        information: ['Authentication', errorType],
      );

      appLog("Firebase Crashlytics: Authentication error logged - $errorType");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging authentication error: $e");
    }
  }

  Future<void> logApiError({
    required String endpoint,
    required int statusCode,
    String? errorMessage,
    String? requestData,
  }) async {
    try {
      await setCustomKey('error_type', 'api');
      await setCustomKey('api_endpoint', endpoint);
      await setCustomKey('api_status_code', statusCode);
      if (requestData != null) await setCustomKey('api_request_data', requestData);

      await recordError(
        Exception('API Error: $statusCode at $endpoint'),
        StackTrace.current,
        reason: errorMessage ?? 'API request failed',
        information: ['API', endpoint, statusCode.toString()],
      );

      appLog("Firebase Crashlytics: API error logged - $endpoint ($statusCode)");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging API error: $e");
    }
  }

  Future<void> logPaymentError({
    required String paymentMethod,
    required String errorType,
    String? errorMessage,
    String? transactionId,
  }) async {
    try {
      await setCustomKey('error_type', 'payment');
      await setCustomKey('payment_method', paymentMethod);
      await setCustomKey('payment_error_type', errorType);
      if (transactionId != null) await setCustomKey('transaction_id', transactionId);

      await recordError(
        Exception('Payment Error: $errorType with $paymentMethod'),
        StackTrace.current,
        reason: errorMessage ?? 'Payment processing failed',
        information: ['Payment', paymentMethod, errorType],
      );

      appLog("Firebase Crashlytics: Payment error logged - $paymentMethod ($errorType)");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging payment error: $e");
    }
  }

  Future<void> logDatabaseError({
    required String operation,
    required String table,
    String? errorMessage,
    String? query,
  }) async {
    try {
      await setCustomKey('error_type', 'database');
      await setCustomKey('db_operation', operation);
      await setCustomKey('db_table', table);
      if (query != null) await setCustomKey('db_query', query);

      await recordError(
        Exception('Database Error: $operation on $table'),
        StackTrace.current,
        reason: errorMessage ?? 'Database operation failed',
        information: ['Database', operation, table],
      );

      appLog("Firebase Crashlytics: Database error logged - $operation on $table");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging database error: $e");
    }
  }

  // App State Logging
  Future<void> logAppState({
    String? screenName,
    String? userRole,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (screenName != null) await setCustomKey('current_screen', screenName);
      if (userRole != null) await setCustomKey('user_role', userRole);

      if (additionalData != null) {
        for (final entry in additionalData.entries) {
          await setCustomKey('app_state_${entry.key}', entry.value);
        }
      }

      appLog("Firebase Crashlytics: App state logged");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging app state: $e");
    }
  }

  // Breadcrumbs/Logs
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      appLog("Firebase Crashlytics: Log added - $message");
    } catch (e) {
      appLog("Firebase Crashlytics Error adding log: $e");
    }
  }

  Future<void> logUserAction({
    required String action,
    String? screenName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final logMessage = 'User Action: $action${screenName != null ? ' on $screenName' : ''} at $timestamp';

      if (parameters != null) {
        final paramString = parameters.entries
            .map((e) => '${e.key}=${e.value}')
            .join(', ');
        await log('$logMessage | Parameters: $paramString');
      } else {
        await log(logMessage);
      }

      appLog("Firebase Crashlytics: User action logged - $action");
    } catch (e) {
      appLog("Firebase Crashlytics Error logging user action: $e");
    }
  }

  // Performance Context
  Future<void> setPerformanceContext({
    String? deviceModel,
    String? osVersion,
    String? appVersion,
    int? memoryUsage,
  }) async {
    try {
      if (deviceModel != null) await setCustomKey('device_model', deviceModel);
      if (osVersion != null) await setCustomKey('os_version', osVersion);
      if (appVersion != null) await setCustomKey('app_version', appVersion);
      if (memoryUsage != null) await setCustomKey('memory_usage_mb', memoryUsage);

      appLog("Firebase Crashlytics: Performance context set");
    } catch (e) {
      appLog("Firebase Crashlytics Error setting performance context: $e");
    }
  }

  // Testing and Development
  Future<void> testCrash() async {
    if (kDebugMode) {
      try {
        // Only for testing in debug mode
        _crashlytics.crash();
      } catch (e) {
        appLog("Firebase Crashlytics Test crash error: $e");
      }
    } else {
      appLog("Firebase Crashlytics: Test crash only available in debug mode");
    }
  }

  // Crash Collection Control
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      appLog("Firebase Crashlytics: Collection ${enabled ? 'enabled' : 'disabled'}");
    } catch (e) {
      appLog("Firebase Crashlytics Error setting collection enabled: $e");
    }
  }

  Future<bool> isCrashlyticsCollectionEnabled() async {
    try {
      // Return false in debug mode, true in release mode
      final enabled = !kDebugMode;
      appLog("Firebase Crashlytics: Collection enabled: $enabled (debug mode: $kDebugMode)");
      return enabled;
    } catch (e) {
      appLog("Firebase Crashlytics Error checking if collection enabled: $e");
      return false;
    }
  }
}