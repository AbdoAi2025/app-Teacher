import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/models/subscription_plan_model.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class SubscriptionRemoteDataSource {
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan() async {
    var response = await ApiService.getInstance().get(EndPoints.getCurrentSubscriptionPlan);
    CurrentSubscriptionPlanResponse responseResult = CurrentSubscriptionPlanResponse.fromJson(response.data);
    return responseResult;
  }

  Future<List<SubscriptionPlanModel>> getAllSubscriptionPlans() async {
    var response = await ApiService.getInstance().get(EndPoints.getAllSubscriptionPlans);
    List<dynamic> plansJson = response.data as List<dynamic>;
    List<SubscriptionPlanModel> plans = plansJson
        .map((json) => SubscriptionPlanModel.fromJson(json as Map<String, dynamic>))
        .toList();
    return plans;
  }
}