import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/add_student_request.dart';

import '../../data/responses/add_student_response.dart';
import '../events/students_events.dart';

class AddStudentUseCase extends BaseUseCase<AddStudentResponse?> {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<AddStudentResponse?>> execute(AddStudentRequest request) async {
   return call(() async {
      var items =  await repository.addStudent(request);
      StudentsEvents.onStudentAdded();
      return AppResult.success(items);
    });
  }
}
