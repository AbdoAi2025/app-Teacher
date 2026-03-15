import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';
import 'package:teacher_app/domain/models/payment_method_model.dart';

abstract class PaymentRepository {
  Future<VerifyPaymentResponse?> verifyPayment(VerifyPaymentRequest request);
  Future<List<PaymentMethodModel>> getPaymentMethods();
}