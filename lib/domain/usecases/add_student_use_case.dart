import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/requests/add_student_request.dart';

import '../../data/responses/add_student_response.dart';
import '../events/students_events.dart';

class AddStudentUseCase {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<AddStudentResponse?>> execute(AddStudentRequest request) async {
    try{
       var items =  await repository.addStudent(request);
       StudentsEvents.onStudentAdded();
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
