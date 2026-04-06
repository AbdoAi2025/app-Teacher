import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../base_use_case.dart';

class GetCurrentSubscriptionPlanUseCase extends BaseUseCase<CurrentSubscriptionPlanResponse> {

  SubscriptionRepository repository = SubscriptionRepositoryImpl();

  Future<AppResult<CurrentSubscriptionPlanResponse>> execute() async {
    return call(() async {
      var response = await repository.getCurrentSubscriptionPlan();
      appLog("GetCurrentSubscriptionPlanUseCase execute:${response.toJson()}");
      return AppResult.success(response);
    });
  }
}