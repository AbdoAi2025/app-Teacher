import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';

import '../events/students_events.dart';

class UpdateStudentGradeUseCase extends BaseUseCase<dynamic> {

  var repository = StudentsRepository();

  Future<AppResult<dynamic>> execute(String id, String gradeId, String studentId) async {
    return call(() async {
      var result = await repository.updateStudentGrade(id, gradeId);
      StudentsEvents.onStudentUpdated(studentId);
      return AppResult.success(result);
    });
  }
}