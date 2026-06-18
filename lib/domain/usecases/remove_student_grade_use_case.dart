import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';

import '../events/students_events.dart';

class RemoveStudentGradeUseCase extends BaseUseCase<dynamic> {

  var repository = StudentsRepository();

  Future<AppResult<dynamic>> execute(String id) async {
    return call(() async {
      var result = await repository.removeStudentGrade(id);
      StudentsEvents.onStudentUpdated(id);
      return AppResult.success(result);
    });
  }
}