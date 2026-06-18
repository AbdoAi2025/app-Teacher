import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/upgrade_student_request.dart';

import '../events/students_events.dart';

class UpgradeStudentUseCase extends BaseUseCase<dynamic> {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<dynamic>> execute(UpgradeStudentRequest request) async {
    return call(() async {
      var result = await repository.upgradeStudents([request]);
      StudentsEvents.onStudentUpdated(request.studentId);
      return AppResult.success(result);
    });
  }

  Future<AppResult<dynamic>> executeMultiple(List<UpgradeStudentRequest> requests) async {
    return call(() async {
      var result = await repository.upgradeStudents(requests);
      // Notify about all updated students
      for (var request in requests) {
        StudentsEvents.onStudentUpdated(request.studentId);
      }
      return AppResult.success(result);
    });
  }
}