import 'package:dio/dio.dart';
import 'package:teacher_app/data/dataSource/subscription_remote_data_source.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/data/responses/get_subscription_plans_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  @override
  Future<GetSubscriptionPlansResponse> getSubscriptionPlans() async {
    Response response = await ApiService.getInstance().get(EndPoints.getSubscriptionPlans);
    GetSubscriptionPlansResponse responseResult = GetSubscriptionPlansResponse.fromJson(response.data);
    return responseResult;
  }

  @override
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan() async {
    Response response = await ApiService.getInstance().get(EndPoints.getCurrentSubscriptionPlan);
    CurrentSubscriptionPlanResponse responseResult = CurrentSubscriptionPlanResponse.fromJson(response.data);
    return responseResult;
  }
}