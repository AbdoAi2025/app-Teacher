import 'package:dio/dio.dart';
import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/data/responses/update_enroll_request_status_response.dart';
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

  Future<EnrollRequestsPageData> getReceivedRequests({
    int page = 0,
    int size = 20,
    String? status,
    int? gradeId,
  }) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (status != null) params['status'] = status;
    if (gradeId != null) params['gradeId'] = gradeId;
    Response response = await ApiService.getInstance().get(
      EndPoints.getReceivedRequests,
      queryParameters: params,
    );
    return GetEnrollRequestsResponse.fromJson(response.data).data
        ?? EnrollRequestsPageData();
  }

  Future<EnrollRequestData> updateRequestStatus(int id, String status) async {
    Response response = await ApiService.getInstance().put(
      EndPoints.updateEnrollRequestStatus(id),
      data: {'status': status},
    );
    return UpdateEnrollRequestStatusResponse.fromJson(response.data).data
        ?? EnrollRequestData();
  }
}