import 'package:teacher_app/apimodels/student_list_item_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/repositories/students_repository.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';

class GetMyStudentsListUseCase {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<List<StudentListItemApiModel>>> execute(GetMyStudentsRequest request) async {
    try{
       var items =  await repository.fetchMyStudent(request);
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
