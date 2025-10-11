import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../models/subscription_product_model.dart';
import '../../models/current_subscription_plan_model.dart';
import '../../models/current_plan_state.dart';
import '../../models/subscription_plan_model.dart';
import '../../services/in_app_purchase_service.dart';
import '../../utils/LogUtils.dart';
import '../../presentation/app_message_dialogs.dart';
import '../../domain/usecases/get_current_subscription_plan_use_case.dart';
import '../../domain/usecases/get_all_subscription_plans_use_case.dart';

class SubscriptionController extends GetxController {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  final GetCurrentSubscriptionPlanUseCase _getCurrentSubscriptionPlanUseCase = GetCurrentSubscriptionPlanUseCase();
  final GetAllSubscriptionPlansUseCase _getAllSubscriptionPlansUseCase = GetAllSubscriptionPlansUseCase();

  RxBool isLoading = true.obs;
  RxBool isPurchasing = false.obs;
  RxList<SubscriptionProductModel> availableProducts = <SubscriptionProductModel>[].obs;
  Rx<SubscriptionProductModel?> selectedProduct = Rx<SubscriptionProductModel?>(null);

  // Current subscription plan state
  Rx<CurrentPlanState> currentPlanState = Rx<CurrentPlanState>(CurrentPlanStateLoading());

  // Available subscription plans from backend
  RxBool isLoadingPlans = true.obs;
  RxList<SubscriptionPlanModel> availablePlans = <SubscriptionPlanModel>[].obs;
  RxString plansError = ''.obs;
  Rx<SubscriptionPlanModel?> selectedPlan = Rx<SubscriptionPlanModel?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializePurchaseService();
    await _loadCurrentSubscriptionPlan();
    await _loadAllSubscriptionPlans();
  }

  @override
  void onClose() {
    super.onClose();
    _purchaseService.dispose();

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

  Future<void> _loadCurrentSubscriptionPlan() async {
    try {
      currentPlanState.value = CurrentPlanStateLoading();
      appLog('Loading current subscription plan');

      final result = await _getCurrentSubscriptionPlanUseCase.execute();

      if (result.isSuccess) {
        currentPlanState.value = CurrentPlanStateSuccess(result.value!);
        appLog('Current subscription plan loaded successfully');
      } else {
        final errorMessage = result.error?.toString() ?? 'Failed to load subscription plan';
        currentPlanState.value = CurrentPlanStateError(errorMessage);
        appLog('Error loading current subscription plan: $errorMessage');
      }
    } catch (e) {
      final errorMessage = 'Unexpected error: ${e.toString()}';
      currentPlanState.value = CurrentPlanStateError(errorMessage);
      appLog('Exception loading current subscription plan: $errorMessage');
    }
  }

  Future<void> refreshCurrentSubscriptionPlan() async {
    await _loadCurrentSubscriptionPlan();
  }

  Future<void> _loadAllSubscriptionPlans() async {
    try {
      isLoadingPlans.value = true;
      plansError.value = '';
      appLog('Loading all subscription plans');

      final result = await _getAllSubscriptionPlansUseCase.execute();

      if (result.isSuccess) {
        availablePlans.value = result.value!;
        _initializeSelectedPlan();
        appLog('Loaded ${result.value!.length} subscription plans');
      } else {
        final errorMessage = result.error?.toString() ?? 'Failed to load subscription plans';
        plansError.value = errorMessage;
        appLog('Error loading subscription plans: $errorMessage');
      }
    } catch (e) {
      final errorMessage = 'Unexpected error: ${e.toString()}';
      plansError.value = errorMessage;
      appLog('Exception loading subscription plans: $errorMessage');
    } finally {
      isLoadingPlans.value = false;
    }
  }

  Future<void> refreshSubscriptionPlans() async {
    await _loadAllSubscriptionPlans();
  }

  void _initializeSelectedPlan() {
    if (availablePlans.isEmpty) return;

    // Try to select Premium plan first (recommended)
    final premiumPlan = availablePlans.firstWhere(
      (plan) => plan.isPremium,
      orElse: () => availablePlans.first,
    );

    selectedPlan.value = premiumPlan;
    appLog('Initialized selected plan: ${premiumPlan.planCode}');
  }

  void selectSubscriptionPlan(SubscriptionPlanModel plan) {
    selectedPlan.value = plan;
    appLog('Selected subscription plan: ${plan.planCode}');
  }

  void initializeSelectionWithCurrentPlan() {
    // Get current plan
    final currentPlan = currentPlanState.value;
    if (currentPlan is CurrentPlanStateSuccess) {
      final currentPlanCode = currentPlan.subscriptionPlan.planCode;

      // Find matching plan in available plans
      SubscriptionPlanModel? matchingPlan;

      // Try to find exact match first
      try {
        matchingPlan = availablePlans.firstWhere(
          (plan) => plan.planCode == currentPlanCode,
        );
      } catch (e) {
        // If no exact match, try Premium plan
        try {
          matchingPlan = availablePlans.firstWhere(
            (plan) => plan.isPremium,
          );
        } catch (e) {
          // If no Premium plan, use first available
          if (availablePlans.isNotEmpty) {
            matchingPlan = availablePlans.first;
          }
        }
      }

      if (matchingPlan != null) {
        selectedPlan.value = matchingPlan;
        appLog('Initialized selection with current plan: ${matchingPlan.planCode}');
      }
    } else {
      // Fallback to Premium plan if current plan not available
      _initializeSelectedPlan();
    }
  }

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