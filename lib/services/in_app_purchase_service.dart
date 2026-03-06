import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import '../screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import '../models/verify_purchase_request.dart';
import '../enums/billing_period.dart';
import '../domain/usecases/verify_google_play_purchase_use_case.dart';

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
      if (isAvailable.value) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          _onPurchaseUpdated,
          onDone: () => _log("Purchase stream done"),
          onError: (error) => _log("Purchase stream error: $error"),
        );

        // await getCurrentSubscriptions();
      }
    } catch (e) {
      _log("Failed to initialize purchases: $e");
      isAvailable.value = false;
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

      // Determine product ID based on environment
      String productId = _getProductId(plan, isMonthly);
      _log("purchaseSubscription using productId:$productId");

      // Get base plan ID for subscription
      String basePlanId = _getBasePlanId(plan, isMonthly);

      // Store purchase context for verification
      _purchaseContext[productId] = {
        'plan': plan,
        'isMonthly': isMonthly,
        'subscriptionPlanCode': plan.purchaseCode ?? '',
        'basePlanId': basePlanId,
      };

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



      // 1. Find the token for your specific basePlanId
      String? selectedOfferToken;

      // Check if this is a Google Play product and access subscription offers
      if (product is GooglePlayProductDetails) {
        final productWrapper = product.productDetails;
        final offers = productWrapper.subscriptionOfferDetails;

        if (offers != null && offers.isNotEmpty) {
          String targetBasePlanId = _getBasePlanId(plan, isMonthly);

          // Find the appropriate offer based on base plan ID
          for (SubscriptionOfferDetailsWrapper offer in offers) {
            if (offer.basePlanId == targetBasePlanId) {
              selectedOfferToken = offer.offerIdToken;
              break;
            }
          }
        }
      }

      // 2. Explicitly pass the token to GooglePlayPurchaseParam
      bool success = false;
      if (selectedOfferToken != null) {
        final purchaseParam = GooglePlayPurchaseParam(
          productDetails: product,
          offerToken: selectedOfferToken, // <--- THIS is where it is used
        );
        success = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      }

      _log("Product details: ${product.toString()}");
      _log("Product raw price: ${product.rawPrice}");

      // For Google Play subscriptions, we need to specify the base plan
      // Note: The base plan selection is handled by Google Play Billing Library
      // when there are multiple base plans available
      _log("purchaseSubscription using basePlanId:$basePlanId");

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


  // Refresh subscription status
  Future<void> refreshSubscriptionStatus() async {
    _log("Refreshing subscription status...");
    await getCurrentSubscriptions();
  }

  // Get appropriate product ID based on environment
  String _getProductId(SubscriptionPlanItemUiState plan, bool isMonthly) {
    // For Google Play subscriptions with specific base plans, create unique product IDs
    var basePlanId = plan.purchaseCode ?? "";
    // basePlanId += isMonthly ? '_monthly' : '_yearly';
    // var productId = "assistant_subscription_plan_$basePlanId";
    // _log("_getProductId productId:$productId, plan:${plan.toJson()}");
    return 'assistant_subscription_plan';
  }

  // Get base plan ID for the subscription
  String _getBasePlanId(SubscriptionPlanItemUiState plan, bool isMonthly) {
    var basePlanId = plan.purchaseCode ?? "";
    basePlanId += isMonthly ? '-monthly' : '-yearly';
    _log("_getBasePlanId basePlanId:$basePlanId");
    return basePlanId;
  }

  void _log(String s) {
    appLog("InAppPurchaseService $s");
  }
}