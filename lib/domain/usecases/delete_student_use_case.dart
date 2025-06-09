import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';

import '../../data/repositories/students_repository.dart';
import '../events/students_events.dart';

class DeleteStudentUseCase {

  var repository = StudentsRepository();

  Future<AppResult<dynamic>> execute(String id) async {
    try{
       var items =  await repository.deleteStudent(id);
       StudentsEvents.onStudentDeleted();
       return AppResult.success(AppResultSuccess(items));
    } catch(ex){
      return AppResult.error(Exception(ex));
    }
  }
}
