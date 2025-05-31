import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/requests/get_student_details_request.dart';

import '../../data/responses/get_group_details_response.dart';
import '../../data/responses/get_student_details_response.dart';

class GetStudentDetailsUseCase {

  var repository = StudentsRepository();

  Future<AppResult<StudentDetailsApiModel?>> execute(String id) async {
    try{
       var studentDetails =  await repository.getStudentDetails(GetStudentDetailsRequest(id: id));
       return AppResult.success(studentDetails);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
