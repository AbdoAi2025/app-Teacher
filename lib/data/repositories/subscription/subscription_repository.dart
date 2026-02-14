import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';
import 'package:teacher_app/models/verify_purchase_request.dart';
import 'package:teacher_app/models/verify_purchase_response.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan();
  Future<VerifyPurchaseResponse?> verifyGooglePlayPurchase(VerifyPurchaseRequest request);
}