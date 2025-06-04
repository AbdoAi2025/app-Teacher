import 'package:teacher_app/utils/day_utils.dart';

import '../../../enums/session_status_enum.dart';

class SessionItemUiState {

  final String id;
  final String sessionName;
  final SessionStatus sessionStatus;
  final String? sessionCreatedAt;
  final String groupId;
  final String groupName;
  final String timeFrom;
  final String timeTo;

  SessionItemUiState(
      {
        required this.id,
        required this.sessionName,
        required this.sessionStatus,
        required this.sessionCreatedAt,
        required this.groupId,
        required this.groupName,
        required this.timeFrom,
        required this.timeTo,

      });

  get date => AppDateUtils.parsStringToString(sessionCreatedAt , "yyyy-MM-dd");



  isSessionActive() => sessionStatus == SessionStatus.active;
}

