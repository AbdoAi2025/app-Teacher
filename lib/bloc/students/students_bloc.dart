import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'students_event.dart';
import 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final ApiService apiService;

  StudentsBloc({required this.apiService}) : super(StudentsInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<AddStudentEvent>(_onAddStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
    on<DeleteAllStudentsEvent>(_onDeleteAllStudents);
  }

  Future<void> _onLoadStudents(LoadStudentsEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoading());
    try {
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(StudentsError("❌ فشل تحميل الطلاب: $e"));
    }
  }

  Future<void> _onAddStudent(AddStudentEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.createStudent(event.student);
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(StudentsError("❌ فشل إضافة الطالب: $e"));
    }
  }

  Future<void> _onUpdateStudent(UpdateStudentEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.updateStudent(event.student);
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(StudentsError("❌ فشل تحديث بيانات الطالب: $e"));
    }
  }

  Future<void> _onDeleteStudent(DeleteStudentEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.deleteStudent(event.student.id); // ✅ تأكد من استخدام `id`
      final students = await apiService.fetchStudents();
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(StudentsError("❌ فشل حذف الطالب: $e"));
    }
  }

  Future<void> _onDeleteAllStudents(DeleteAllStudentsEvent event, Emitter<StudentsState> emit) async {
    try {
      await apiService.deleteAllStudents();
      emit(StudentsLoaded([]));
    } catch (e) {
      emit(StudentsError("❌ فشل حذف جميع الطلاب: $e"));
    }
  }
}
