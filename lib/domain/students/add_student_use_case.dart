  import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/repositories/students_repository.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import 'package:teacher_app/responses/add_student_response.dart';

class AddStudentUseCase {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<AddStudentResponse?>> execute(AddStudentRequest request) async {
    try{
       var items =  await repository.addStudent(request);
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
