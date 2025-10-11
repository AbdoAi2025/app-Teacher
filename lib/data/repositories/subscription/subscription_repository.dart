import '../../../models/current_subscription_plan_model.dart';
import '../../../models/subscription_plan_model.dart';

abstract class SubscriptionRepository {
  Future<CurrentSubscriptionPlanModel?> getCurrentSubscriptionPlan();
  Future<List<SubscriptionPlanModel>?> getAllSubscriptionPlans();
}