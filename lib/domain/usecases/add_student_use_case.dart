import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/students_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../../data/responses/error_response.dart';
import '../events/students_events.dart';
import '../states/add_student_result.dart';

class AddStudentUseCase extends BaseUseCase<AddStudentResult?> {

  StudentsRepository repository = StudentsRepository();

  Future<AppResult<AddStudentResult?>> execute(AddStudentRequest request) async {
   return call(() async {
       await repository.addStudent(request);
      StudentsEvents.onStudentAdded();
      return AppResult.success(AddStudentResultSuccess());
    });
  }

  @override
  AppResult<AddStudentResult?> onErrorResponse(ErrorResponse errorResponse , DioException ex) {
    appLog("AddStudentUseCase errorResponse.errorType:${errorResponse.errorType}");
    appLog("AddStudentUseCase errorResponse.message:${errorResponse.message}");
    return AppResult.error(ex, errorResponse.errorType == 1 ? AddStudentResultStudentLimitExceeded() : null);
  }
}
