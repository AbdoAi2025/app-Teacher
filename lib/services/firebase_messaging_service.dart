import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/domain/usecases/update_fcm_token_use_case.dart';

// Top-level function for background message handling
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  appLog("Firebase Messaging: Background message received - ${message.messageId}");
  appLog("Firebase Messaging: Background message data - ${message.data}");
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  static FirebaseMessagingService get instance => _instance;

  FirebaseMessaging? _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  String? _fcmToken;
  final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenStreamController = StreamController<String>.broadcast();

  FirebaseMessagingService._internal() {
    _localNotifications = FlutterLocalNotificationsPlugin();
  }

  FirebaseMessaging get _messagingInstance {
    _messaging ??= FirebaseMessaging.instance;
    return _messaging!;
  }

  // Getters
  String? get fcmToken => _fcmToken;
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;
  Stream<String> get tokenStream => _tokenStreamController.stream;

  // Initialization
  Future<void> initialize() async {
    try {
      // Set the background messaging handler early on
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request permission for notifications
      await requestNotificationPermissions();

      // Get the token
      await _getToken();

      // Set up message handlers
      _setupMessageHandlers();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup notification channel for Android
      if (!kIsWeb && Platform.isAndroid) {
        await _setupNotificationChannel();
      }

      appLog("Firebase Messaging: Service initialized successfully");
    } catch (e) {
      appLog("Firebase Messaging Error during initialization: $e");
    }
  }

  // Permission Management
  Future<NotificationSettings> requestNotificationPermissions() async {
    try {
      final settings = await _messagingInstance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      appLog("Firebase Messaging: Permission status - ${settings.authorizationStatus}");
      return settings;
    } catch (e) {
      appLog("Firebase Messaging Error requesting permissions: $e");
      rethrow;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final settings = await _messagingInstance.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      appLog("Firebase Messaging Error checking notification permissions: $e");
      return false;
    }
  }

  // Token Management
  Future<String?> _getToken() async {
    try {
      _fcmToken = await _messagingInstance.getToken();
      appLog("Firebase Messaging: FCM Token received - ${_fcmToken?.substring(0, 20)}...");

      if (_fcmToken != null) {
        _tokenStreamController.add(_fcmToken!);
      }

      return _fcmToken;
    } catch (e) {
      appLog("Firebase Messaging Error getting token: $e");
      return null;
    }
  }

  Future<String?> refreshToken() async {
    return await _getToken();
  }

  // Message Handlers Setup
  void _setupMessageHandlers() {
    // Handle token refresh
    _messagingInstance.onTokenRefresh.listen((token) {
      _fcmToken = token;
      _tokenStreamController.add(token);
      appLog("Firebase Messaging: Token refreshed - ${token.substring(0, 20)}...");
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      appLog("Firebase Messaging: Foreground message received - ${message.messageId}");
      _handleForegroundMessage(message);
      _messageStreamController.add(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      appLog("Firebase Messaging: Notification opened app - ${message.messageId}");
      _handleNotificationTap(message);
      _messageStreamController.add(message);
    });

    appLog("Firebase Messaging: Message handlers setup complete");
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    try {
      final notification = message.notification;
      if (notification != null) {
        // Try to show local notification in foreground
        _showLocalNotification(
          title: notification.title ?? 'New Notification',
          body: notification.body ?? '',
          payload: message.messageId,
        );

        // Add haptic feedback
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      appLog("Firebase Messaging Error handling foreground message: $e");
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    try {
      final data = message.data;
      appLog("Firebase Messaging: Handling notification tap - Data: $data");

      // Navigate based on notification data
      if (data.containsKey('screen')) {
        final screen = data['screen'];
        switch (screen) {
          case 'student_details':
            if (data.containsKey('student_id')) {
              // Navigate to student details screen
              Get.toNamed('/student_details', arguments: {'id': data['student_id']});
            }
            break;
          case 'group_details':
            if (data.containsKey('group_id')) {
              // Navigate to group details screen
              Get.toNamed('/group_details', arguments: {'id': data['group_id']});
            }
            break;
          case 'session_report':
            if (data.containsKey('session_id')) {
              // Navigate to session report screen
              Get.toNamed('/session_report', arguments: {'id': data['session_id']});
            }
            break;
          case 'payment_status':
            if (data.containsKey('transaction_id')) {
              // Navigate to payment status screen
              Get.toNamed('/payment_status', arguments: {'id': data['transaction_id']});
            }
            break;
          default:
            // Navigate to home or default screen
            Get.toNamed('/home');
        }
      }
    } catch (e) {
      appLog("Firebase Messaging Error handling notification tap: $e");
    }
  }


  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          _handleLocalNotificationTap(response.payload);
        },
      );

      appLog("Firebase Messaging: Local notifications initialized");
    } catch (e) {
      appLog("Firebase Messaging Error initializing local notifications: $e");
    }
  }

  // Setup notification channel for Android
  Future<void> _setupNotificationChannel() async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        const androidChannel = AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: 'This channel is used for important notifications.',
          importance: Importance.high,
        );

        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(androidChannel);

        appLog("Firebase Messaging: Android notification channel setup completed");
      } catch (e) {
        appLog("Firebase Messaging Error setting up notification channel: $e");
      }
    }
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      appLog("Firebase Messaging: Local notification shown - $title");
    } catch (e) {
      appLog("Firebase Messaging Error showing local notification: $e");

      // If local notifications fail, show an alternative notification (like a snackbar or dialog)
      if (e.toString().contains('MissingPluginException')) {
        appLog("Firebase Messaging: MissingPluginException detected - app needs full restart after adding flutter_local_notifications");
        // You could show a fallback UI notification here
        _showFallbackNotification(title, body);
      }
    }
  }

  // Handle local notification tap
  void _handleLocalNotificationTap(String? payload) {
    try {
      if (payload != null) {
        appLog("Firebase Messaging: Local notification tapped - payload: $payload");
        // Find the message by messageId if needed
        // For now, just navigate to home
        Get.toNamed('/home');
      }
    } catch (e) {
      appLog("Firebase Messaging Error handling local notification tap: $e");
    }
  }

  // Fallback notification method when local notifications fail
  void _showFallbackNotification(String title, String body) {
    try {
      // Show a GetX snackbar as fallback
      if (Get.context != null) {
        Get.snackbar(
          title,
          body,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          isDismissible: true,
        );
        appLog("Firebase Messaging: Fallback notification shown via snackbar - $title");
      }
    } catch (e) {
      appLog("Firebase Messaging Error showing fallback notification: $e");
    }
  }

  // Topic Subscription
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messagingInstance.subscribeToTopic(topic);
      appLog("Firebase Messaging: Subscribed to topic - $topic");
    } catch (e) {
      appLog("Firebase Messaging Error subscribing to topic: $e");
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messagingInstance.unsubscribeFromTopic(topic);
      appLog("Firebase Messaging: Unsubscribed from topic - $topic");
    } catch (e) {
      appLog("Firebase Messaging Error unsubscribing from topic: $e");
    }
  }

  // App-specific topic management
  Future<void> subscribeToUserTopics({
    required String userId,
    String? role,
    List<String>? groupIds,
  }) async {
    try {
      // Subscribe to user-specific topic
      await subscribeToTopic('user_$userId');

      // Subscribe to role-specific topic
      if (role != null) {
        await subscribeToTopic('role_$role');
      }

      // Subscribe to group-specific topics
      if (groupIds != null) {
        for (final groupId in groupIds) {
          await subscribeToTopic('group_$groupId');
        }
      }

      // Subscribe to general announcements
      await subscribeToTopic('announcements');

      appLog("Firebase Messaging: User topics subscription completed");
    } catch (e) {
      appLog("Firebase Messaging Error subscribing to user topics: $e");
    }
  }

  Future<void> unsubscribeFromUserTopics({
    required String userId,
    String? role,
    List<String>? groupIds,
  }) async {
    try {
      // Unsubscribe from user-specific topic
      await unsubscribeFromTopic('user_$userId');

      // Unsubscribe from role-specific topic
      if (role != null) {
        await unsubscribeFromTopic('role_$role');
      }

      // Unsubscribe from group-specific topics
      if (groupIds != null) {
        for (final groupId in groupIds) {
          await unsubscribeFromTopic('group_$groupId');
        }
      }

      appLog("Firebase Messaging: User topics unsubscription completed");
    } catch (e) {
      appLog("Firebase Messaging Error unsubscribing from user topics: $e");
    }
  }

  // Get initial message (when app is opened from notification)
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      final message = await _messagingInstance.getInitialMessage();
      if (message != null) {
        appLog("Firebase Messaging: Initial message received - ${message.messageId}");
        _handleNotificationTap(message);
      }
      return message;
    } catch (e) {
      appLog("Firebase Messaging Error getting initial message: $e");
      return null;
    }
  }

  // Cleanup
  void dispose() {
    _messageStreamController.close();
    _tokenStreamController.close();
  }

  // Send token to server (to be called after getting user authentication)
  Future<void> sendTokenToServer(String token) async {
    try {
      appLog("Firebase Messaging: Sending token to server - ${token.substring(0, 20)}...");

      // Use the UpdateFcmTokenUseCase to register the token
      final updateFcmTokenUseCase = UpdateFcmTokenUseCase();
      final result = await updateFcmTokenUseCase.execute(token);

      if (result.isSuccess) {
        appLog("Firebase Messaging: Token successfully registered with server");
        appLog("Firebase Messaging: Server response - Token ID: ${result.data?.id}");
      } else {
        appLog("Firebase Messaging: Failed to register token with server: ${result.error}");
      }
    } catch (e) {
      appLog("Firebase Messaging Error sending token to server: $e");
    }
  }

  // Delete token (on logout)
  Future<void> deleteToken() async {
    try {
      await _messagingInstance.deleteToken();
      _fcmToken = null;
      appLog("Firebase Messaging: Token deleted");
    } catch (e) {
      appLog("Firebase Messaging Error deleting token: $e");
    }
  }
}