import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class UpdateEnrollRequestStatusResponse {
  final String? status;
  final EnrollRequestData? data;
  final String? message;

  UpdateEnrollRequestStatusResponse({this.status, this.data, this.message});

  factory UpdateEnrollRequestStatusResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return UpdateEnrollRequestStatusResponse(
      status: json.tryString('status'),
      data: dataJson is Map<String, dynamic>
          ? EnrollRequestData.fromJson(dataJson)
          : null,
      message: json.tryString('message'),
    );
  }
}