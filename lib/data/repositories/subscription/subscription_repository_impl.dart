import 'package:teacher_app/data/dataSource/subscription_remote_data_source.dart';
import 'package:teacher_app/data/dataSource/subscription_remote_data_source_impl.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource = SubscriptionRemoteDataSourceImpl();

  @override
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    final response = await remoteDataSource.getSubscriptionPlans();
    return response.data ?? [];
  }

  @override
  Future<CurrentSubscriptionPlanResponse> getCurrentSubscriptionPlan() async {
    final response = await remoteDataSource.getCurrentSubscriptionPlan();
    return response;
  }
}