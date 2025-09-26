import 'package:get/get.dart';
import 'package:teacher_app/screens/report/student_report_controller.dart';

import 'args/student_full_report_args.dart';

class StudentFullReportController extends StudentReportController{

  Rx<StudentFullReportArgs?> fullReportState = Rx(null);

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if(args is StudentFullReportArgs){
      fullReportState.value = args;
    }
  }
}
