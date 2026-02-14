import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:teacher_app/services/environment_service.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';

import '../screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import '../models/verify_purchase_request.dart';
import '../models/verify_purchase_response.dart';
import '../enums/billing_period.dart';
import '../domain/usecases/verify_google_play_purchase_use_case.dart';
import '../base/AppResult.dart';

class InAppPurchaseService extends GetxService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  RxBool isAvailable = false.obs;
  RxBool isLoading = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  RxList<PurchaseDetails> activeSubscriptions = <PurchaseDetails>[].obs;
  Rx<PurchaseDetails?> currentSubscription = Rx<PurchaseDetails?>(null);

  // Track current purchase context for verification
  Map<String, Map<String, dynamic>> _purchaseContext = {};

  // Use case for subscription verification
  final VerifyGooglePlayPurchaseUseCase _verifyPurchaseUseCase = VerifyGooglePlayPurchaseUseCase();

  // Testing mode flag - active when debug, dev, or local
  bool get isTestMode => false;//kDebugMode || AppMode.isDev || AppMode.isLocal;

  // Test product IDs for different platforms
  final Map<String, String> _testProductIds = {
    'android_test_purchased': 'android.test.purchased',
    'android_test_canceled': 'android.test.canceled',
    'android_test_refunded': 'android.test.refunded',
    'android_test_unavailable': 'android.test.item_unavailable',
    'ios_test_subscription': 'your_ios_test_subscription_id',
  };

  @override
  Future<void> onInit() async {
    _log("onInit");
    super.onInit();
  }

  @override
  void onClose() {
    _log("onClose");
    _subscription.cancel();
    super.onClose();
    // initializePurchases();
  }

  Future<void> initializePurchases() async {
    _log("initializePurchases");
    try {
      isAvailable.value = await _inAppPurchase.isAvailable();

      if (isTestMode) {
        _log("=== IN-APP PURCHASE TESTING MODE ACTIVE ===");
        _log("Environment: ${AppMode.isDev ? 'DEV' : AppMode.isLocal ? 'LOCAL' : 'DEBUG'}");
        _log("Debug mode: $kDebugMode");
        _log("==========================================");
      }

      if (isAvailable.value) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          _onPurchaseUpdated,
          onDone: () => _log("Purchase stream done"),
          onError: (error) => _log("Purchase stream error: $error"),
        );

        // Load test products if in test mode
        if (isTestMode) {
          await _loadTestProducts();
        }

        // await getCurrentSubscriptions();
      }
    } catch (e) {
      _log("Failed to initialize purchases: $e");
      isAvailable.value = false;
    }
  }

  Future<void> _loadTestProducts() async {
    List<String> testProducts = [];

    if (Platform.isAndroid) {
      testProducts.addAll(_testProductIds.values.where((id) => id.startsWith('android')));
    } else if (Platform.isIOS) {
      // Add your actual iOS test product IDs here
      testProducts.add(_testProductIds['ios_test_subscription']!);
    }

    if (testProducts.isNotEmpty) {
      _log("Loading test products: $testProducts");
      await loadMultipleProducts(testProducts);
    }
  }

  Future<ProductDetails?> loadProducts(String productId) async {
    if (!isAvailable.value) {
      _log("loadProducts In-app purchase not available");
      return null;
    }

    try {
      isLoading.value = true;
      _log("loadProducts Loading product: $productId");

      final response = await _inAppPurchase.queryProductDetails({productId});

      if (response.error != null) {
        _log("loadProducts Error loading product $productId: ${response.error}");
        return null;
      }

      if (response.productDetails.isNotEmpty) {
        final product = response.productDetails.first;

        // Add to products list if not already exists
        if (!products.any((p) => p.id == product.id)) {
          products.add(product);
        }

        _log("loadProducts Successfully loaded product: ${product.id} - ${product.title} - ${product.price} - ${product.currencyCode} - ${product.currencySymbol}");
        return product;
      } else {
        _log("loadProducts Product not found: $productId");
        return null;
      }
    } catch (e) {
      _log("loadProducts Failed to load product $productId: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMultipleProducts(List<String> productIds) async {
    if (!isAvailable.value) {
      _log("loadMultipleProducts In-app purchase not available");
      return;
    }

    try {
      isLoading.value = true;
      _log("loadMultipleProducts Loading ${productIds.length} products: $productIds");

      final response = await _inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        _log("loadMultipleProducts Error loading products: ${response.error}");
        return;
      }

      // Update products list with new products
      for (final product in response.productDetails) {
        if (!products.any((p) => p.id == product.id)) {
          products.add(product);
        }
      }

      _log("loadMultipleProducts Loaded ${response.productDetails.length} products, total: ${products.length}");
    } catch (e) {
      _log("loadMultipleProducts Failed to load products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> purchaseSubscription(SubscriptionPlanItemUiState plan, {bool isMonthly = true}) async {
    if (!isAvailable.value) {
      Get.snackbar(
        'Error'.tr,
        'In-app purchase not available'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;

      _log("purchaseSubscription products count:${products.length}");
      _log("purchaseSubscription plan purchaseCode:${plan.purchaseCode}");
      _log("purchaseSubscription isTestMode:$isTestMode");

      // Determine product ID based on environment
      String productId = _getProductId(plan, isMonthly);
      _log("purchaseSubscription using productId:$productId");

      // Store purchase context for verification
      _purchaseContext[productId] = {
        'plan': plan,
        'isMonthly': isMonthly,
        'subscriptionPlanCode': plan.purchaseCode ?? '',
      };

      // Special handling for Android test products
      if (isTestMode && Platform.isAndroid && productId.startsWith('android.test.')) {
        _log("Handling Android test product directly: $productId");
        // Show test product selector dialog
        return await _showTestProductSelector(plan, isMonthly);
      }

      // Find the product for real products
      ProductDetails? product = products.firstWhereOrNull(
        (product) => product.id == productId,
      );

      _log("purchaseSubscription product title:${product?.title}");
      _log("purchaseSubscription product price:${product?.price}");

      product ??= await loadProducts(productId);

      if (product == null) {
        Get.snackbar(
          'Error'.tr,
          'Product not found: $productId',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Create purchase param
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Initiate purchase
      bool success;
      if (product.id.contains('subscription') || isMonthly || !isMonthly) {
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        success = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }

      if (!success) {
        Get.snackbar(
          'Error'.tr,
          'Failed to initiate purchase'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      _log("Purchase error: $e");
      Get.snackbar(
        'Error'.tr,
        'Purchase failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
      // Update active subscriptions list
      _updateActiveSubscriptions(purchaseDetails);
    }
  }

  // Update active subscriptions based on purchase details
  void _updateActiveSubscriptions(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {

      // Add to active subscriptions if not already present
      final existingIndex = activeSubscriptions.indexWhere(
        (sub) => sub.productID == purchaseDetails.productID
      );

      if (existingIndex != -1) {
        // Update existing subscription
        activeSubscriptions[existingIndex] = purchaseDetails;
      } else {
        // Add new subscription
        activeSubscriptions.add(purchaseDetails);
      }

      // Set as current subscription (assuming one active subscription for now)
      currentSubscription.value = purchaseDetails;

      _log("Updated active subscription: ${purchaseDetails.productID}");
    } else if (purchaseDetails.status == PurchaseStatus.canceled ||
               purchaseDetails.status == PurchaseStatus.error) {

      // Remove from active subscriptions
      activeSubscriptions.removeWhere(
        (sub) => sub.productID == purchaseDetails.productID
      );

      // Clear current subscription if it matches
      if (currentSubscription.value?.productID == purchaseDetails.productID) {
        currentSubscription.value = null;
      }

      _log("Removed subscription from active list: ${purchaseDetails.productID}");
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {

    _log("Purchase: ${purchaseDetails.status}, ${purchaseDetails.productID}, ${purchaseDetails.purchaseID}, ${purchaseDetails.verificationData.localVerificationData}, ${purchaseDetails.verificationData.serverVerificationData}");

    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        Get.snackbar(
          'Processing'.tr,
          'Purchase is being processed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;

      case PurchaseStatus.purchased:
        await _completePurchase(purchaseDetails);
        break;

      case PurchaseStatus.restored:
        await _completePurchase(purchaseDetails);
        break;

      case PurchaseStatus.error:
        Get.snackbar(
          'Error'.tr,
          purchaseDetails.error?.message ?? 'Purchase failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;

      case PurchaseStatus.canceled:
        Get.snackbar(
          'Cancelled'.tr,
          'Purchase was cancelled'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );
        break;
    }

    // Always complete the purchase to avoid issues
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      // Verify purchase with your backend
      bool verified = await _verifyPurchaseWithBackend(purchaseDetails);

      if (verified) {
        // // For Android subscriptions, verify with Google Play to get expiry date
        // if (Platform.isAndroid) {
        //   await verifyGooglePlaySubscription(purchaseDetails);
        // }

        Get.snackbar(
          'Success'.tr,
          'Purchase completed successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // // Refresh subscription status
        // await refreshSubscriptionStatus();
      } else {
        Get.snackbar(
          'Error'.tr,
          'Failed to verify purchase'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _log("Error completing purchase: $e");
      Get.snackbar(
        'Error'.tr,
        'Failed to complete purchase'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> _verifyPurchaseWithBackend(PurchaseDetails purchaseDetails) async {
    try {

      // Production verification logic
      _log("Verifying purchase with backend: ${purchaseDetails.productID}");
      _log("Purchase ID: ${purchaseDetails.purchaseID}");
      _log("Transaction date: ${purchaseDetails.transactionDate}");

      // Get purchase context
      final context = _purchaseContext[purchaseDetails.productID];
      if (context == null) {
        _log("No purchase context found for product: ${purchaseDetails.productID}");
        return false;
      }

      final plan = context['plan'] as SubscriptionPlanItemUiState;
      final isMonthly = context['isMonthly'] as bool;

      // Create verification request
      final verifyRequest = VerifyPurchaseRequest(
        packageName: 'com.assistant.teacher',
        productId: purchaseDetails.productID,
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        subscriptionPlanCode: plan.planCode,
        billingPeriod: isMonthly ? BillingPeriod.MONTHLY : BillingPeriod.YEARLY,
      );

      showDialogLoading();
      // Call backend API through use case
      final result = await _verifyPurchaseUseCase.execute(verifyRequest);
      hideDialogLoading();
      if (result.isSuccess && result.data != null) {
        final verifyResponse = result.data!;
        _log("Purchase verification response: ${verifyResponse.message}");
        _log("Verified: ${verifyResponse.verified}");
        _log("Success: ${verifyResponse.success}");

        if (verifyResponse.success && verifyResponse.verified) {
          // Update subscription expiry if available
          if (verifyResponse.expirationDate != null) {
            subscriptionExpiryDate.value = verifyResponse.expirationDate;
            _log("Subscription expires: ${subscriptionExpiryDate.value}");
          }
          // Clean up purchase context
          _purchaseContext.remove(purchaseDetails.productID);

          return true;
        }
      } else if (result.isError) {
        _log("Use case error: ${result.error?.toString()}");
      }

      _log("Backend verification failed or returned invalid response");
      return false;
    } catch (e) {
      _log("Purchase verification failed: $e");
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!isAvailable.value) {
      Get.snackbar(
        'Error'.tr,
        'In-app purchase not available'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _inAppPurchase.restorePurchases();

      Get.snackbar(
        'Info'.tr,
        'Restore completed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      _log("Restore purchases failed: $e");
      Get.snackbar(
        'Error'.tr,
        'Failed to restore purchases'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get product price
  String getProductPrice(String productId) {
    ProductDetails? product = products.firstWhereOrNull(
      (product) => product.id == productId,
    );
    return product?.price ?? '';
  }

  // Helper method to check if product exists
  bool hasProduct(String productId) {
    return products.any((product) => product.id == productId);
  }

  // Get current subscriptions
  Future<void> getCurrentSubscriptions() async {
    if (!isAvailable.value) {
      _log("getCurrentSubscriptions: In-app purchase not available");
      return;
    }

    try {
      _log("Loading current subscriptions...");

      if (isTestMode) {
        // In test mode, simulate having an active subscription
        await _loadTestSubscription();
        return;
      }

      // Query past purchases
      await _inAppPurchase.restorePurchases();

      _log("Current subscriptions loaded: ${activeSubscriptions.length}");
    } catch (e) {
      _log("Failed to load current subscriptions: $e");
    }
  }

  // Check if user has an active subscription
  bool get hasActiveSubscription {
    return currentSubscription.value != null &&
           currentSubscription.value!.status == PurchaseStatus.purchased;
  }

  // Get current subscription status
  String get subscriptionStatus {
    if (currentSubscription.value == null) {
      return 'No subscription';
    }

    switch (currentSubscription.value!.status) {
      case PurchaseStatus.purchased:
        return 'Active';
      case PurchaseStatus.pending:
        return 'Pending';
      case PurchaseStatus.error:
        return 'Error';
      case PurchaseStatus.canceled:
        return 'Cancelled';
      case PurchaseStatus.restored:
        return 'Restored';
      default:
        return 'Unknown';
    }
  }

  // Get current subscription product ID
  String? get currentSubscriptionProductId {
    return currentSubscription.value?.productID;
  }

  // Subscription expiry date from Google Play
  Rx<DateTime?> subscriptionExpiryDate = Rx<DateTime?>(null);
  RxBool isAutoRenewing = false.obs;

  // Get subscription expiry date
  DateTime? get currentSubscriptionExpiryDate => subscriptionExpiryDate.value;

  // Check if subscription is expired
  bool get isSubscriptionExpired {
    final expiryDate = subscriptionExpiryDate.value;
    if (expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate);
  }

  // Check if subscription is active
  bool get isSubscriptionActive {
    return hasActiveSubscription && !isSubscriptionExpired;
  }

  // Get days until expiry
  int get daysUntilExpiry {
    final expiryDate = subscriptionExpiryDate.value;
    if (expiryDate == null) return 0;
    final now = DateTime.now();
    if (now.isAfter(expiryDate)) return 0;
    return expiryDate.difference(now).inDays;
  }

  // Extract subscription details from Google Play receipt
  Map<String, dynamic>? _parseGooglePlayReceipt(String receiptData) {
    try {
      if (receiptData.isEmpty) return null;

      // For Google Play, the receipt data is typically a JSON string
      // containing purchase token and other details

      // The actual subscription details need to be verified with Google Play API
      // This requires server-side verification

      _log("Parsing Google Play receipt: ${receiptData.length} characters");

      // Return basic info that can be extracted locally
      return {
        'purchaseToken': receiptData,
        'needsServerVerification': true,
      };

    } catch (e) {
      _log("Error parsing Google Play receipt: $e");
      return null;
    }
  }

  // Verify subscription with Google Play (requires backend)
  Future<bool> verifyGooglePlaySubscription(PurchaseDetails purchaseDetails) async {
    try {
      _log("Verifying Google Play subscription...");

      if (!Platform.isAndroid) {
        _log("Not Android platform, skipping Google Play verification");
        return false;
      }

      final receiptData = purchaseDetails.verificationData.serverVerificationData;
      final productId = purchaseDetails.productID;

      _log("Product ID: $productId");
      _log("Receipt data length: ${receiptData.length}");

      // Parse local receipt info
      final receiptInfo = _parseGooglePlayReceipt(receiptData);
      if (receiptInfo == null) {
        _log("Failed to parse receipt data");
        return false;
      }

      // TODO: Send to your backend to verify with Google Play API
      // Your backend should call:
      // https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}

      final verificationResult = await _verifyWithBackendGooglePlay(
        productId: productId,
        purchaseToken: receiptInfo['purchaseToken'],
        packageName: 'your.package.name', // Replace with your package name
      );

      if (verificationResult != null && verificationResult['isValid'] == true) {
        // Extract expiry date from verification result
        final expiryTimeMillis = verificationResult['expiryTimeMillis'];
        if (expiryTimeMillis != null) {
          subscriptionExpiryDate.value = DateTime.fromMillisecondsSinceEpoch(
            int.parse(expiryTimeMillis.toString())
          );
        }

        // Extract auto-renew status
        isAutoRenewing.value = verificationResult['autoRenewing'] ?? false;

        _log("Subscription verified. Expires: ${subscriptionExpiryDate.value}");
        _log("Auto-renewing: ${isAutoRenewing.value}");

        return true;
      }

      return false;

    } catch (e) {
      _log("Error verifying Google Play subscription: $e");
      return false;
    }
  }

  // Call your backend to verify with Google Play API
  Future<Map<String, dynamic>?> _verifyWithBackendGooglePlay({
    required String productId,
    required String purchaseToken,
    required String packageName,
  }) async {
    try {
      _log("Calling backend for Google Play verification...");

      // TODO: Replace with actual API call to your backend
      // Your backend should make this call to Google Play:
      /*
      final response = await http.get(
        Uri.parse('https://androidpublisher.googleapis.com/androidpublisher/v3/applications/$packageName/purchases/subscriptions/$productId/tokens/$purchaseToken'),
        headers: {
          'Authorization': 'Bearer $accessToken', // Google Play API access token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'isValid': true,
          'expiryTimeMillis': data['expiryTimeMillis'],
          'autoRenewing': data['autoRenewing'] == true,
          'orderId': data['orderId'],
          'purchaseState': data['purchaseState'], // 0 = purchased, 1 = cancelled
          'paymentState': data['paymentState'], // 0 = pending, 1 = received, 2 = free trial, 3 = pending deferred upgrade/downgrade
        };
      }
      */

      // For now, simulate the response
      await Future.delayed(Duration(seconds: 1));

      return {
        'isValid': true,
        'expiryTimeMillis': DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch,
        'autoRenewing': true,
        'orderId': 'test_order_${DateTime.now().millisecondsSinceEpoch}',
        'purchaseState': 0, // purchased
        'paymentState': 1, // received
      };

    } catch (e) {
      _log("Backend verification failed: $e");
      return null;
    }
  }

  // Load test subscription for test mode
  Future<void> _loadTestSubscription() async {
    _log("Loading test subscription data");

    // Simulate having an active subscription in test mode
    if (Platform.isAndroid) {
      // Create a mock PurchaseDetails for testing
      // Note: In real implementation, this would come from actual purchase history
      _log("Simulating active Android test subscription");

      // For demonstration purposes, we'll just log the simulation
      // In practice, you'd create a proper PurchaseDetails object if available
    } else if (Platform.isIOS) {
      _log("Simulating active iOS test subscription");
    }
  }

  // Refresh subscription status
  Future<void> refreshSubscriptionStatus() async {
    _log("Refreshing subscription status...");
    await getCurrentSubscriptions();
  }

  // Get appropriate product ID based on environment
  String _getProductId(SubscriptionPlanItemUiState plan, bool isMonthly) {

    if (isTestMode) {
      // Use test products in testing mode
      if (Platform.isAndroid) {
        return _testProductIds['android_test_purchased']!;
      } else if (Platform.isIOS) {
        return _testProductIds['ios_test_subscription']!;
      }
    }

    var purchaseCode = plan.purchaseCode ?? "";
    purchaseCode += isMonthly ? (plan.planCode.endsWith('_200') ? '_month_200' : '_month') : (plan.planCode.endsWith('_200') ? '_yearly_200' : '_yearly');
    _log("_getProductId purchaseCode:$purchaseCode, plan:${plan.toJson()}");
    return purchaseCode;
  }

  // Show test product selector dialog
  Future<bool> _showTestProductSelector(SubscriptionPlanItemUiState plan, bool isMonthly) async {
    final Completer<bool> completer = Completer<bool>();

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bug_report, color: Colors.orange),
            SizedBox(width: 8),
            Text("Test Purchase Simulator".tr),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select test scenario:".tr,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              ..._buildTestOptions().map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        final result = await _simulateTestPurchase(option, plan, isMonthly);
                        completer.complete(result);
                      },
                      icon: Icon(option['icon'] as IconData, size: 20),
                      label: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            option['description'] as String,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: option['color'] as Color,
                        foregroundColor: Colors.white,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              completer.complete(false);
            },
            child: Text("Cancel".tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return completer.future;
  }

  List<Map<String, dynamic>> _buildTestOptions() {
    return [
      {
        'id': 'android.test.purchased',
        'title': 'Successful Purchase',
        'description': 'Simulate successful payment',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'id': 'android.test.canceled',
        'title': 'Cancelled Purchase',
        'description': 'User cancels payment dialog',
        'icon': Icons.cancel,
        'color': Colors.orange,
      },
      {
        'id': 'android.test.refunded',
        'title': 'Refunded Purchase',
        'description': 'Payment refunded by store',
        'icon': Icons.replay,
        'color': Colors.blue,
      },
      {
        'id': 'android.test.item_unavailable',
        'title': 'Product Unavailable',
        'description': 'Product not available for purchase',
        'icon': Icons.error,
        'color': Colors.red,
      },
    ];
  }

  Future<bool> _simulateTestPurchase(Map<String, dynamic> testOption, SubscriptionPlanItemUiState plan, bool isMonthly) async {
    final String testProductId = testOption['id'];
    final String title = testOption['title'];

    _log("=== SIMULATING TEST PURCHASE ===");
    _log("Test Product: $testProductId");
    _log("Scenario: $title");
    _log("Plan: ${plan.planName}");
    _log("Monthly: $isMonthly");
    _log("===============================");

    // Show processing indicator
    Get.snackbar(
      'Test Mode'.tr,
      'Simulating: $title',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: testOption['color'] as Color,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    // Simulate processing time
    await Future.delayed(Duration(milliseconds: 1500));

    // Simulate different outcomes based on test product
    switch (testProductId) {
      case 'android.test.purchased':
        await _simulateSuccessfulPurchase(plan);
        return true;

      case 'android.test.canceled':
        await _simulateCancelledPurchase();
        return false;

      case 'android.test.refunded':
        await _simulateRefundedPurchase(plan);
        return true;

      case 'android.test.item_unavailable':
        await _simulateUnavailableProduct();
        return false;

      default:
        return false;
    }
  }

  Future<void> _simulateSuccessfulPurchase(SubscriptionPlanItemUiState plan) async {
    _log("Simulating successful purchase completion");

    // Simulate verification
    Get.snackbar(
      'Processing'.tr,
      'Verifying purchase...'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    await Future.delayed(Duration(seconds: 2));

    // Show success
    Get.snackbar(
      'Success'.tr,
      'Test purchase completed successfully!\nSubscription: ${plan.planName}'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
    );
  }

  Future<void> _simulateCancelledPurchase() async {
    _log("Simulating cancelled purchase");

    Get.snackbar(
      'Cancelled'.tr,
      'Test purchase was cancelled by user',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> _simulateRefundedPurchase(SubscriptionPlanItemUiState plan) async {
    _log("Simulating refunded purchase");

    // First show success
    Get.snackbar(
      'Purchased'.tr,
      'Test purchase completed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    await Future.delayed(Duration(seconds: 2));

    // Then show refund
    Get.snackbar(
      'Refunded'.tr,
      'Test purchase was refunded',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> _simulateUnavailableProduct() async {
    _log("Simulating unavailable product");

    Get.snackbar(
      'Error'.tr,
      'Test product is currently unavailable',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  // Debug method to test purchase flow
  Future<void> testPurchaseFlow() async {
    if (!isTestMode) {
      _log("testPurchaseFlow only available in test mode");
      return;
    }

    _log("=== TESTING PURCHASE FLOW ===");

    // Test product loading
    await _loadTestProducts();

    // Log available products
    for (var product in products) {
      _log("Available product: ${product.id} - ${product.title} - ${product.price}");
    }

    _log("============================");
  }

  // Quick test method to open test selector directly
  Future<void> showTestSelector(SubscriptionPlanItemUiState plan, {bool isMonthly = true}) async {
    if (!isTestMode) {
      Get.snackbar(
        'Error'.tr,
        'Test mode not available in production',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _showTestProductSelector(plan, isMonthly);
  }

  void _log(String s) {
    appLog("InAppPurchaseService $s");
  }
}