import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/repositories/grades_repository.dart';

class GetGradesListUseCase {

  GradesRepository repository = GradesRepository();

  Future<AppResult<List<GradeApiModel>>> execute() async {
    try{
       var items =  await repository.fetchAllGrades();
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
