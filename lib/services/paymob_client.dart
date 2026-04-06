// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'paymob_native_service.dart';
//
// /// Complete Paymob client that integrates API calls with native SDK
// class PaymobClient {
//   static PaymobClient? _instance;
//   static PaymobClient get instance => _instance ??= PaymobClient._internal();
//
//   PaymobClient._internal();
//
//   late final Dio _dio;
//   late final String _apiKey;
//   late final int _integrationId;
//   late final int? _walletIntegrationId;
//   late final int _iframeId;
//
//   String? _authToken;
//   bool _isInitialized = false;
//
//   /// Initialize the Paymob client with your credentials
//   ///
//   /// [apiKey] - Your Paymob API key
//   /// [integrationId] - Integration ID for card payments
//   /// [walletIntegrationId] - Integration ID for wallet payments (optional)
//   /// [iframeId] - Iframe ID for web payments
//   /// [baseUrl] - Paymob API base URL (defaults to production)
//   void initialize({
//     required String apiKey,
//     required int integrationId,
//     int? walletIntegrationId,
//     required int iframeId,
//     String baseUrl = 'https://accept.paymob.com/api',
//   }) {
//     _apiKey = apiKey;
//     _integrationId = integrationId;
//     _walletIntegrationId = walletIntegrationId;
//     _iframeId = iframeId;
//
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     ));
//
//     // Add interceptors for logging in debug mode
//     if (kDebugMode) {
//       _dio.interceptors.add(LogInterceptor(
//         requestBody: true,
//         responseBody: true,
//         logPrint: (obj) => debugPrint(obj.toString()),
//       ));
//     }
//
//     _isInitialized = true;
//   }
//
//   /// Check if client is initialized
//   bool get isInitialized => _isInitialized;
//
//   /// Get authentication token
//   Future<String> _getAuthToken() async {
//     if (_authToken != null) return _authToken!;
//
//     try {
//       final response = await _dio.post('/auth/tokens', data: {
//         'api_key': _apiKey,
//       });
//
//       _authToken = response.data['token'];
//       return _authToken!;
//     } catch (e) {
//       throw PaymobException('Failed to authenticate: $e');
//     }
//   }
//
//   /// Create an order for payment
//   ///
//   /// [amountCents] - Amount in cents (e.g., 1000 = 10 EGP)
//   /// [currency] - Currency code (default: 'EGP')
//   /// [items] - List of order items
//   /// [shippingData] - Customer shipping information
//   Future<PaymobOrder> createOrder({
//     required int amountCents,
//     String currency = 'EGP',
//     List<PaymobOrderItem> items = const [],
//     PaymobShippingData? shippingData,
//   }) async {
//     if (!_isInitialized) {
//       throw PaymobException('PaymobClient not initialized');
//     }
//
//     final token = await _getAuthToken();
//
//     try {
//       final response = await _dio.post(
//         '/ecommerce/orders',
//         data: {
//           'auth_token': token,
//           'amount_cents': amountCents,
//           'currency': currency,
//           'delivery_needed': 'false',
//           'items': items.map((item) => item.toMap()).toList(),
//           'shipping_data': shippingData?.toMap(),
//         },
//       );
//
//       return PaymobOrder.fromMap(response.data);
//     } catch (e) {
//       throw PaymobException('Failed to create order: $e');
//     }
//   }
//
//   /// Create payment key for card payment
//   ///
//   /// [order] - The order to create payment key for
//   /// [billingData] - Customer billing information
//   Future<String> createCardPaymentKey({
//     required PaymobOrder order,
//     required PaymobBillingData billingData,
//   }) async {
//     return _createPaymentKey(
//       order: order,
//       billingData: billingData,
//       integrationId: _integrationId,
//     );
//   }
//
//   /// Create payment key for wallet payment
//   ///
//   /// [order] - The order to create payment key for
//   /// [billingData] - Customer billing information
//   Future<String> createWalletPaymentKey({
//     required PaymobOrder order,
//     required PaymobBillingData billingData,
//   }) async {
//     if (_walletIntegrationId == null) {
//       throw PaymobException('Wallet integration ID not provided');
//     }
//
//     return _createPaymentKey(
//       order: order,
//       billingData: billingData,
//       integrationId: _walletIntegrationId!,
//     );
//   }
//
//   /// Create payment key
//   Future<String> _createPaymentKey({
//     required PaymobOrder order,
//     required PaymobBillingData billingData,
//     required int integrationId,
//   }) async {
//     final token = await _getAuthToken();
//
//     try {
//       final response = await _dio.post(
//         '/acceptance/payment_keys',
//         data: {
//           'auth_token': token,
//           'amount_cents': order.amountCents,
//           'currency': order.currency,
//           'order_id': order.id,
//           'billing_data': billingData.toMap(),
//           'integration_id': integrationId,
//           'expiration': 3600, // 1 hour expiration
//         },
//       );
//
//       return response.data['token'];
//     } catch (e) {
//       throw PaymobException('Failed to create payment key: $e');
//     }
//   }
//
//   /// Pay with card using native SDK
//   ///
//   /// [amountCents] - Amount in cents
//   /// [billingData] - Customer billing information
//   /// [items] - Order items (optional)
//   /// [shippingData] - Shipping information (optional)
//   /// [saveCard] - Whether to save card (default: false)
//   Future<PaymobPaymentResult> payWithCard({
//     required int amountCents,
//     required PaymobBillingData billingData,
//     List<PaymobOrderItem> items = const [],
//     PaymobShippingData? shippingData,
//     bool saveCard = false,
//   }) async {
//     try {
//       // Create order
//       final order = await createOrder(
//         amountCents: amountCents,
//         items: items,
//         shippingData: shippingData,
//       );
//
//       // Create payment key
//       final paymentKey = await createCardPaymentKey(
//         order: order,
//         billingData: billingData,
//       );
//
//       // Process payment using native SDK
//       return await PaymobNativeService.payWithCard(
//         paymentKey: paymentKey,
//         saveCard: saveCard,
//       );
//     } catch (e) {
//       return PaymobPaymentResult(
//         success: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   /// Pay with wallet using native SDK
//   ///
//   /// [amountCents] - Amount in cents
//   /// [billingData] - Customer billing information
//   /// [redirectUrl] - Wallet redirect URL
//   /// [items] - Order items (optional)
//   /// [shippingData] - Shipping information (optional)
//   Future<PaymobPaymentResult> payWithWallet({
//     required int amountCents,
//     required PaymobBillingData billingData,
//     required String redirectUrl,
//     List<PaymobOrderItem> items = const [],
//     PaymobShippingData? shippingData,
//   }) async {
//     try {
//       // Create order
//       final order = await createOrder(
//         amountCents: amountCents,
//         items: items,
//         shippingData: shippingData,
//       );
//
//       // Create payment key
//       final paymentKey = await createWalletPaymentKey(
//         order: order,
//         billingData: billingData,
//       );
//
//       // Process payment using native SDK
//       return await PaymobNativeService.payWithWallet(
//         paymentKey: paymentKey,
//         redirectUrl: redirectUrl,
//       );
//     } catch (e) {
//       return PaymobPaymentResult(
//         success: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   /// Save card using native SDK (for future payments)
//   ///
//   /// [billingData] - Customer billing information
//   Future<PaymobPaymentResult> saveCard({
//     required PaymobBillingData billingData,
//   }) async {
//     try {
//       // Create a dummy order for card saving
//       final order = await createOrder(amountCents: 1); // Minimum amount
//
//       // Create payment key
//       final paymentKey = await createCardPaymentKey(
//         order: order,
//         billingData: billingData,
//       );
//
//       // Save card using native SDK
//       return await PaymobNativeService.saveCard(paymentKey: paymentKey);
//     } catch (e) {
//       return PaymobPaymentResult(
//         success: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   /// Get iframe URL for web payments
//   String getIframeUrl(String paymentKey) {
//     return 'https://accept.paymob.com/api/acceptance/iframes/$_iframeId?payment_token=$paymentKey';
//   }
// }
//
// /// Paymob order model
// class PaymobOrder {
//   final int id;
//   final int amountCents;
//   final String currency;
//   final bool deliveryNeeded;
//   final List<PaymobOrderItem> items;
//
//   const PaymobOrder({
//     required this.id,
//     required this.amountCents,
//     required this.currency,
//     required this.deliveryNeeded,
//     required this.items,
//   });
//
//   factory PaymobOrder.fromMap(Map<String, dynamic> map) {
//     return PaymobOrder(
//       id: map['id'],
//       amountCents: map['amount_cents'],
//       currency: map['currency'],
//       deliveryNeeded: map['delivery_needed'],
//       items: (map['items'] as List?)
//               ?.map((item) => PaymobOrderItem.fromMap(item))
//               .toList() ??
//           [],
//     );
//   }
// }
//
// /// Paymob order item model
// class PaymobOrderItem {
//   final String name;
//   final String description;
//   final int amountCents;
//   final int quantity;
//
//   const PaymobOrderItem({
//     required this.name,
//     required this.description,
//     required this.amountCents,
//     required this.quantity,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'description': description,
//       'amount_cents': amountCents,
//       'quantity': quantity,
//     };
//   }
//
//   factory PaymobOrderItem.fromMap(Map<String, dynamic> map) {
//     return PaymobOrderItem(
//       name: map['name'],
//       description: map['description'],
//       amountCents: map['amount_cents'],
//       quantity: map['quantity'],
//     );
//   }
// }
//
// /// Paymob billing data model
// class PaymobBillingData {
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final String apartment;
//   final String floor;
//   final String street;
//   final String building;
//   final String shippingMethod;
//   final String postalCode;
//   final String city;
//   final String country;
//   final String state;
//
//   const PaymobBillingData({
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     this.apartment = 'N/A',
//     this.floor = 'N/A',
//     this.street = 'N/A',
//     this.building = 'N/A',
//     this.shippingMethod = 'N/A',
//     this.postalCode = 'N/A',
//     this.city = 'N/A',
//     this.country = 'N/A',
//     this.state = 'N/A',
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'phone_number': phone,
//       'apartment': apartment,
//       'floor': floor,
//       'street': street,
//       'building': building,
//       'shipping_method': shippingMethod,
//       'postal_code': postalCode,
//       'city': city,
//       'country': country,
//       'state': state,
//     };
//   }
// }
//
// /// Paymob shipping data model
// class PaymobShippingData {
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final String apartment;
//   final String floor;
//   final String street;
//   final String building;
//   final String postalCode;
//   final String city;
//   final String country;
//   final String state;
//
//   const PaymobShippingData({
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     this.apartment = 'N/A',
//     this.floor = 'N/A',
//     this.street = 'N/A',
//     this.building = 'N/A',
//     this.postalCode = 'N/A',
//     this.city = 'N/A',
//     this.country = 'N/A',
//     this.state = 'N/A',
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'phone_number': phone,
//       'apartment': apartment,
//       'floor': floor,
//       'street': street,
//       'building': building,
//       'postal_code': postalCode,
//       'city': city,
//       'country': country,
//       'state': state,
//     };
//   }
// }
//
// /// Paymob exceptions
// class PaymobException implements Exception {
//   final String message;
//
//   const PaymobException(this.message);
//
//   @override
//   String toString() => 'PaymobException: $message';
// }