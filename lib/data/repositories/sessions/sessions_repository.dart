import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

abstract  class SessionsRepository {

  Future<String?> startSession(String name , String groupId);
}