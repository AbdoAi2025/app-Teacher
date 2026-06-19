import '../../models/check_user_session_model.dart';

class UserSessionState{}
class UserSessionStateError extends UserSessionState{
  final Exception? ex;
  UserSessionStateError(this.ex);
}
class UserSessionStateInvalidSession extends UserSessionState{}
class UserSessionStateNotActive extends UserSessionState{
  final CheckUserSessionModel? session;
  UserSessionStateNotActive({this.session});
}
class UserSessionStateSuccess extends UserSessionState{}
class UserSessionStateMustCompleteProfile extends UserSessionState{}
class UserSessionStateRequireVerify extends UserSessionState{
  final String? userId;
  final String? otpSentTo;
  UserSessionStateRequireVerify({this.userId, this.otpSentTo});
}
class UserSessionStateRemainDays extends UserSessionState{
  final int remainingDays;
  UserSessionStateRemainDays(this.remainingDays);
}