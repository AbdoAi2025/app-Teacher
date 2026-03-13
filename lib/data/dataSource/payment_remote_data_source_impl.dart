import 'package:dio/dio.dart';
import 'package:teacher_app/data/dataSource/payment_remote_data_source.dart';
import 'package:teacher_app/models/verify_payment_request.dart';
import 'package:teacher_app/models/verify_payment_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  @override
  Future<VerifyPaymentResponse?> verifyPayment(VerifyPaymentRequest request) async {

      appLog("PaymentRemoteDataSourceImpl: Verifying payment");
      appLog("PaymentRemoteDataSourceImpl: Request - ${request.toJson()}");

      Response response = await ApiService.getInstance().post(
        EndPoints.verifyPayment,
        data: request.toJson(),
      );

      appLog("PaymentRemoteDataSourceImpl: Response status - ${response.statusCode}");
      appLog("PaymentRemoteDataSourceImpl: Response data - ${response.data}");

      if (response.statusCode == 200) {
        final verifyResponse = VerifyPaymentResponse.fromJson(response.data);
        appLog("PaymentRemoteDataSourceImpl: Payment verification successful - ${verifyResponse.message}");
        return verifyResponse;
      } else {
        appLog("PaymentRemoteDataSourceImpl: Invalid response status - ${response.statusCode}");
        return null;
      }
  }
}