import 'package:get/get.dart';


class StudentsEventsState{

  bool get isAdded => this is StudentsEventsStateAdded;
  bool get isUpdated => this is StudentsEventsStateUpdated;
  bool get isDeleted => this is StudentsEventsStateDeleted;

}

class StudentsEventsStateAdded extends StudentsEventsState{}

class StudentsEventsStateUpdated extends StudentsEventsState{}

class StudentsEventsStateDeleted extends StudentsEventsState{}

class StudentsEvents {


  static Rx<StudentsEventsState?> studentsEvents = Rx(null);


  static void onStudentAdded() {
    studentsEvents.value = StudentsEventsStateAdded();
  }

  static void onStudentUpdated() {
    studentsEvents.value = StudentsEventsStateUpdated();
  }

  static void onStudentDeleted() {
    studentsEvents.value = StudentsEventsStateDeleted();
  }

}
