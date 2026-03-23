import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/models/initiate_subscription_request.dart';
import 'package:teacher_app/models/initiate_subscription_response.dart';
import 'package:teacher_app/models/subscribe_request.dart';
import 'package:teacher_app/models/subscribe_response.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan();
  Future<InitiateSubscriptionResponse?> initiateSubscriptionProcess(InitiateSubscriptionRequest request);
  Future<SubscribeResponse?> subscribe(SubscribeRequest request);
}