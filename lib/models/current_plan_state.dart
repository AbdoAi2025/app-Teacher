import 'current_subscription_plan_model.dart';

sealed class CurrentPlanState {}

class CurrentPlanStateLoading extends CurrentPlanState {}

class CurrentPlanStateSuccess extends CurrentPlanState {
  final CurrentSubscriptionPlanModel subscriptionPlan;

  CurrentPlanStateSuccess(this.subscriptionPlan);
}

class CurrentPlanStateError extends CurrentPlanState {
  final String error;

  CurrentPlanStateError(this.error);
}