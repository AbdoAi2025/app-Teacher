import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository.dart';
import 'package:teacher_app/data/repositories/subscription/subscription_repository_impl.dart';
import 'package:teacher_app/models/verify_purchase_request.dart';
import 'package:teacher_app/models/verify_purchase_response.dart';

import '../base_use_case.dart';

class VerifyGooglePlayPurchaseUseCase extends BaseUseCase<VerifyPurchaseResponse?> {

  SubscriptionRepository repository = SubscriptionRepositoryImpl();

  Future<AppResult<VerifyPurchaseResponse?>> execute(VerifyPurchaseRequest request) async {
    return call(() async {
      var verifyResponse = await repository.verifyGooglePlayPurchase(request);
      return AppResult.success(verifyResponse);
    });
  }
}