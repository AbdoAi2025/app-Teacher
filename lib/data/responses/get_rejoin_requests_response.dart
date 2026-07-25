import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetRejoinRequestsResponse {
  final RejoinRequestsPageData? data;

  GetRejoinRequestsResponse({this.data});

  factory GetRejoinRequestsResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return GetRejoinRequestsResponse(
      data: dataJson is Map<String, dynamic>
          ? RejoinRequestsPageData.fromJson(dataJson)
          : null,
    );
  }
}

class RejoinRequestsPageData {
  final int? totalPages;
  final int? totalItems;
  final List<RejoinRequestData>? items;

  RejoinRequestsPageData({this.totalPages, this.totalItems, this.items});

  factory RejoinRequestsPageData.fromJson(Map<String, dynamic> json) {
    return RejoinRequestsPageData(
      totalPages: json.tryInt('totalPages'),
      totalItems: json.tryInt('totalItems'),
      items: json.tryList('items')
          ?.whereType<Map<String, dynamic>>()
          .map(RejoinRequestData.fromJson)
          .toList(),
    );
  }
}

class RejoinRequestData {
  final int? id;
  final String? fromUserId;
  final String? fromUserName;
  final String? toUserId;
  final String? toUserName;
  final String? name;
  final DateTime? date;
  final String? status;
  final DateTime? createdAt;

  RejoinRequestData({
    this.id,
    this.fromUserId,
    this.fromUserName,
    this.toUserId,
    this.toUserName,
    this.name,
    this.date,
    this.status,
    this.createdAt,
  });

  String get createdDateFormat {
    final d = date ?? createdAt;
    return d != null
        ? DateFormat('dd MMM yyyy', Get.locale?.languageCode).format(d)
        : '';
  }

  String get localizedStatus => status?.tr ?? '';

  factory RejoinRequestData.fromJson(Map<String, dynamic> json) {
    return RejoinRequestData(
      id: json.tryInt('id'),
      fromUserId: json.tryString('fromUserId'),
      fromUserName: json.tryString('fromUserName'),
      toUserId: json.tryString('toUserId'),
      toUserName: json.tryString('toUserName'),
      name: json.tryString('name'),
      date: json.tryString('date') != null
          ? DateTime.tryParse(json.tryString('date')!)
          : null,
      status: json.tryString('status'),
      createdAt: json.tryString('createdAt') != null
          ? DateTime.tryParse(json.tryString('createdAt')!)
          : null,
    );
  }
}