import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/enums/homework_enum.dart';

import '../../../enums/student_behavior_enum.dart';
import '../../../utils/day_utils.dart';
import '../../session_details/states/session_details_ui_state.dart';
import '../../student_reports/models/date_filter_model.dart';
import '../../student_reports/states/student_reports_state.dart';

class StudentFullReportArgs {
  final StudentReportsStateSuccess state;
  final DateFilter dateFilter;

  StudentFullReportArgs({
    required this.state,
    required this.dateFilter,
  });
}
