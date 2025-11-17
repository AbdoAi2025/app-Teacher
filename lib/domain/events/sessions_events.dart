import 'package:get/get.dart';

import '../../utils/LogUtils.dart';


class SessionsEventsState{}

class SessionsEventsStateAdded extends SessionsEventsState{}

class SessionsEventsStateUpdated extends SessionsEventsState{
  final String? id;
  SessionsEventsStateUpdated(this.id);
}

class SessionsEventsStateDeleted extends SessionsEventsState{
  final String? id;
  SessionsEventsStateDeleted(this.id);
}

class SessionsEvents {

  SessionsEvents._();

  static List<Function(SessionsEventsState)> listeners = [];

  static void addListener(Function(SessionsEventsState) listener) {
    appLog("SessionsEvents removeListener listeners:${listeners.length}");
    listeners.add(listener);
    appLog("GroupsManagers removeListener listeners:${listeners.length}");
  }

  static void removeListener(Function(SessionsEventsState) listener) {
    appLog("SessionsEvents removeListener listeners:${listeners.length}");
    listeners.remove(listener);
    appLog("SessionsEvents removeListener listeners:${listeners.length}");
  }

  static void onSessionDeleted(String id) {
    _notifyListeners(SessionsEventsStateDeleted(id));
  }


  static void _notifyListeners(SessionsEventsState event) {
    for (var listener in listeners) {
      listener.call(event);
    }
  }

}
