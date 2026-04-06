import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/payment/payment_repository.dart';
import 'package:teacher_app/data/repositories/payment/payment_repository_impl.dart';
import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';

import '../base_use_case.dart';

class VerifyPaymentUseCase extends BaseUseCase<VerifyPaymentResponse?> {

  PaymentRepository repository = PaymentRepositoryImpl();

  Future<AppResult<VerifyPaymentResponse?>> execute(VerifyPaymentRequest request) async {
    return call(() async {
      var verifyResponse = await repository.verifyPayment(request);
      return AppResult.success(verifyResponse);
    });
  }
}