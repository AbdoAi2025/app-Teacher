import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

import '../utils/LogUtils.dart';
import 'environment_service.dart';

/// Paymob native SDK service that bridges Flutter with native Android and iOS SDKs
class PaymobNativeService {

  // Use your actual public key - this is just for testing
  static const String _publicKeyTest = "egy_pk_test_Zxpr8meJ0u7SCkEnyRNSFV2UChgYAdZi";
  static const String _publicKeyProd = "egy_pk_live_wURrok4W0iWmbvjpVeOJ8DHpBhvIWrbU";
  static const MethodChannel _channel = MethodChannel('paymob_sdk_flutter');
  static const MethodChannel _legacyChannel = MethodChannel('paymob_payment');

  /// Pay with Paymob using native SDK
  ///
  /// [publicKey] - Your Paymob public key
  /// [clientSecret] - Client secret for the payment
  /// [appName] - Name of your app (optional)
  /// [buttonBackgroundColor] - Background color for payment button
  /// [buttonTextColor] - Text color for payment button
  /// [saveCardDefault] - Whether to save card by default
  /// [showSaveCard] - Whether to show save card option
  ///
  /// Returns a [PaymobPaymentResult] containing payment status
  ///  buttonBackgroundColor: 0xFF1976D2, // Blue background
  //            buttonTextColor: 0xFFFFFFFF, // White text
  //            saveCardDefault: false,
  //            showSaveCard: true,
  static Future<PaymobPaymentResult> payWithPaymob({
    required String clientSecret,
    int? buttonBackgroundColor = 0xFF1976D2,
    int? buttonTextColor = 0xFFFFFFFF,
    bool saveCardDefault = false,
    bool showSaveCard = true,
    String? language,
  }) async {
    try {
      final Map<String, dynamic> arguments = {
        'publicKey': _getPublicKey(),
        'clientSecret': clientSecret,
        'appName': AppStringsKeys.appName.tr,
        'buttonBackgroundColor': buttonBackgroundColor,
        'buttonTextColor': buttonTextColor,
        'saveCardDefault': saveCardDefault,
        'showSaveCard': showSaveCard,
        'language': language ?? Get.locale?.languageCode ?? 'en',
      };

      final String result = await _channel.invokeMethod('payWithPaymob', arguments);

      appLog("payWithPaymob result:$result");

      return PaymobPaymentResult(
        success: result == 'Successful',
        status: result,
        error: result == 'Successful' ? null : result,
      );
    } on PlatformException catch (e) {
      return PaymobPaymentResult(
        success: false,
        status: 'Error',
        error: e.message ?? 'Platform error occurred',
      );
    } catch (e) {
      return PaymobPaymentResult(
        success: false,
        status: 'Error',
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Legacy method: Pay with card using payment key (for backward compatibility)
  ///
  /// [paymentKey] - Payment key from Paymob API
  /// [saveCard] - Whether to save card for future use
  static Future<PaymobPaymentResult> payWithCard({
    required String paymentKey,
    bool saveCard = false,
  }) async {
    try {
      final Map<String, dynamic> arguments = {
        'paymentKey': paymentKey,
        'save': saveCard,
      };

      final Map<dynamic, dynamic> result = await _legacyChannel.invokeMethod('payWithCard', arguments);

      return PaymobPaymentResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: e.message ?? 'Platform error occurred',
      );
    } catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Legacy method: Pay with wallet using payment key
  ///
  /// [paymentKey] - Payment key from Paymob API
  /// [redirectUrl] - URL for wallet redirect
  static Future<PaymobPaymentResult> payWithWallet({
    required String paymentKey,
    required String redirectUrl,
  }) async {
    try {
      final Map<String, dynamic> arguments = {
        'paymentKey': paymentKey,
        'redirectUrl': redirectUrl,
      };

      final Map<dynamic, dynamic> result = await _legacyChannel.invokeMethod('payWithWallet', arguments);

      return PaymobPaymentResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: e.message ?? 'Platform error occurred',
      );
    } catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Legacy method: Save card using payment key
  ///
  /// [paymentKey] - Payment key from Paymob API
  static Future<PaymobPaymentResult> saveCard({
    required String paymentKey,
  }) async {
    try {
      final Map<String, dynamic> arguments = {
        'paymentKey': paymentKey,
      };

      final Map<dynamic, dynamic> result = await _legacyChannel.invokeMethod('saveCard', arguments);

      return PaymobPaymentResult.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: e.message ?? 'Platform error occurred',
      );
    } catch (e) {
      return PaymobPaymentResult(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Get a publicly accessible public key for testing
  static String get publicKey => _publicKeyTest;

  static _getPublicKey() {
    return AppMode.isProd ? _publicKeyProd : _publicKeyTest;
  }
}

/// Result model for Paymob payment operations
class PaymobPaymentResult {
  final bool success;
  final String? status;
  final String? error;
  final String? transactionId;
  final String? paymobTransactionId;
  final String? cardSubtype;
  final String? maskedPan;
  final String? orderId;
  final String? cardToken;
  final String? cardMaskedPan;

  const PaymobPaymentResult({
    required this.success,
    this.status,
    this.error,
    this.transactionId,
    this.paymobTransactionId,
    this.cardSubtype,
    this.maskedPan,
    this.orderId,
    this.cardToken,
    this.cardMaskedPan,
  });

  factory PaymobPaymentResult.fromMap(Map<String, dynamic> map) {
    return PaymobPaymentResult(
      success: map['success'] ?? false,
      status: map['status'],
      error: map['error'],
      transactionId: map['transaction_id'],
      paymobTransactionId: map['paymob_transaction_id'],
      cardSubtype: map['card_subtype'],
      maskedPan: map['masked_pan'],
      orderId: map['order_id'],
      cardToken: map['card_token'],
      cardMaskedPan: map['card_masked_pan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'status': status,
      'error': error,
      'transaction_id': transactionId,
      'paymob_transaction_id': paymobTransactionId,
      'card_subtype': cardSubtype,
      'masked_pan': maskedPan,
      'order_id': orderId,
      'card_token': cardToken,
      'card_masked_pan': cardMaskedPan,
    };
  }

  @override
  String toString() {
    return 'PaymobPaymentResult{success: $success, status: $status, error: $error, transactionId: $transactionId, paymobTransactionId: $paymobTransactionId, cardSubtype: $cardSubtype, maskedPan: $maskedPan, orderId: $orderId, cardToken: $cardToken, cardMaskedPan: $cardMaskedPan}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymobPaymentResult &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          status == other.status &&
          error == other.error &&
          transactionId == other.transactionId &&
          paymobTransactionId == other.paymobTransactionId &&
          cardSubtype == other.cardSubtype &&
          maskedPan == other.maskedPan &&
          orderId == other.orderId &&
          cardToken == other.cardToken &&
          cardMaskedPan == other.cardMaskedPan;

  @override
  int get hashCode =>
      success.hashCode ^
      status.hashCode ^
      error.hashCode ^
      transactionId.hashCode ^
      paymobTransactionId.hashCode ^
      cardSubtype.hashCode ^
      maskedPan.hashCode ^
      orderId.hashCode ^
      cardToken.hashCode ^
      cardMaskedPan.hashCode;
}

/// Paymob payment exceptions
class PaymobPaymentException implements Exception {
  final String message;
  final String? code;

  const PaymobPaymentException(this.message, {this.code});

  @override
  String toString() => 'PaymobPaymentException: $message${code != null ? ' (Code: $code)' : ''}';
}