import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/domain/students/add_student_use_case.dart';
import 'package:teacher_app/domain/students/get_my_students_list_use_case.dart';
import 'package:teacher_app/models/student.dart';
import 'package:teacher_app/requests/add_student_request.dart';
import 'package:teacher_app/requests/get_my_students_request.dart';
import '../../services/api_service.dart';
import 'students_event.dart';
import 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {


  final AddStudentUseCase addStudentUseCase = AddStudentUseCase();

  final ApiService apiService;
  final GetMyStudentsListUseCase getMyStudentsListUseCase =
      GetMyStudentsListUseCase();

  StudentsBloc({required this.apiService}) : super(StudentsInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<AddStudentEvent>(_onAddStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
    on<DeleteAllStudentsEvent>(_onDeleteAllStudents);
  }

  Future<void> _onLoadStudents(
      LoadStudentsEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoading());




      final studentsResult = await getMyStudentsListUseCase.execute(GetMyStudentsRequest());

      if (studentsResult.isSuccess) {
        var students = studentsResult.data?.map(
          (e) => Student(
              id: e.studentId ?? "",
              name: e.studentName ?? "",
              phone: e.studentPhone ?? "",
              parentPhone: e.studentParentPhone ?? "",
              gradeId: 0,
              password: "",
              accessToken: ""
          ),
        ).toList() ?? List.empty();


        emit(StudentsLoaded(students));
        return;
      }


      if(studentsResult.isError){
        emit(StudentsError(studentsResult.error?.toString() ?? ""));
      }

  }

  Future<void> _onAddStudent(AddStudentEvent event, Emitter<StudentsState> emit) async {

      var request = AddStudentRequest();
      request.name = event.student.name;
      request.gradeId = event.student.gradeId;
      request.phone = event.student.phone;
      request.parentPhone = event.student.parentPhone;
      request.password = event.student.password;

     var result =  await addStudentUseCase.execute(request);

     if(result.isSuccess) {
       final studentsResult = await getMyStudentsListUseCase.execute(GetMyStudentsRequest());
       if (studentsResult.isSuccess) {
         var students = studentsResult.data?.map(
               (e) =>
               Student(
                   id: e.studentId ?? "",
                   name: e.studentName ?? "",
                   phone: e.studentPhone ?? "",
                   parentPhone: e.studentParentPhone ?? "",
                   gradeId: 0,
                   password: "",
                   accessToken: ""
               ),
         ).toList() ?? List.empty();
         emit(StudentsLoaded(students));
         return;
       }
     }

     if(result.isError){
       emit(StudentsError(result.error?.toString() ?? ""));
     }

  }

  Future<void> _onUpdateStudent(
      UpdateStudentEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.updateStudent(event
          .updatedStudent); // ✅ استخدم `updatedStudent` بدلاً من `studentId`
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students)); // ✅ تحديث القائمة بعد التعديل
    } catch (e) {
      emit(StudentsError("❌ فشل تحديث بيانات الطالب: $e"));
    }
  }

  Future<void> _onDeleteStudent(
      DeleteStudentEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService
          .deleteStudent(event.studentId); // ✅ استخدم `event.student.id`
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students)); // ✅ تحديث القائمة بعد الحذف
    } catch (e) {
      emit(StudentsError("❌ فشل حذف الطالب: $e"));
    }
  }

  Future<void> _onDeleteAllStudents(
      DeleteAllStudentsEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.deleteAllStudents();
      emit(StudentsLoaded([])); // ✅ تحديث القائمة وإفراغها بعد الحذف
    } catch (e) {
      emit(StudentsError("❌ فشل حذف جميع الطلاب: $e"));
    }
  }
}
