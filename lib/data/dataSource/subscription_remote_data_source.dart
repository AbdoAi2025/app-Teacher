import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/data/responses/get_subscription_plans_response.dart';

abstract class SubscriptionRemoteDataSource {
  Future<GetSubscriptionPlansResponse> getSubscriptionPlans();
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan();
}