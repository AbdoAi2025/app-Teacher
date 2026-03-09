# Paymob Native SDK Integration for Flutter (Updated v1.4.6)

This document explains how to integrate Paymob's new native Android SDK v1.4.6 with your Flutter application using platform channels.

## Overview

This integration provides:
- ✅ **Native Android SDK Integration** using Paymob's new SDK v1.4.6
- ✅ **Native iOS SDK Integration** using Paymob's AcceptSDK
- ✅ **Flutter Platform Channel Bridge** for seamless communication
- ✅ **Simplified Payment Flow** with direct public key/client secret authentication
- ✅ **Card Payments** with native UI and customizable styling
- ✅ **Card Saving** functionality for future payments
- ✅ **Payment Status Handling** (Successful, Rejected, Pending)
- ✅ **Type-safe Dart models** for all payment operations

## Prerequisites

1. **Paymob Account**: Create an account at [Paymob](https://accept.paymob.com/)
2. **API Credentials**: Obtain your API key, integration IDs, and iframe ID
3. **Flutter SDK**: Flutter 3.0 or higher
4. **Android**: API level 21 (Android 5.0) or higher
5. **iOS**: iOS 12.0 or higher

## Project Structure

```
lib/
├── services/
│   ├── paymob_client.dart              # Complete Paymob API client
│   └── paymob_native_service.dart      # Platform channel bridge
├── widgets/
│   ├── paymob_payment_widget.dart      # Example usage widget
│   └── paymob_simple_widget.dart       # Simple SDK example widget
android/
├── app/
│   ├── build.gradle                    # Android dependencies
│   └── src/main/java/.../
│       ├── MainActivity.kt             # Main activity (channel setup)
│       └── PaymobHandler.kt            # Paymob payment handler
└── build.gradle                       # Project-level Android config
ios/
├── Podfile                            # iOS dependencies
└── Runner/AppDelegate.swift           # iOS native implementation
```

## Installation & Setup

### 1. Android Setup

#### Dependencies (android/app/build.gradle)
```gradle
dependencies {
    // Existing dependencies...

    // Paymob SDK - New version
    implementation 'com.paymob:paymob-sdk:1.4.6'
}
```

#### Repository (android/build.gradle)
```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        // JitPack repository for Paymob SDK
        maven { url 'https://jitpack.io' }
    }
}
```

#### Android Native Implementation (Kotlin)

**MainActivity.kt** - Main activity setup:
- Platform channel setup (`paymob_sdk_flutter`)
- Method channel handlers for payment and WhatsApp sharing
- Clean separation of concerns

**PaymobHandler.kt** - Dedicated payment handler:
- Paymob SDK initialization and configuration
- Payment processing with customizable UI
- Payment status callbacks: `onSuccess`, `onFailure`, `onPending`
- Color conversion for button styling
- Comprehensive error handling and logging

### 2. iOS Setup

#### Dependencies (ios/Podfile)
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Paymob iOS SDK
  pod 'AcceptSDK', '~> 3.0.0'

  target 'RunnerTests' do
    inherit! :search_paths
  end
end
```

#### AppDelegate Implementation
The `AppDelegate.swift` has been updated with:
- AcceptSDK import and initialization
- Platform channel setup (`paymob_payment`)
- Payment methods implementation
- Native UI presentation and callback handling

### 3. Flutter Integration

#### Core Services

1. **PaymobNativeService** (`lib/services/paymob_native_service.dart`)
   - Platform channel bridge to native SDKs
   - Type-safe method calls
   - Result handling and error management

2. **PaymobClient** (`lib/services/paymob_client.dart`)
   - Complete Paymob API integration
   - Order creation and management
   - Payment key generation
   - High-level payment methods

#### Example Usage Widget
A complete demo widget is provided in `lib/widgets/paymob_payment_widget.dart` showing:
- Card payment with save option
- Wallet payment flow
- Card saving without payment
- Error handling and result display

## Usage Examples

### 1. Simple Payment with New SDK (Recommended)

```dart
import 'package:your_app/services/paymob_native_service.dart';

Future<void> payWithPaymob() async {
  final result = await PaymobNativeService.payWithPaymob(
    publicKey: 'YOUR_PUBLIC_KEY', // Your Paymob public key
    clientSecret: 'YOUR_CLIENT_SECRET', // Client secret from your backend
    appName: 'Teacher App',
    buttonBackgroundColor: 0xFF1976D2, // Blue background
    buttonTextColor: 0xFFFFFFFF, // White text
    saveCardDefault: false,
    showSaveCard: true,
  );

  if (result.success) {
    print('Payment successful: ${result.status}');
  } else {
    print('Payment failed: ${result.error}');
  }
}
```

### 2. Legacy API Integration (Alternative)

```dart
import 'package:your_app/services/paymob_client.dart';

void main() {
  // Initialize Paymob client
  PaymobClient.instance.initialize(
    apiKey: 'YOUR_API_KEY',
    integrationId: 123456, // Card integration ID
    walletIntegrationId: 654321, // Wallet integration ID
    iframeId: 789012, // Iframe ID for web payments
  );

  runApp(MyApp());
}
```

### 3. Legacy Card Payment

```dart
Future<void> payWithCard() async {
  final billingData = PaymobBillingData(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '+201234567890',
    city: 'Cairo',
    country: 'Egypt',
  );

  final result = await PaymobClient.instance.payWithCard(
    amountCents: 10000, // 100 EGP
    billingData: billingData,
    items: [
      const PaymobOrderItem(
        name: 'Test Product',
        description: 'Test product description',
        amountCents: 10000,
        quantity: 1,
      ),
    ],
    saveCard: true, // Enable save card option
  );

  if (result.success) {
    print('Payment successful: ${result.transactionId}');
    if (result.cardToken != null) {
      print('Card saved with token: ${result.cardToken}');
    }
  } else {
    print('Payment failed: ${result.error}');
  }
}
```

### 3. Wallet Payment

```dart
Future<void> payWithWallet() async {
  final billingData = PaymobBillingData(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '+201234567890',
    city: 'Cairo',
    country: 'Egypt',
  );

  final result = await PaymobClient.instance.payWithWallet(
    amountCents: 10000, // 100 EGP
    billingData: billingData,
    redirectUrl: 'https://your-app.com/payment/callback',
    items: [
      const PaymobOrderItem(
        name: 'Test Product',
        description: 'Test product description',
        amountCents: 10000,
        quantity: 1,
      ),
    ],
  );

  if (result.success) {
    print('Wallet payment successful: ${result.transactionId}');
  } else {
    print('Wallet payment failed: ${result.error}');
  }
}
```

### 4. Save Card (Without Payment)

```dart
Future<void> saveCard() async {
  final billingData = PaymobBillingData(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '+201234567890',
    city: 'Cairo',
    country: 'Egypt',
  );

  final result = await PaymobClient.instance.saveCard(
    billingData: billingData,
  );

  if (result.success) {
    print('Card saved: ${result.cardToken}');
    print('Masked PAN: ${result.cardMaskedPan}');
  } else {
    print('Card save failed: ${result.error}');
  }
}
```

### 5. Low-Level Native Service Usage

```dart
import 'package:your_app/services/paymob_native_service.dart';

Future<void> directNativeCall() async {
  // Assuming you have a payment key from your backend
  final String paymentKey = 'payment_key_from_backend';

  final result = await PaymobNativeService.payWithCard(
    paymentKey: paymentKey,
    saveCard: true,
  );

  if (result.success) {
    print('Direct payment successful: ${result.transactionId}');
  } else {
    print('Direct payment failed: ${result.error}');
  }
}
```

## Data Models

### PaymobPaymentResult
```dart
class PaymobPaymentResult {
  final bool success;
  final String? error;
  final String? transactionId;
  final String? paymobTransactionId;
  final String? cardSubtype;
  final String? maskedPan;
  final String? orderId;
  final String? cardToken;
  final String? cardMaskedPan;
}
```

### PaymobBillingData
```dart
class PaymobBillingData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String apartment;
  final String floor;
  final String street;
  final String building;
  final String shippingMethod;
  final String postalCode;
  final String city;
  final String country;
  final String state;
}
```

### PaymobOrderItem
```dart
class PaymobOrderItem {
  final String name;
  final String description;
  final int amountCents;
  final int quantity;
}
```

## Error Handling

The integration provides comprehensive error handling:

1. **Network Errors**: API call failures
2. **Authentication Errors**: Invalid credentials
3. **Validation Errors**: Invalid payment data
4. **Platform Errors**: Native SDK errors
5. **User Cancellation**: Payment cancelled by user

All methods return `PaymobPaymentResult` with `success` boolean and optional `error` message.

## Testing

### Test Cards (Sandbox)
For testing in sandbox environment, use these test cards:

**Successful Payment:**
- Card Number: `4987654321098769`
- CVV: `123`
- Expiry: Any future date

**Failed Payment:**
- Card Number: `4000000000000002`
- CVV: `123`
- Expiry: Any future date

### Test Wallets
Use test phone numbers provided by Paymob for wallet testing.

## Security Considerations

1. **API Keys**: Never expose API keys in client-side code
2. **Backend Integration**: Always verify payments on your backend using webhooks
3. **HTTPS**: Use HTTPS for all API communications
4. **Token Storage**: Securely store card tokens if implementing saved cards
5. **User Data**: Handle user data according to PCI DSS compliance

## Best Practices

1. **Error Handling**: Always handle payment errors gracefully
2. **Loading States**: Show loading indicators during payment processing
3. **User Feedback**: Provide clear feedback on payment success/failure
4. **Timeout Handling**: Implement appropriate timeouts for payment operations
5. **Testing**: Test thoroughly on both Android and iOS devices
6. **Webhooks**: Implement webhook handling for payment verification

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure all dependencies are properly added
2. **Platform Channel Errors**: Check channel name consistency
3. **Payment Failures**: Verify API credentials and integration IDs
4. **iOS Build Issues**: Run `cd ios && pod install` after adding dependencies
5. **Android Build Issues**: Clean and rebuild project

### Debug Mode
Enable debug logging in `PaymobClient` for detailed request/response logs.

## Integration Commands

### Run the Application
```bash
flutter run
```

### Build for Production
```bash
# Android
flutter build appbundle

# iOS
flutter build ios
```

### Install iOS Dependencies
```bash
cd ios && pod install
```

### Clean Project
```bash
flutter clean
flutter pub get
```

## Support

For issues related to:
- **Paymob SDK**: Contact Paymob support
- **Integration Code**: Check this documentation and example code
- **Flutter**: Refer to Flutter documentation

## Changelog

- **v1.0.0**: Initial implementation with card and wallet payments
- **v1.1.0**: Added card saving functionality
- **v1.2.0**: Enhanced error handling and documentation

---

This integration provides a complete, production-ready solution for accepting payments in your Flutter app using Paymob's native SDKs. The platform channel approach ensures optimal performance and user experience across both Android and iOS platforms.