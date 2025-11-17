import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';

import '../../data/repositories/students_repository.dart';
import '../base_use_case.dart';
import '../events/students_events.dart';

class DeleteStudentUseCase extends BaseUseCase<dynamic>{

  var repository = StudentsRepository();

  Future<AppResult<dynamic>> execute(String id) async {
   return call(() async {
      var items =  await repository.deleteStudent(id);
      StudentsEvents.onStudentDeleted();
      return AppResult.success(AppResultSuccess(items));
    });
  }
}
