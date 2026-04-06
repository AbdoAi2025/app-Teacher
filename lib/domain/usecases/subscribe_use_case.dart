import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/models/subscribe_request.dart';
import 'package:teacher_app/models/subscribe_response.dart';

import '../base_use_case.dart';

class SubscribeUseCase extends BaseUseCase<SubscribeResponse?> {

  SubscriptionRepository repository = SubscriptionRepositoryImpl();

  Future<AppResult<SubscribeResponse?>> execute(SubscribeRequest request) async {
    return call(() async {
      var subscribeResponse = await repository.subscribe(request);
      return AppResult.success(subscribeResponse);
    });
  }
}