import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/student.dart';
import '../groups/groups_event.dart';
import 'students_event.dart';
import 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  List<Student> students = [];
  final Box _studentsBox = Hive.box('studentsBox'); // ✅ صندوق التخزين في Hive

  StudentsBloc() : super(StudentsInitial()) {
    _loadStudentsFromHive(); // ✅ تحميل الطلاب عند بدء التطبيق

    on<LoadStudentsEvent>((event, emit) {
      emit(StudentsLoading());
      emit(StudentsLoaded(students));
    });

    on<AddStudentEvent>((event, emit) {
      students.add(event.student);
      _saveStudentsToHive(); // ✅ حفظ الطلاب في Hive بعد الإضافة
      emit(StudentsLoaded(students));
    });

    on<DeleteAllStudentsEvent>((event, emit) {
      students.clear(); // ✅ حذف جميع الطلاب من القائمة
      _saveStudentsToHive(); // ✅ تحديث البيانات في `Hive`
      emit(StudentsLoaded(students)); // ✅ تحديث الواجهة فورًا
    });


  }

  // ✅ استرجاع بيانات الطلاب عند بدء التطبيق
  void _loadStudentsFromHive() {
    final storedStudents = _studentsBox.get('students', defaultValue: []);
    if (storedStudents.isNotEmpty) {
      students = List<Student>.from(storedStudents.map((s) => Student.fromMap(Map<String, dynamic>.from(s))));
      emit(StudentsLoaded(students));
    }
  }

  // ✅ حفظ بيانات الطلاب في Hive
  void _saveStudentsToHive() {
    final studentMaps = students.map((s) => s.toMap()).toList();
    _studentsBox.put('students', studentMaps);
  }
}
