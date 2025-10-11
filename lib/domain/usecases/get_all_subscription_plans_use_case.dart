import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/models/subscription_plan_model.dart';
import '../base_use_case.dart';

class GetAllSubscriptionPlansUseCase extends BaseUseCase<List<SubscriptionPlanModel>> {
  SubscriptionRepository subscriptionRepository = SubscriptionRepositoryImpl();

  Future<AppResult<List<SubscriptionPlanModel>>> execute() {
    return call(() async {
      var plans = await subscriptionRepository.getAllSubscriptionPlans();
      if (plans != null) {
        return AppResult.success(plans);
      } else {
        return AppResult.error(Exception('Failed to load subscription plans'));
      }
    });
  }
}