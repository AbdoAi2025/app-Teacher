import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';

import '../../data/responses/get_group_details_response.dart';

class GetGroupDetailsUseCase {

  var repository = GroupsRepository();

  Future<AppResult<GetGroupDetailsResponse?>> execute(String id) async {
    try{
       var items =  await repository.getGroupDetails(id);
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
