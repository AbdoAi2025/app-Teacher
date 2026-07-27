import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

export 'package:teacher_app/data/responses/enroll_request_data.dart';

class GetEnrollRequestsResponse {
  final EnrollRequestsPageData? data;

  GetEnrollRequestsResponse({this.data});

  factory GetEnrollRequestsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return GetEnrollRequestsResponse(
      data: dataJson is Map<String, dynamic>
          ? EnrollRequestsPageData.fromJson(dataJson)
          : null,
    );
  }
}

class EnrollRequestsPageData {
  final int? totalPages;
  final int? totalItems;
  final List<EnrollRequestData>? items;

  EnrollRequestsPageData({this.totalPages, this.totalItems, this.items});

  factory EnrollRequestsPageData.fromJson(Map<String, dynamic> json) {
    return EnrollRequestsPageData(
      totalPages: json.tryInt('totalPages'),
      totalItems: json.tryInt('totalItems'),
      items: json.tryList('items')
          ?.whereType<Map<String, dynamic>>()
          .map(EnrollRequestData.fromJson)
          .toList(),
    );
  }
}