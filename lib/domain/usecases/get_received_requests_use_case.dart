import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/enrollment_repository.dart';
import 'package:teacher_app/data/responses/get_join_requests_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class GetReceivedRequestsUseCase extends BaseUseCase<EnrollRequestsPageData> {
  final _repository = EnrollmentRepository();

  Future<AppResult<EnrollRequestsPageData>> execute({int page = 0, int size = 20}) async {
    return call(() async {
      final data = await _repository.getReceivedRequests(page: page, size: size);
      return AppResult.success(data);
    });
  }
}