import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/domain/usecases/get_current_subscription_plan_use_case.dart';
import 'package:teacher_app/domain/usecases/get_subscription_plans_use_case.dart';
import 'package:teacher_app/domain/usecases/initiate_subscription_use_case.dart';
import 'package:teacher_app/domain/usecases/verify_payment_use_case.dart';
import 'package:teacher_app/enums/billing_period.dart';
import 'package:teacher_app/enums/payment_provider_type.dart';
import 'package:teacher_app/models/initiate_subscription_request.dart';
import 'package:teacher_app/models/subscribe_request.dart';
import 'package:teacher_app/models/subscribe_response.dart';
import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plans_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../domain/usecases/subscribe_use_case.dart';
import '../../models/initial_subscription_model.dart';
import '../../models/verify_payment_response.dart';

class SubscriptionPlansController extends GetxController {
  GetSubscriptionPlansUseCase getSubscriptionPlansUseCase =
      GetSubscriptionPlansUseCase();
  GetCurrentSubscriptionPlanUseCase getCurrentSubscriptionPlanUseCase =
      GetCurrentSubscriptionPlanUseCase();
  InitiateSubscriptionUseCase initiateSubscriptionUseCase =
      InitiateSubscriptionUseCase();
  VerifyPaymentUseCase verifyPaymentUseCase = VerifyPaymentUseCase();

  SubscribeUseCase subscribeUseCase = SubscribeUseCase();

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
      final currentSubscriptionResult =
          results[1] as AppResult<CurrentSubscriptionPlanResponse>;

      appLog(
          "SubscriptionPlansController loadAllData plansResult : $plansResult");

      if (plansResult.isSuccess) {
        var planModels = plansResult.data ?? <SubscriptionPlanModel>[];
        var allPlans = planModels
            .map((model) => SubscriptionPlanItemUiState.fromModel(model, false))
            .toList();
        CurrentSubscriptionPlanResponse? currentSubscription;

        if (currentSubscriptionResult.isSuccess) {
          currentSubscription = currentSubscriptionResult.data;
          appLog(
              "SubscriptionPlansController currentSubscription: $currentSubscription");
        }

        // Sort plans to show current subscription first and update current plan with expiration date
        if (currentSubscription != null) {
          // Update the current plan with expiration date
          for (int i = 0; i < allPlans.length; i++) {
            var planItemUiModel = allPlans[i];

            if (planItemUiModel.planCode == currentSubscription.planCode) {
              allPlans[i] = SubscriptionPlanItemUiState(
                planCode: planItemUiModel.planCode,
                planName: planItemUiModel.planName,
                description: planItemUiModel.description,
                monthlyPrice: planItemUiModel.monthlyPrice,
                yearlyPrice: planItemUiModel.yearlyPrice,
                durationInDays: planItemUiModel.durationInDays,
                studentLimit: planItemUiModel.studentLimit,
                isActive: true,
                isPopular: planItemUiModel.isPopular,
                expirationDate: currentSubscription.subscriptionExpireDate,
                //DateTime.tryParse('2026-02-10T18:26:39.000+00:00'.toString())
                descriptionAr: planItemUiModel.descriptionAr,
                descriptionEn: planItemUiModel.descriptionEn,
                isCurrentPlan: true,
                purchaseCode: planItemUiModel.purchaseCode,
              );
              break;
            }
          }

          allPlans.sort((a, b) {
            bool aIsCurrent = a.planCode == currentSubscription!.planCode;
            bool bIsCurrent = b.planCode == currentSubscription.planCode;

            if (aIsCurrent && !bIsCurrent) return -1; // a comes first
            if (!aIsCurrent && bIsCurrent) return 1; // b comes first
            return 0; // keep original order for non-current plans
          });
        }

        appLog("SubscriptionPlansController sorted plans: $allPlans");
        appLog("SubscriptionPlansController plans length: ${allPlans.length}");

        _updateState(SubscriptionPlansStateSuccess(
          plans: allPlans,
          totalStudentCount: currentSubscription?.totalStudentCount ?? 0,
          currentSubscription: currentSubscription,
        ));
      } else {
        _updateState(SubscriptionPlansStateError(plansResult.error));
      }
    } catch (e) {
      _updateState(SubscriptionPlansStateError(
          Exception('Failed to load subscription data: $e')));
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
      return DateFormat('yyyy/MM/dd')
          .format(currentState.currentSubscription!.subscriptionExpireDate!);
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

  Future<AppResult<InitialSubscriptionModel>> initiateSubscriptionProcess(
      SubscriptionPlanItemUiState plan, bool isMonthly) async {
    var request = InitiateSubscriptionRequest(
        subscriptionPlanCode: plan.planCode,
        billingPeriod: isMonthly ? BillingPeriod.MONTHLY : BillingPeriod.YEARLY,
        paymentProviderType: PaymentProviderType.PAYMOB);
    return await initiateSubscriptionUseCase.execute(request);
  }

  Future<AppResult<VerifyPaymentResponse?>> verifyPayment(
      String orderId, String merchantOrderId) async {
    var request = VerifyPaymentRequest(
        orderId: orderId, merchantOrderId: merchantOrderId);
    return await verifyPaymentUseCase.execute(request);
  }

  Future<AppResult<SubscribeResponse?>> subscribe(
      SubscriptionPlanItemUiState plan, bool isMonthly) async {
    var request = SubscribeRequest(
      subscriptionPlanCode: plan.planCode,
      billingPeriod: BillingPeriod.MONTHLY,
    );
    return await subscribeUseCase.execute(request);
  }
}
