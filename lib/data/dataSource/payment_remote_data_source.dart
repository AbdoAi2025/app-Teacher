import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';
import 'package:teacher_app/data/responses/get_payment_methods_response.dart';

abstract class PaymentRemoteDataSource {
  Future<VerifyPaymentResponse?> verifyPayment(VerifyPaymentRequest request);
  Future<GetPaymentMethodsResponse> getPaymentMethods();
}