import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/rejoin_requests_repository.dart';
import 'package:teacher_app/data/responses/get_rejoin_requests_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class GetSentRejoinRequestsUseCase extends BaseUseCase<RejoinRequestsPageData> {
  final _repository = RejoinRequestsRepository();

  Future<AppResult<RejoinRequestsPageData>> execute({int page = 0, int size = 20}) async {
    return call(() async {
      final data = await _repository.getSentRejoinRequests(page: page, size: size);
      return AppResult.success(data);
    });
  }
}