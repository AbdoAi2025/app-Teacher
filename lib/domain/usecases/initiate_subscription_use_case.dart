import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/models/initiate_subscription_request.dart';
import 'package:teacher_app/models/initiate_subscription_response.dart';
import 'package:teacher_app/models/initial_subscription_model.dart';

import '../../enums/payment_provider_type.dart';
import '../base_use_case.dart';

class InitiateSubscriptionUseCase extends BaseUseCase<InitialSubscriptionModel> {

  SubscriptionRepository repository = SubscriptionRepositoryImpl();

  Future<AppResult<InitialSubscriptionModel>> execute(InitiateSubscriptionRequest request) async {
    return call(() async {
      var response = await repository.initiateSubscriptionProcess(request);
      if (response != null && response.data != null) {
        final initialSubscription = InitialSubscriptionModel(
          paymentKey: response.data?.paymentKey ?? "",
          orderId: response.data?.orderId ?? "",
          paymentProviderType: response.data?.paymentProviderType ?? PaymentProviderType.PAYMOB,
          merchantOrderId: response.data?.merchantOrderId ?? "",
        );
        return AppResult.success(initialSubscription);
      } else {
        return AppResult.error(Exception('Failed to initiate subscription process'));
      }
    });
  }
}