import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/subjects_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/models/subject_model.dart';

class GetSubjectsUseCase extends BaseUseCase<List<SubjectModel>> {
  final SubjectsRepository _repository = SubjectsRepository();

  Future<AppResult<List<SubjectModel>>> execute() async {
    return call(() async {
      final subjects = await _repository.getSubjects();
      return AppResult.success(subjects);
    });
  }
}