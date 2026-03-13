import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';

abstract class PaymentRepository {
  Future<VerifyPaymentResponse?> verifyPayment(VerifyPaymentRequest request);
}