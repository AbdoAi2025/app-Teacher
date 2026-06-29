import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class ShareStudentParentLoginInfoUseCase extends BaseUseCase<String> {
  final StudentsRepository repository = StudentsRepository();

  Future<AppResult<String>> execute(String studentId) async {
    return call(() async {
      final url = await repository.shareParentLoginInfo(studentId);
      return AppResult.success(url);
    });
  }
}
