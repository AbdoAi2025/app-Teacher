import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/requests/update_student_request.dart';

import '../../data/responses/add_student_response.dart';

class UpdateStudentUseCase {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<AddStudentResponse?>> execute(UpdateStudentRequest request) async {
    try{
       var items =  await repository.updateStudent(request);
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
