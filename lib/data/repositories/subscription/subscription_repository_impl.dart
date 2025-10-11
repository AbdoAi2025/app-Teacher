import 'package:teacher_app/data/dataSource/subscription_remote_data_source.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/models/current_subscription_plan_model.dart';
import 'package:teacher_app/models/subscription_plan_model.dart';

class SubscriptionRepositoryImpl extends SubscriptionRepository {
  SubscriptionRemoteDataSource remoteDataSource = SubscriptionRemoteDataSource();

  @override
  Future<CurrentSubscriptionPlanModel?> getCurrentSubscriptionPlan() async {
    try {
      var response = await remoteDataSource.getCurrentSubscriptionPlan();
      return response.toModel();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<SubscriptionPlanModel>?> getAllSubscriptionPlans() async {
    try {
      var plans = await remoteDataSource.getAllSubscriptionPlans();
      return plans;
    } catch (e) {
      return null;
    }
  }
}