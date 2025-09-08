import 'package:synchronized/synchronized.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/grades_repository.dart';

class GetGradesListUseCase {


  static  List<GradeApiModel> _grades = [];
  static final _lock = Lock();

  GradesRepository repository = GradesRepository();

  Future<AppResult<List<GradeApiModel>>> execute() async {
    try{
      return _lock.synchronized(() async {
        if(_grades.isNotEmpty) return AppResult.success(_grades);
        var items =  await repository.fetchAllGrades();
        _grades = items;
        return AppResult.success(items);
      },);

    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
