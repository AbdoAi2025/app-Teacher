import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/enrollment_repository.dart';
import 'package:teacher_app/data/responses/enroll_request_data.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class UpdateEnrollmentRequestStatusUseCase extends BaseUseCase<EnrollRequestData> {
  final _repository = EnrollmentRepository();

  Future<AppResult<EnrollRequestData>> execute(int id, String status) async {
    return call(() async {
      final data = await _repository.updateRequestStatus(id, status);
      return AppResult.success(data);
    });
  }
}