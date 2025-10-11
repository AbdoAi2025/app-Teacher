import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/models/current_subscription_plan_model.dart';
import '../base_use_case.dart';

class GetCurrentSubscriptionPlanUseCase extends BaseUseCase<CurrentSubscriptionPlanModel> {
  SubscriptionRepository subscriptionRepository = SubscriptionRepositoryImpl();

  Future<AppResult<CurrentSubscriptionPlanModel>> execute() {
    return call(() async {
      var model = await subscriptionRepository.getCurrentSubscriptionPlan();
      if (model != null) {
        return AppResult.success(model);
      } else {
        return AppResult.error(Exception('No subscription plan found'));
      }
    });
  }
}