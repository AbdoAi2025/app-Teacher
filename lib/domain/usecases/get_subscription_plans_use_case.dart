import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/domain/models/subscription_plan_model.dart';

import '../base_use_case.dart';

class GetSubscriptionPlansUseCase extends BaseUseCase<List<SubscriptionPlanModel>> {

  SubscriptionRepository repository = SubscriptionRepositoryImpl();

  Future<AppResult<List<SubscriptionPlanModel>>> execute() async {
    return call(() async {
      var items = await repository.getSubscriptionPlans();
      return AppResult.success(items);
    });
  }
}