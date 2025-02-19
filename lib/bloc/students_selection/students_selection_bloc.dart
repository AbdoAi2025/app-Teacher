import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_event.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_state.dart';
import 'package:teacher_app/domain/students/add_student_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/models/student_selection_model.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';

class StudentsSelectionBloc
    extends Bloc<StudentsSelectionEvent, StudentsSelectionState> {

  List<StudentSelectionModel> students = [];

  final AddStudentUseCase addStudentUseCase = AddStudentUseCase();

  final GetMyStudentsListUseCase getMyStudentsListUseCase =
      GetMyStudentsListUseCase();

  StudentsSelectionBloc() : super(StudentsLoading()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<StudentsSelectedEvent>(_onStudentsSelectedEvent);
  }

  _onStudentsSelectedEvent(StudentsSelectedEvent event, Emitter<StudentsSelectionState> emit) {
    print("_onStudentsSelectedEvent event:${event.students.length}");
    emit(SelectedStudents(event.students));
  }

  Future<void> _onLoadStudents(
      LoadStudentsEvent event, Emitter<StudentsSelectionState> emit) async {

    if(students.isNotEmpty ){
      emit(StudentsLoaded(students));
      return;
    }

    emit(StudentsLoading());

    var result = GetMyStudentsRequest(hasGroups: false);
    final studentsResult = await getMyStudentsListUseCase.execute(result);

    if (studentsResult.isSuccess) {
      var students = studentsResult.data
              ?.map(
                (e) => StudentSelectionModel(
                    studentId: e.studentId ?? "",
                    studentName: e.studentName ?? "",
                    isSelected: false
                ),
              )
              .toList() ??
          List.empty();

      this.students = students;
      emit(StudentsLoaded(students));
      return;
    }
    if (studentsResult.isError) {
      emit(StudentsError(studentsResult.error?.toString() ?? ""));
    }
  }
}
