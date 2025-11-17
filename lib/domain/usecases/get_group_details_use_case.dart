import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';

import '../../data/responses/get_group_details_response.dart';

class GetGroupDetailsUseCase extends BaseUseCase<GetGroupDetailsResponse?>{

  var repository = GroupsRepository();

  Future<AppResult<GetGroupDetailsResponse?>> execute(String id) async {
    return call(() async {
      var items =  await repository.getGroupDetails(id);
      return AppResult.success(items);
    });
  }
}
