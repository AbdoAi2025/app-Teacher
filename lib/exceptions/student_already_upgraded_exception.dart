import 'package:teacher_app/exceptions/app_http_exception.dart';

class StudentAlreadyUpgradedException extends AppHttpException {
  StudentAlreadyUpgradedException(super.message);
}