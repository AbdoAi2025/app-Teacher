import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/data/responses/get_subscription_plans_response.dart';
import 'package:teacher_app/models/verify_purchase_request.dart';
import 'package:teacher_app/models/verify_purchase_response.dart';

abstract class SubscriptionRemoteDataSource {
  Future<GetSubscriptionPlansResponse> getSubscriptionPlans();
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan();
  Future<VerifyPurchaseResponse?> verifyGooglePlayPurchase(VerifyPurchaseRequest request);
}