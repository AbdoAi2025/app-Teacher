import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/get_student_details_request.dart';

import '../../data/responses/get_group_details_response.dart';
import '../../data/responses/get_student_details_response.dart';

class GetStudentDetailsUseCase extends BaseUseCase<StudentDetailsApiModel?>{

  var repository = StudentsRepository();

  Future<AppResult<StudentDetailsApiModel?>> execute(String id) async {
    return call(() async {
      var studentDetails =  await repository.getStudentDetails(GetStudentDetailsRequest(id: id));
      return AppResult.success(studentDetails);
    });
  }
}
