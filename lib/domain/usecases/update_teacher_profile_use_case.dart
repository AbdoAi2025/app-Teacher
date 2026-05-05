import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/teacher_profile_repository.dart';
import 'package:teacher_app/data/requests/update_teacher_profile_request.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';

class UpdateTeacherProfileUseCase extends BaseUseCase<TeacherProfileData> {
  final TeacherProfileRepository _repository = TeacherProfileRepository();

  Future<AppResult<TeacherProfileData>> execute({
    required String name,
    required String email,
    required String phone,
    required GenderEnum gender,
    required int subjectId,
  }) async {
    return call(() async {
      final request = UpdateTeacherProfileRequest(
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        subjectId: subjectId,
      );
      final updated = await _repository.updateProfile(request);
      return AppResult.success(updated);
    });
  }
}