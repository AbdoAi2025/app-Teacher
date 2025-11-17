import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';

import '../base_use_case.dart';

class GetMyStudentsListUseCase extends BaseUseCase<List<StudentListItemApiModel>>{

  final StudentsRepository _repository = StudentsRepository();

  Future<AppResult<List<StudentListItemApiModel>>> execute(GetMyStudentsRequest request) async {
    return call(() async {
      var items =  await _repository.fetchMyStudent(request);
      return AppResult.success(items);
    });
  }
}
