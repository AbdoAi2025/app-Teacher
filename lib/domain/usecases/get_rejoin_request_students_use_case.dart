import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/rejoin_requests_repository.dart';
import 'package:teacher_app/data/responses/get_rejoin_request_students_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class GetRejoinRequestStudentsUseCase extends BaseUseCase<RejoinRequestStudentsPageData> {
  final _repository = RejoinRequestsRepository();

  Future<AppResult<RejoinRequestStudentsPageData>> execute(
    int requestId, {
    int page = 0,
    int size = 20,
    String? gradeId,
    String? search,
    String? status,
  }) async {
    return call(() async {
      final data = await _repository.getStudents(
        requestId,
        page: page,
        size: size,
        gradeId: gradeId,
        search: search,
        status: status,
      );
      return AppResult.success(data);
    });
  }
}