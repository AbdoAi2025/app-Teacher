import 'package:get/get.dart';


import 'args/student_report_args.dart';

class StudentReportController extends GetxController{

  Rx<StudentReportArgs?> state = Rx(null);

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if(args is StudentReportArgs){
      state.value = args;
    }
  }

}
