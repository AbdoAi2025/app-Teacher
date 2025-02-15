import 'package:dio/dio.dart';
import 'package:teacher_app/models/group.dart';
import 'package:teacher_app/responses/get_my_groups_response.dart';
import 'package:teacher_app/services/api_service.dart';

class GroupsRepository {
  Future<List<Group>> fetchGroups() async {
    try {
      Response response = await ApiService.dio.get('/api/v1/groups/myGroups');

      GetMyGroupsResponse responseResult =
          GetMyGroupsResponse.fromJson(response.data);

      return responseResult.data
              ?.map((e) => Group(
                  id: e.groupId ?? "",
                  name: e.groupName ?? "",
                  day: e.groupDay ?? 0,
                  studentCount: e.studentCount ?? 0,
                  timeFrom: '',
                  timeTo: ''
      )).toList() ??
          List.empty();
    } catch (e) {
      throw Exception("❌ فشل في جلب بيانات المجموعات");
    }
  }
}
