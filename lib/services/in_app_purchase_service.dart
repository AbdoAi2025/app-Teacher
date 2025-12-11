import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class InAppPurchaseService extends GetxService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  RxBool isAvailable = false.obs;
  RxBool isLoading = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializePurchases();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> _initializePurchases() async {
    try {
      isAvailable.value = await _inAppPurchase.isAvailable();
      if (isAvailable.value) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          _onPurchaseUpdated,
          onDone: () => appLog("Purchase stream done"),
          onError: (error) => appLog("Purchase stream error: $error"),
        );
      }
    } catch (e) {
      appLog("Failed to initialize purchases: $e");
      isAvailable.value = false;
    }
  }

  Future<void> loadProducts(List<String> productIds) async {
    if (!isAvailable.value) {
      appLog("loadProducts In-app purchase not available");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _inAppPurchase.queryProductDetails(productIds.toSet());

      if (response.error != null) {
        appLog("loadProducts Error loading products: ${response.error}");
        return;
      }

      products.value = response.productDetails;
      appLog("loadProducts Loaded ${products.length} products");
    } catch (e) {
      appLog("loadProducts Failed to load products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> purchaseSubscription(SubscriptionPlanModel plan, {bool isMonthly = true}) async {
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

      appLog("purchaseSubscription products count:${products.length}");

      appLog("purchaseSubscription plan purchaseCode:${plan.purchaseCode}");


      // Create product ID based on plan code and billing period
      String productId = "assistantapp_plan_basic_month_200" ; //"${plan.planCode}_${isMonthly ? 'monthly' : 'yearly'}";

      // Find the product
      ProductDetails? product = products.firstWhereOrNull(
        (product) => product.id == productId,
      );

      appLog("purchaseSubscription product title:${product?.title}");
      appLog("purchaseSubscription product price:${product?.price}");

      if (product == null) {
        // If specific product not found, try loading it
        await loadProducts([productId]);
        product = products.firstWhereOrNull((product) => product.id == productId);
      }

      if (product == null) {
        Get.snackbar(
          'Error'.tr,
          'Product not found'.tr,
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
      appLog("Purchase error: $e");
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
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    appLog("Purchase status: ${purchaseDetails.status}");

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
        Get.snackbar(
          'Success'.tr,
          'Purchase completed successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh subscription status
        // You might want to call a method to refresh the user's subscription
        // e.g., Get.find<SubscriptionPlansController>().loadSubscriptionPlans();
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
      appLog("Error completing purchase: $e");
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
      // TODO: Implement backend verification
      // This should send the purchase details to your backend for verification
      // and activate the subscription in your system

      appLog("Verifying purchase: ${purchaseDetails.productID}");
      appLog("Purchase ID: ${purchaseDetails.purchaseID}");
      appLog("Transaction date: ${purchaseDetails.transactionDate}");

      // For now, return true. In production, implement actual verification
      await Future.delayed(Duration(seconds: 2)); // Simulate network call
      return true;
    } catch (e) {
      appLog("Purchase verification failed: $e");
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
      appLog("Restore purchases failed: $e");
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
}