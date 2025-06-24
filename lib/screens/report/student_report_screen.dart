import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/screens/report/student_report_controller.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/done_icon_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'dart:ui' as ui;
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
  final TextEditingController noteEditTextController = TextEditingController();
  bool notesEditable = false;
  Function()? executeAction;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback(addPostFrameCallback);

    return Scaffold(
        appBar: AppToolbarWidget.appBar("Student Report".tr),
        // resizeToAvoidBottomInset: false,
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
          child: Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: RepaintBoundary(
                key: _screenshotKey, // Assign a GlobalKey
                child: Container(
                  color: AppColors.scaffoldBackgroundColor,
                  // decoration: AppBackgroundStyle.getColoredBackgroundRounded( 20,  AppColors.scaffoldBackgroundColor),
                  child: Container(
                    // decoration: AppBackgroundStyle.getColoredBackgroundRoundedBorder(radius: 20, borderColor:  AppColors.appMainColor, bgColor: AppColors.white),
                    margin: EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: GestureDetector(
                      onTapDown: (details) => KeyboardUtils.hideKeyboard(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          _title(state),
                          ..._attendanceText(state),
                          _notes(state),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if(!notesEditable)
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
             onViewButtonClick(state);
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
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [


        Row(
          children: [
            if(_isShowNotes())...{
              Expanded(
                child: AppTextWidget(
                  "Notes".tr,
                  style: AppTextStyle.title,
                ),
              ),
            }else ...{
              Spacer()
            },

            if(executeAction == null)...{
              if(!notesEditable)...{
                EditIconWidget(onClick: onEditNotes)
              }else ...{
                DoneIconWidget(onClick: onNotesEditDone)
              }
            }
          ],
        ),


        if(notesEditable)...{
          AppTextFieldWidget(
            minLines: 3,
            maxLines: 3,
            maxLength: 100,
            textStyle: _getReportTextStyle(),
            controller: noteEditTextController,
            hint: "No Notes".tr,
            readOnly: !notesEditable,
            enabled: notesEditable,
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        }else ...{
          if(_isShowNotes())
          AppTextWidget(
          noteEditTextController.text.isNotEmpty ? noteEditTextController.text : "No note".tr,
            style: _getReportTextStyle(),
          ),
        }

      ],
    );
  }

  /*
  ده شكل التقرير الانجليزي اللي أنا عايزه

    Parent Follow-Up Report

We would like to inform you that the student /...... attended the class on
Day: Saturday — Date: 14/6/2025

The student's behavior during the class was:
Good / Acceptable / Poor

The status of the previous homework was :
Fully done /
Incomplete [missing (...) pages] /
Not done

The student got (... / ...) marks on the quiz.
  * */

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
            //We would like to inform you that the student /...... attended the class on
            // Day: Saturday — Date: 14/6/2025
            _text("${'infoText'.tr}: "),
            _value("${state.studentName} "),
            if(state.attended == true)...{
              _text("${'attended the class on'.tr}: "),
            }else ...{
              _text("${"didn't attend the class on".tr}: "),
            },
            _value("${state.day.tr} - ${state.sessionStartDate}"),
            // _text("${'withDate'.tr} : "),
            // _value("${state.sessionStartDate}."),
          ],
        ),
      ),


      if(state.attended == true)...{
        /*Behavior*/
        //The student's behavior during the class was:
        // Good / Acceptable / Poor
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              _text("${"The student's behavior during the class was".tr}: "),
              _value("${state.behaviorStatus.getString().tr}."),
              if(state.behaviorNotes.isNotEmpty)
                _text(" (${state.behaviorNotes})."),
            ],
          ),
        ),

        /*homework*/
        //The status of the previous homework was :
        // Fully done /
        // Incomplete [missing (...) pages] /
        // Not done
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              _text("${'The status of the previous homework was'.tr}: "),
              _value("${state.homeworkStatus.getString().tr}."),
              if(state.homeworkNotes.isNotEmpty)
                _text(" (${state.homeworkNotes})."),
            ],
          ),
        ),

        /*quiz*/
        //The student got (... / ...) marks on the quiz.
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              _text('The student got'.tr),
              _value(" (${state.quizGrade}/${state.sessionQuizGrade}) "),
              _text('marks on the quiz'.tr),
            ],
          ),
        ),
      }
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
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              _closeIcon(),
              Image.file(file,
                            ),
              _sendButton(state, file)
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    setState(() {
      executeAction = null;
      file.delete();
    });
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
    WhatsappUtils.sendToWhatsAppFile(file, state.parentPhone);
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

  onEditNotes() {
      setState(() {
        notesEditable = true;
      });
  }

  onNotesEditDone() {
    setState(() {
      notesEditable = false;
    });
  }

  void addPostFrameCallback(Duration timeStamp) {
    executeAction?.call();
    executeAction = null;
  }

  void onViewButtonClick(StudentReportArgs state) {
    setState(() {
      executeAction = (){
        onViewReport(state);
      };
    });
  }

  _isShowNotes() =>  executeAction == null ||  noteEditTextController.text.isNotEmpty;
}
