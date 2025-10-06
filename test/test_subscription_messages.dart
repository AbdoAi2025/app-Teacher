import 'package:intl/intl.dart';
import 'package:teacher_app/models/check_user_session_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/localization/app_translation.dart';

void main() async {
  // Initialize GetX and localization
  WidgetsFlutterBinding.ensureInitialized();

  // Test cases: 0, 3, and 5 days remaining
  final testCases = [0, 3, 5];

  print('=== Testing Subscription Expiration Messages ===\n');

  for (final days in testCases) {
 print('Testing $days days remaining:');

    // Create a mock subscription date
    final mockExpireDate = DateTime.now().add(Duration(days: days));
    final expireDateStr = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(mockExpireDate);

    // Create a mock user session model
    final sessionModel = CheckUserSessionModel(
      isActive: true,
      isSubscribed: true,
      subscriptionExpireDate: expireDateStr,
    );

    // Test English
    Get.updateLocale(const Locale('en', 'US'));
    final englishRemainingDays = sessionModel.getRemainingDays();
    print('  English:');
    if (englishRemainingDays == 0) {
      print('    Message: "${'subscription_expiring_today_message'.tr}"');
    } else {
      print('    Message: "${'subscription_expiring_message'.trParams({'days': englishRemainingDays.toString()})}"');
    }
    print('    Renew button: "${'Renew'.tr}"');
    print('    Close button: "${'Close'.tr}"');

    // Test Arabic
    Get.updateLocale(const Locale('ar', 'EG'));
    final arabicRemainingDays = sessionModel.getRemainingDays();
    print('  Arabic:');
    if (arabicRemainingDays == 0) {
      print('    Message: "${'subscription_expiring_today_message'.tr}"');
    } else {
      print('    Message: "${'subscription_expiring_message'.trParams({'days': arabicRemainingDays.toString()})}"');
 }
    print('    Renew button: "${'Renew'.tr}"');
    print('    Close button: "${'Close'.tr}"');

    print('');
  }

  print('=== Test Complete ===');
}
