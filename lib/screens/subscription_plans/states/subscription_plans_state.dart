import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/screens/subscription_plans/states/subscription_plan_item_ui_state.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';

sealed class SubscriptionPlansState {}

class SubscriptionPlansStateLoading extends SubscriptionPlansState {}

class SubscriptionPlansStateSuccess extends SubscriptionPlansState {
  final List<SubscriptionPlanItemUiState> plans;
  final List<SubscriptionPlanModel> planModels;
  final CurrentSubscriptionPlanResponse? currentSubscription;

  SubscriptionPlansStateSuccess({
    required this.plans,
    required this.planModels,
    this.currentSubscription,
  });

  SubscriptionPlansStateSuccess copyWith({
    List<SubscriptionPlanItemUiState>? plans,
    List<SubscriptionPlanModel>? planModels,
    CurrentSubscriptionPlanResponse? currentSubscription,
  }) {
    return SubscriptionPlansStateSuccess(
      plans: plans ?? this.plans,
      planModels: planModels ?? this.planModels,
      currentSubscription: currentSubscription ?? this.currentSubscription,
    );
  }
}

class SubscriptionPlansStateError extends SubscriptionPlansState {
  final Exception? error;

  SubscriptionPlansStateError(this.error);
}