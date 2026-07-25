import 'package:dio/dio.dart';
import 'package:teacher_app/data/responses/get_rejoin_request_students_response.dart';
import 'package:teacher_app/data/responses/get_rejoin_requests_response.dart';
import 'package:teacher_app/requests/create_rejoin_request_request.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class RejoinRequestsRepository {
  Future<RejoinRequestsPageData> getSentRejoinRequests({int page = 0, int size = 20}) async {
    Response response = await ApiService.getInstance().get(
      EndPoints.getSentRejoinRequests,
      queryParameters: {'page': page, 'size': size},
    );
    return GetRejoinRequestsResponse.fromJson(response.data).data
        ?? RejoinRequestsPageData();
  }

  Future<RejoinRequestData?> createRejoinRequest(CreateRejoinRequestRequest request) async {
    Response response = await ApiService.getInstance().post(
      EndPoints.createRejoinRequest,
      data: request.toJson(),
    );
    final dataJson = response.data?['data'];
    if (dataJson is Map<String, dynamic>) {
      return RejoinRequestData.fromJson(dataJson);
    }
    return null;
  }

  Future<RejoinRequestStudentsPageData> getStudents(
    int requestId, {
    int page = 0,
    int size = 20,
    String? gradeId,
    String? search,
  }) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (gradeId != null && gradeId.isNotEmpty) params['gradeId'] = gradeId;
    if (search != null && search.isNotEmpty) params['studentName'] = search;

    Response response = await ApiService.getInstance().get(
      EndPoints.rejoinRequestStudents(requestId),
      queryParameters: params,
    );
    return GetRejoinRequestStudentsResponse.fromJson(response.data).data
        ?? RejoinRequestStudentsPageData();
  }
}