import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/screens/report/student_report_controller.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/whatsapp_utils.dart';
import '../../widgets/app_toolbar_widget.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  final StudentReportController controller = Get.put(StudentReportController());
  final GlobalKey _screenshotKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Student Report".tr),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _content(),
        ));
  }

  _content() {
    return Obx(() {
      var state = controller.state.value;
      if (state != null) {
        return _reportData(state);
      }

      return ErrorWidget("Invalid data");
    });
  }

  _reportData(StudentReportArgs state) {
    return Column(
      spacing: 20,
      children: [
        Expanded(
          child: RepaintBoundary(
            key: _screenshotKey, // Assign a GlobalKey
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 40),
              child: Column(
                spacing: 15,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      _title(state),
                      ..._attendanceText(state),
                      _notes(state),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
        _viewButton(state)
      ],
    );
  }

  _viewButton(StudentReportArgs state) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
          text: "View".tr,
          onClick: () {
            onViewReport(state);
          }),
    );
  }

  _sendButton(StudentReportArgs state, File file) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
          text: "Send".tr,
          onClick: () {
            onSendReport(state, file);
          }),
    );
  }

  _notes(StudentReportArgs state) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Notes".tr,
          style: AppTextStyle.title,
        ),
        AppTextFieldWidget(
          minLines: 4,
          textStyle: _getReportTextStyle(),
          controller: TextEditingController(),
          hint: "No Notes".tr,
          border: InputBorder.none,
        ),
      ],
    );
  }

  _title(StudentReportArgs state) {
    var sessionName = state.sessionName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextWidget(
              "report_parent_title".tr,
              style: AppTextStyle.title,
              textAlign: TextAlign.center,
            ),
            if (sessionName.isNotEmpty)
              AppTextWidget(
                "${"Session".tr}:$sessionName",
                style: AppTextStyle.title,
              ),
          ],
        ),
      ],
    );
  }

  List<Widget> _attendanceText(StudentReportArgs state) {
    return [
      /*Attendance*/
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            _text("${'infoText'.tr} / "),
            _value("${state.studentName} "),
            _text("${'hasAttended'.tr} / "),
            _value("${state.day} "),
            _text("${'withDate'.tr} / "),
            _value("${state.sessionStartDate}."),
          ],
        ),
      ),

      /*Behavior*/
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            _text("${'His behavior during the session was'.tr} / "),
            _value("${state.behaviorGood ? "Good".tr : "Bad".tr}."),
          ],
        ),
      ),

      /*quiz*/
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            _text("${'The test score for the above was'.tr} / "),
            _value("${state.quizGrade}/${state.sessionQuizGrade}."),
          ],
        ),
      ),
    ];
  }

  TextSpan _text(String text) {
    return TextSpan(text: text, style: _getReportTextStyle());
  }

  TextSpan _value(String text) {
    return TextSpan(
      text: text,
      style: AppTextStyle.teshrinArLtRegular
          .copyWith(height: 2, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  _getReportTextStyle() =>
      AppTextStyle.teshrinArLtRegular.copyWith(height: 2, fontSize: 16);

  Future<void> onViewReport(StudentReportArgs state) async {
    var file = await saveScreenshot();
    if (file == null) {
      return;
    }

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 20,
            children: [
              _closeIcon(),
              Expanded(
                  child: Image.file(
                file,
                fit: BoxFit.fill,
              )),
              _sendButton(state, file)
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    file.delete();
  }

  Future<Uint8List?> captureWidget() async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Higher res
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      appLog("Error capturing screenshot: $e");
      return null;
    }
  }

  Future<File?> saveScreenshot() async {
    final Uint8List? imageBytes = await captureWidget();
    if (imageBytes != null) {
      final directory =
          await getTemporaryDirectory(); // Requires `path_provider`
      final imagePath = '${directory.path}/${DateTime.now()}_screenshot.png';
      var file = await File(imagePath).writeAsBytes(imageBytes);
      appLog("Screenshot saved: $imagePath");
      return file;
    }

    return null;
  }

  void onSendReport(StudentReportArgs state, File file) {
      WhatsappUtils.sendToWhatsAppFile(file, "+201063271529");
  }

  _closeIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.close)),
      ],
    );
  }
}
