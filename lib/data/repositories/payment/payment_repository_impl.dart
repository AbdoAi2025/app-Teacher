import 'package:teacher_app/data/dataSource/payment_remote_data_source.dart';
import 'package:teacher_app/data/dataSource/payment_remote_data_source_impl.dart';
import 'package:teacher_app/data/repositories/payment/payment_repository.dart';
import 'package:teacher_app/domain/models/payment_method_model.dart';
import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource = PaymentRemoteDataSourceImpl();

  @override
  Future<VerifyPaymentResponse?> verifyPayment(VerifyPaymentRequest request) async {
    final response = await remoteDataSource.verifyPayment(request);
    return response;
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await remoteDataSource.getPaymentMethods();
    return response.paymentMethods ?? [];
  }
}