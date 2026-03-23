import 'package:teacher_app/utils/LogUtils.dart';

class GetStudentActivitiesRequest {
  final String studentId;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  GetStudentActivitiesRequest({
    required this.studentId,
    this.dateFrom,
    this.dateTo,
  });

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = {
      'studentId': studentId,
    };

    if (dateFrom != null) {
      data['dateFrom'] = _formatDate(dateFrom!);
    }

    if (dateTo != null) {
      data['dateTo'] = _formatDate(dateTo!);
    }

    return data;
  }

  String _formatDate(DateTime date) {
    try{
      // Format as YYYY-MM-DD for API
      return '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }catch (ex){
      appLog("GetStudentActivitiesRequest _formatDate: ex:${ex.toString()}");
      return "";
    }
  }

  @override
  String toString() {
    return 'GetStudentActivitiesRequest(studentId: $studentId, dateFrom: $dateFrom, dateTo: $dateTo)';
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is GetStudentActivitiesRequest &&
  //         runtimeType == other.runtimeType &&
  //         studentId == other.studentId &&
  //         dateFrom == other.dateFrom &&
  //         dateTo == other.dateTo;
  //
  // @override
  // int get hashCode =>
  //     studentId.hashCode ^ dateFrom.hashCode ^ dateTo.hashCode;
}