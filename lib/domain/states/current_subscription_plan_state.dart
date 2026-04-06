import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';

/// Sealed class representing different states of subscription plan data
sealed class CurrentSubscriptionPlanState {}

/// Initial state before any data is loaded
class CurrentSubscriptionPlanInitial extends CurrentSubscriptionPlanState {}

/// Loading state while fetching subscription plan data
class CurrentSubscriptionPlanLoading extends CurrentSubscriptionPlanState {}

/// Success state with subscription plan data
class CurrentSubscriptionPlanSuccess extends CurrentSubscriptionPlanState {
  final CurrentSubscriptionPlanResponse data;

  CurrentSubscriptionPlanSuccess(this.data);
}

/// Error state when subscription plan fetch fails
class CurrentSubscriptionPlanError extends CurrentSubscriptionPlanState {
  final String message;

  CurrentSubscriptionPlanError(this.message);
}