import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/payment/payment_repository.dart';
import 'package:teacher_app/data/repositories/payment/payment_repository_impl.dart';
import 'package:teacher_app/domain/models/payment_method_model.dart';

import '../base_use_case.dart';

class GetPaymentMethodsUseCase extends BaseUseCase<List<PaymentMethodModel>> {

  PaymentRepository repository = PaymentRepositoryImpl();

  Future<AppResult<List<PaymentMethodModel>>> execute() async {
    return call(() async {
      var items = await repository.getPaymentMethods();
      return AppResult.success(items);
    });
  }
}