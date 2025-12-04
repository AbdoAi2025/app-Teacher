import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/domain/usecases/get_current_subscription_plan_use_case.dart';
import 'package:teacher_app/domain/usecases/get_subscription_plans_use_case.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plans_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class SubscriptionPlansController extends GetxController {
  GetSubscriptionPlansUseCase getSubscriptionPlansUseCase = GetSubscriptionPlansUseCase();
  GetCurrentSubscriptionPlanUseCase getCurrentSubscriptionPlanUseCase = GetCurrentSubscriptionPlanUseCase();

  Rx<SubscriptionPlansState> state = Rx(SubscriptionPlansStateLoading());

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    _updateState(SubscriptionPlansStateLoading());

    try {
      // Load plans and current subscription in parallel
      final results = await Future.wait([
        getSubscriptionPlansUseCase.execute(),
        getCurrentSubscriptionPlanUseCase.execute(),
      ]);

      final plansResult = results[0] as AppResult<List<SubscriptionPlanModel>>;
      final currentSubscriptionResult = results[1] as AppResult<CurrentSubscriptionPlanResponse>;

      appLog("SubscriptionPlansController loadAllData plansResult : $plansResult");

      if (plansResult.isSuccess) {
        appLog("SubscriptionPlansController loadAllData plansResult.data: ${plansResult.data}");

        var allPlans = plansResult.data
            ?.map((model) => SubscriptionPlanItemUiState.fromModel(model))
            .toList() ?? List.empty();

        appLog("SubscriptionPlansController all mapped plans: $allPlans");
        appLog("SubscriptionPlansController all mapped plans length: ${allPlans.length}");

        CurrentSubscriptionPlanResponse? currentSubscription;
        if (currentSubscriptionResult.isSuccess) {
          currentSubscription = currentSubscriptionResult.data;
          appLog("SubscriptionPlansController currentSubscription: $currentSubscription");
        }

        // Show all plans regardless of active status for now
        var plans = allPlans;

        // Sort plans to show current subscription first and update current plan with expiration date
        if (currentSubscription != null) {
          // Update the current plan with expiration date
          for (int i = 0; i < plans.length; i++) {
            if (plans[i].planCode == currentSubscription.planCode) {
              plans[i] = SubscriptionPlanItemUiState(
                planCode: plans[i].planCode,
                planName: plans[i].planName,
                description: plans[i].description,
                price: plans[i].price,
                durationInDays: plans[i].durationInDays,
                studentLimit: plans[i].studentLimit,
                isActive: plans[i].isActive,
                isPopular: plans[i].isPopular,
                expirationDate: currentSubscription.subscriptionExpireDate,
                descriptionAr: plans[i].descriptionAr,
                descriptionEn: plans[i].descriptionEn,
              );
              break;
            }
          }

          plans.sort((a, b) {
            bool aIsCurrent = a.planCode == currentSubscription!.planCode;
            bool bIsCurrent = b.planCode == currentSubscription.planCode;

            if (aIsCurrent && !bIsCurrent) return -1; // a comes first
            if (!aIsCurrent && bIsCurrent) return 1;  // b comes first
            return 0; // keep original order for non-current plans
          });
        }

        appLog("SubscriptionPlansController sorted plans: $plans");
        appLog("SubscriptionPlansController plans length: ${plans.length}");

        _updateState(SubscriptionPlansStateSuccess(
          plans: plans,
          currentSubscription: currentSubscription,
        ));
      } else {
        _updateState(SubscriptionPlansStateError(plansResult.error));
      }
    } catch (e) {
      _updateState(SubscriptionPlansStateError(Exception('Failed to load subscription data: $e')));
    }
  }

  Future<void> loadSubscriptionPlans() => loadAllData();

  void refreshSubscriptionPlans() {
    loadAllData();
  }

  void _updateState(SubscriptionPlansState newState) {
    state.value = newState;
  }

  String getSubscriptionEndDate() {
    final currentState = state.value;
    if (currentState is SubscriptionPlansStateSuccess &&
        currentState.currentSubscription?.subscriptionExpireDate != null) {
      return DateFormat('yyyy/MM/dd').format(currentState.currentSubscription!.subscriptionExpireDate!);
    }
    // Fallback mock date
    final endDate = DateTime.now().add(Duration(days: 25));
    return DateFormat('yyyy/MM/dd').format(endDate);
  }

  void renewCurrentSubscription() {
    final currentState = state.value;
    if (currentState is SubscriptionPlansStateSuccess &&
        currentState.currentSubscription != null) {
      Get.snackbar(
        'Renew Subscription'.tr,
        'Renewing ${currentState.currentSubscription!.planName}...',
        snackPosition: SnackPosition.BOTTOM,
      );
      // TODO: Implement actual renewal logic
    }
  }

  CurrentSubscriptionPlanResponse? get currentSubscription {
    final currentState = state.value;
    if (currentState is SubscriptionPlansStateSuccess) {
      return currentState.currentSubscription;
    }
    return null;
  }

  bool isCurrentPlan(SubscriptionPlanItemUiState plan) {
    final currentState = state.value;
    if (currentState is SubscriptionPlansStateSuccess &&
        currentState.currentSubscription != null) {
      return currentState.currentSubscription!.planCode == plan.planCode;
    }
    return false;
  }

  void onPlanSelected(SubscriptionPlanItemUiState plan) {
    // Handle plan selection - you can navigate to purchase screen or show details
    Get.snackbar(
      'Plan Selected'.tr,
      'You selected ${plan.planName}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to purchase/payment screen
  }
}