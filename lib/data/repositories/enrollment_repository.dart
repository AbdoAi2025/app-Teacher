import 'package:dio/dio.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class EnrollmentRepository {
  Future<EnrollRequestsPageData> getSentRequests({int page = 0, int size = 20}) async {
    Response response = await ApiService.getInstance().get(
      EndPoints.getSentRequests,
      queryParameters: {'page': page, 'size': size},
    );
    return GetEnrollRequestsResponse.fromJson(response.data).data
        ?? EnrollRequestsPageData();
  }

  Future<EnrollRequestsPageData> getReceivedRequests({int page = 0, int size = 20}) async {
    Response response = await ApiService.getInstance().get(
      EndPoints.getReceivedRequests,
      queryParameters: {'page': page, 'size': size},
    );
    return GetEnrollRequestsResponse.fromJson(response.data).data
        ?? EnrollRequestsPageData();
  }
}