import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/report/student_report_screen.dart';
import 'package:teacher_app/screens/report_full_report/args/student_full_report_args.dart';
import 'package:teacher_app/screens/student_reports/states/student_reports_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../widgets/quiz_grade_widget.dart';
import '../report/student_report_controller.dart';
import 'student_full_report_controller.dart';

class StudentFullReportScreen extends StudentReportScreen {
  const StudentFullReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentFullReportScreen();
}

class _StudentFullReportScreen extends StudentReportScreenState {
  final StudentFullReportController _controller =
      Get.put(StudentFullReportController());

  @override
  StudentReportController get controller => _controller;

  @override
  content() {
    return Obx(() {
      var state = _controller.fullReportState.value;
      if (state != null) {
        return reportData("Full Report".tr,  state.state.phoneNumber, _reportContent(state.state));
      }
      return ErrorWidget("Invalid data".tr);
    });
  }


  Widget _reportContent(StudentReportsStateSuccess state) {
    return Column(
      spacing: 10,
      children: [
        ...reportTexts(state),
        notes(),
        //Under the supervision of Mr. Hassan
        underTheSupervision()
      ],
    );
  }

  reportTexts(StudentReportsStateSuccess state) {

    var attendance = state.totalAttendance;
    var totalAttendance = state.uiStates.length;

    double? totalGrades = state.totalGrades;
    var totalSessionGrades = state.totalSessionGrades;
    var gradesPercentage = state.gradesPercentage;

    return [
      /*Attendance*/
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            //We would like to inform you that the student /...... attended the class on
            // Day: Saturday — Date: 14/6/2025
            reportText("${'fulReportInfoText'.tr}: \n"),
            reportValue("${state.studentName} \n" , getReportTextValueStyle().copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),


      /*Attendance*/
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            reportText('Total Attendance'.tr),
            reportValue(" ($attendance/$totalAttendance) " , getReportTextValueStyle().copyWith(color: attendance < (totalAttendance/2) ? AppColors.colorNo : AppColors.colorYes)),
            reportText('marks on the quiz'.tr),
          ],
        ),
      ),

      /*quiz*/
      //The student got (... / ...) marks on the quiz.
      if(totalGrades != null)
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            reportText('Average Grade'.tr),
            reportValue(" (${QuizGradeWidget.getGradeFormat(totalGrades)}/$totalSessionGrades)   $gradesPercentage%" , quizGradeStyle(totalGrades, totalSessionGrades)),
          ],
        ),
      ),
    ];
  }
}
