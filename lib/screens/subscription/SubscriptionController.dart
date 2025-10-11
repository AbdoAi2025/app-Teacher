import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../models/subscription_product_model.dart';
import '../../services/in_app_purchase_service.dart';
import '../../utils/LogUtils.dart';
import '../../presentation/app_message_dialogs.dart';

class SubscriptionController extends GetxController {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();

  RxBool isLoading = true.obs;
  RxBool isPurchasing = false.obs;
  RxList<SubscriptionProductModel> availableProducts = <SubscriptionProductModel>[].obs;
  Rx<SubscriptionProductModel?> selectedProduct = Rx<SubscriptionProductModel?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializePurchaseService();
  }

  @override
  void onClose() {
    _purchaseService.dispose();
    super.onClose();
  }

  Future<void> _initializePurchaseService() async {
    try {
      isLoading.value = true;
      appLog('Initializing subscription controller');

      await _purchaseService.initialize();

      if (!_purchaseService.isAvailable) {
        appLog('In-App Purchase not available');
        _showErrorDialog('In-App Purchase not available on this device');
        return;
      }

      _loadAvailableProducts();
    } catch (e) {
      appLog('Error initializing purchase service: $e');
      _showErrorDialog('Failed to initialize subscription service');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadAvailableProducts() {
    appLog('Loading available subscription products');

    final products = <SubscriptionProductModel>[];

    final monthlyProductDetails = _purchaseService.getMonthlySubscription();
    if (monthlyProductDetails != null) {
      products.add(SubscriptionProductModel.monthly(productDetails: monthlyProductDetails));
    } else {
      products.add(SubscriptionProductModel.monthly());
    }

    final yearlyProductDetails = _purchaseService.getYearlySubscription();
    if (yearlyProductDetails != null) {
      products.add(SubscriptionProductModel.yearly(productDetails: yearlyProductDetails));
    } else {
      products.add(SubscriptionProductModel.yearly());
    }

    availableProducts.value = products;

    if (products.isNotEmpty) {
      selectedProduct.value = products.firstWhere(
        (product) => product.isRecommended,
        orElse: () => products.first,
      );
    }

    appLog('Loaded ${products.length} subscription products');
  }

  void selectProduct(SubscriptionProductModel product) {
    selectedProduct.value = product;
    appLog('Selected product: ${product.id}');
  }

  Future<void> purchaseSelectedProduct() async {
    if (selectedProduct.value == null) {
      _showErrorDialog('Please select a subscription plan');
      return;
    }

    final product = selectedProduct.value!;

    if (product.productDetails == null) {
      _showErrorDialog('Product not available for purchase');
      return;
    }

    try {
      isPurchasing.value = true;
      appLog('Starting purchase for product: ${product.id}');

      final success = await _purchaseService.buyProduct(product.productDetails!);

      if (success) {
        appLog('Purchase initiated successfully');
      } else {
        appLog('Failed to initiate purchase');
        _showErrorDialog('Failed to start purchase. Please try again.');
      }
    } catch (e) {
      appLog('Error during purchase: $e');
      _showErrorDialog('Purchase failed. Please try again.');
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      appLog('Restoring purchases');

      await _purchaseService.restorePurchases();

      if (_purchaseService.hasActiveSubscription()) {
        _showSuccessDialog('Subscription restored successfully!');
        Get.back();
      } else {
        _showErrorDialog('No active subscription found to restore');
      }
    } catch (e) {
      appLog('Error restoring purchases: $e');
      _showErrorDialog('Failed to restore purchases. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasActiveSubscription => _purchaseService.hasActiveSubscription();

  void _showErrorDialog(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showSuccessDialog(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToSubscriptionTerms() {
    appLog('Navigate to subscription terms');
  }

  void goToPrivacyPolicy() {
    appLog('Navigate to privacy policy');
  }
}