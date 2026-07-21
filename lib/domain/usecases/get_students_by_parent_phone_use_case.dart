import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/data/responses/get_students_by_parent_phone_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class GetStudentsByParentPhoneUseCase extends BaseUseCase<List<StudentByParentPhoneApiModel>> {
  final _repository = StudentsRepository();

  Future<AppResult<List<StudentByParentPhoneApiModel>>> execute(String phone) async {
    return call(() async {
      final students = await _repository.getStudentsByParentPhone(phone);
      return AppResult.success(students);
    });
  }
}