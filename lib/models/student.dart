

class Student {
  final String id;
  final String name;
  final String phone;
  final String parentPhone;
  final int gradeId;
  final String password;
  final String accessToken;
  final bool attended;
  final bool homeworkDone;



  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.parentPhone,
    required this.gradeId,
    required this.password,
    required this.accessToken,
    this.attended = false,
    this.homeworkDone = false,

  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['studentId']?.toString()??"" ,
      name: json['name'],
      phone: json['phone'],
      parentPhone: json['parentPhone'],
      gradeId: json['grade']['id'], // ✅ استخراج ID فقط من الكائن
      password: "", // API لا يعيد كلمة المرور بعد الإنشاء
      accessToken: json.containsKey('accessToken') ? json['accessToken'] : "",
      attended: json.containsKey('attended') ? json['attended'] : false, // ✅ دعم الحضور
      homeworkDone: json.containsKey('homeworkDone') ? json['homeworkDone'] : false, // ✅ دعم الواجب
    );
  }

  String get studentId => "";           //add this student id after doing bottom sheet for students

  Map<String, dynamic> toJson() {
    return {
      "studentId": id,
      "name": name,
      "phone": phone,
      "parentPhone": parentPhone,
      "gradeId": gradeId, // ✅ إرسال ID فقط عند الطلب
      "password": password,
      "attended": attended, // ✅ إرسال بيانات الحضور
      "homeworkDone": homeworkDone, // ✅ إرسال بيانات الواجب
    };
  }

  Student copyWith({
    String? name,
    String? phone,
    String? parentPhone,
    int? gradeId,
    String? password,
    String? accessToken,
    bool? attended,
    bool? homeworkDone,
  }) {
    return Student(
      id: this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      gradeId: gradeId ?? this.gradeId,
      password: password ?? this.password,
      accessToken: accessToken ?? this.accessToken,
      attended: attended ?? this.attended,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }
}
