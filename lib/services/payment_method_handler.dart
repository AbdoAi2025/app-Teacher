import 'package:teacher_app/domain/models/payment_method_model.dart';
import 'package:teacher_app/domain/usecases/get_payment_methods_use_case.dart';
import 'package:teacher_app/base/AppResult.dart';

class PaymentMethodHandler {
  static PaymentMethodHandler? _instance;
  List<PaymentMethodModel>? _cachedPaymentMethods;
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase = GetPaymentMethodsUseCase();

  PaymentMethodHandler._();

  static PaymentMethodHandler getInstance() {
    _instance ??= PaymentMethodHandler._();
    return _instance!;
  }

  Future<List<PaymentMethodModel>> getAvailablePaymentMethods() async {
    if (_cachedPaymentMethods != null) {
      return _cachedPaymentMethods!;
    }

    try {
      final result = await _getPaymentMethodsUseCase.execute();
      if (result.isSuccess) {
        _cachedPaymentMethods = result.data ?? [];
        return _cachedPaymentMethods!;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<PaymentMethodModel> getEnabledPaymentMethods() {
    return _cachedPaymentMethods
            ?.where((method) => method.enabled == true)
            .toList() ??
        [];
  }

  void clearCache() {
    _cachedPaymentMethods = null;
  }

  Future<void> refreshPaymentMethods() async {
    clearCache();
    await getAvailablePaymentMethods();
  }
}