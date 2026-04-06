import 'package:dio/dio.dart';
import 'package:teacher_app/data/dataSource/subscription_remote_data_source.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/data/responses/get_subscription_plans_response.dart';
import 'package:teacher_app/models/initiate_subscription_request.dart';
import 'package:teacher_app/models/initiate_subscription_response.dart';
import 'package:teacher_app/models/subscribe_request.dart';
import 'package:teacher_app/models/subscribe_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';
import 'package:teacher_app/utils/LogUtils.dart';

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

  @override
  Future<InitiateSubscriptionResponse?> initiateSubscriptionProcess(InitiateSubscriptionRequest request) async {
    try {
      appLog("SubscriptionRemoteDataSourceImpl: Initiating subscription process");
      appLog("SubscriptionRemoteDataSourceImpl: Request - ${request.toJson()}");

      Response response = await ApiService.getInstance().post(
        EndPoints.initiateSubscription,
        data: request.toJson(),
      );

      appLog("SubscriptionRemoteDataSourceImpl: Response status - ${response.statusCode}");
      appLog("SubscriptionRemoteDataSourceImpl: Response data - ${response.data}");

      if (response.statusCode == 200) {
        final initiateResponse = InitiateSubscriptionResponse.fromJson(response.data);
        appLog("SubscriptionRemoteDataSourceImpl: Subscription initiation successful - ${initiateResponse.message}");
        return initiateResponse;
      } else {
        appLog("SubscriptionRemoteDataSourceImpl: Invalid response status - ${response.statusCode}");
        return null;
      }
    } catch (e) {
      appLog("SubscriptionRemoteDataSourceImpl: Error initiating subscription - $e");
      return null;
    }
  }

  @override
  Future<SubscribeResponse?> subscribe(SubscribeRequest request) async {
    try {
      appLog("SubscriptionRemoteDataSourceImpl: Subscribing");
      appLog("SubscriptionRemoteDataSourceImpl: Request - ${request.toJson()}");

      Response response = await ApiService.getInstance().post(
        EndPoints.subscribe,
        data: request.toJson(),
      );

      appLog("SubscriptionRemoteDataSourceImpl: Response status - ${response.statusCode}");
      appLog("SubscriptionRemoteDataSourceImpl: Response data - ${response.data}");

      if (response.statusCode == 200) {
        final subscribeResponse = SubscribeResponse.fromJson(response.data);
        appLog("SubscriptionRemoteDataSourceImpl: Subscription successful - ${subscribeResponse.message}");
        return subscribeResponse;
      } else {
        appLog("SubscriptionRemoteDataSourceImpl: Invalid response status - ${response.statusCode}");
        return null;
      }
    } catch (e) {
      appLog("SubscriptionRemoteDataSourceImpl: Error subscribing - $e");
      return null;
    }
  }
}