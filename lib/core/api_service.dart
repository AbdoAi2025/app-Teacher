import 'package:dio/dio.dart';
import '../models/student.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Student>> fetchStudents() async {
    final response = await _dio.get('https://api.example.com/students');
    return (response.data as List).map((e) => Student(
      id: e['id'],
      name: e['name'],
      phone: e['phone'],
      grade: e['grade'],
      password: e['password'],
    )).toList();
  }
}
