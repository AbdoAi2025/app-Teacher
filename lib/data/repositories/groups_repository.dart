import 'package:dio/dio.dart';
import 'package:teacher_app/models/group_item_model.dart';
import 'package:teacher_app/requests/add_group_request.dart';
import 'package:teacher_app/requests/update_group_request.dart';
import 'package:teacher_app/requests/upgrade_group_request.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

import '../../models/grade_model.dart';
import '../responses/add_group_response.dart';
import '../responses/get_group_details_response.dart';
import '../responses/get_my_groups_response.dart';

class GroupsRepository {
  Future<AddGroupResponse?> addGroup(AddGroupRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.addGroup, data: request.toJson());
    AddGroupResponse responseResult = AddGroupResponse.fromJson(response.data);
    return responseResult;
  }

  Future<AddGroupResponse?> updateGroup(UpdateGroupRequest request) async {
    Response response = await ApiService.getInstance()
        .put(EndPoints.updateGroup, data: request.toJson());
    AddGroupResponse responseResult = AddGroupResponse.fromJson(response.data);
    return responseResult;
  }

  Future<AddGroupResponse?> upgradeGroup(UpgradeGroupRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.upgradeGroup, data: request.toJson());
    AddGroupResponse responseResult = AddGroupResponse.fromJson(response.data);
    return responseResult;
  }

  Future<GetGroupDetailsResponse?> getGroupDetails(String id, {DateTime? dateFrom, DateTime? dateTo}) async {
    Map<String, dynamic> queryParameters = {};

    if (dateFrom != null) {
      queryParameters['dateFrom'] = dateFrom.toIso8601String();
    }

    if (dateTo != null) {
      queryParameters['dateTo'] = dateTo.toIso8601String();
    }

    Response response = await ApiService.getInstance().get(
      "${EndPoints.getGroupDetails}/$id",
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null
    );
    GetGroupDetailsResponse responseResult =
        GetGroupDetailsResponse.fromJson(response.data);
    return responseResult;
  }

  Future<dynamic> deleteGroup(String id) async {
    return await ApiService.getInstance()
        .delete("${EndPoints.deleteGroup}/$id");
    ;
  }

  Future<List<GroupItemModel>> fetchGroups({String? dateFrom, String? dateTo}) async {
    Map<String, dynamic> queryParameters = {};

    if (dateFrom != null) {
      queryParameters['dateFrom'] = dateFrom;
    }

    if (dateTo != null) {
      queryParameters['dateTo'] = dateTo;
    }

    Response response = await ApiService.getInstance().get(
      EndPoints.getMyGroups,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null
    );
    GetMyGroupsResponse responseResult =
        GetMyGroupsResponse.fromJson(response.data);
    return responseResult.data
            ?.map((e) => GroupItemModel(
                id: e.groupId ?? "",
                name: e.groupName ?? "",
                day: e.groupDay ?? 0,
                studentCount: e.studentCount ?? 0,
                timeFrom: e.timeFrom ?? "",
                timeTo: e.timeTo ?? "",
                grade: GradeModel(
                  id: e.gradeId,
                  nameEn: e.gradeNameEn ?? "",
                  nameAr: e.gradeNameAr ?? "",
                ),
                studentsIds: []))
            .toList() ??
        List.empty();
  }
}
