import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/rejoin_requests_repository.dart';
import 'package:teacher_app/data/responses/get_rejoin_requests_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/create_rejoin_request_request.dart';

class CreateRejoinRequestUseCase extends BaseUseCase<RejoinRequestData?> {
  final _repository = RejoinRequestsRepository();

  Future<AppResult<RejoinRequestData?>> execute() async {
    return call(() async {
      final data = await _repository.createRejoinRequest(
        const CreateRejoinRequestRequest(),
      );
      return AppResult.success(data);
    });
  }
}