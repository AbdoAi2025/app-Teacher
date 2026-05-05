import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/teacher_profile_repository.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class GetTeacherProfileUseCase extends BaseUseCase<TeacherProfileData> {
  final TeacherProfileRepository _repository = TeacherProfileRepository();

  Future<AppResult<TeacherProfileData>> execute() async {
    return call(() async {
      final profile = await _repository.getProfile();
      return AppResult.success(profile);
    });
  }
}