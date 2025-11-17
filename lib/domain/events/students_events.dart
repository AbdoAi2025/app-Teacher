import 'package:get/get.dart';

import '../../utils/LogUtils.dart';


class StudentsEventsState{

  bool get isAdded => this is StudentsEventsStateAdded;
  bool get isUpdated => this is StudentsEventsStateUpdated;
  bool get isDeleted => this is StudentsEventsStateDeleted;

}

class StudentsEventsStateAdded extends StudentsEventsState{}

class StudentsEventsStateUpdated extends StudentsEventsState{
  final String? id;
  StudentsEventsStateUpdated(this.id);
}

class StudentsEventsStateDeleted extends StudentsEventsState{}

class StudentsEvents {

  StudentsEvents._();

  static List<Function(StudentsEventsState)> listeners = [];

  static void addListener(Function(StudentsEventsState) listener) {
    appLog("StudentsEvents removeListener listeners:${listeners.length}");
    listeners.add(listener);
    appLog("GroupsManagers removeListener listeners:${listeners.length}");
  }

  static void removeListener(Function(StudentsEventsState) listener) {
    appLog("StudentsEvents removeListener listeners:${listeners.length}");
    listeners.remove(listener);
    appLog("StudentsEvents removeListener listeners:${listeners.length}");
  }

  static void onStudentAdded() {
    _notifyListeners(StudentsEventsStateAdded());
  }

  static void onStudentDeleted() {
    _notifyListeners(StudentsEventsStateDeleted());
  }

  static void _notifyListeners(StudentsEventsState event) {
    for (var listener in listeners) {
      listener.call(event);
    }
  }

  static void onStudentUpdated(String? id) {
    _notifyListeners(StudentsEventsStateUpdated(id));
  }

}
