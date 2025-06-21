
import 'package:intl/intl.dart';

class GradeUtils {

  static String getGradeFormat(double? quizGrade) {
    return NumberFormat.compact().format(quizGrade ?? 0);
  }
}
