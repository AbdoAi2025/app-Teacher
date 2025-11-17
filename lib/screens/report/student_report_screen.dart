import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/generated/assets.dart';
import 'package:teacher_app/screens/home/home_controller.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/screens/report/student_report_controller.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/done_icon_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'dart:ui' as ui;
import '../../utils/whatsapp_utils.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../session_details/states/session_details_ui_state.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});
  @override
  State<StudentReportScreen> createState() => StudentReportScreenState();
}

class StudentReportScreenState extends State<StudentReportScreen> {
  final StudentReportController _studentReportController = Get.put(StudentReportController());
  final GlobalKey _screenshotKey = GlobalKey();
  final TextEditingController noteEditTextController = TextEditingController();
  final HomeController homeController = Get.find();
  
  StudentReportController get controller => _studentReportController;
  bool notesEditable = false;
  Function()? executeAction;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(addPostFrameCallback);

    return Scaffold(
        appBar: AppToolbarWidget.appBar(title: "Student Report".tr),
        // resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: content(),
        ));
  }

  content() {
    return Obx(() {
      var state = controller.state.value;
      if (state != null) {
        return reportData(state.sessionName,  state.parentPhone, _reportContent(state));
      }
      return ErrorWidget("Invalid data");
    });
  }

  reportData(String reportTitleText, String parentPhone, Widget reportContentWidget) {
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(Assets.imagesReportBg))),
                  // color: AppColors.scaffoldBackgroundColor,
                  // decoration: AppBackgroundStyle.getColoredBackgroundRounded( 20,  AppColors.scaffoldBackgroundColor),
                  child: Container(
                    // decoration: AppBackgroundStyle.getColoredBackgroundRoundedBorder(radius: 20, borderColor:  AppColors.appMainColor, bgColor: AppColors.white),
                    margin: EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: GestureDetector(
                      onTapDown: (details) =>
                          KeyboardUtils.hideKeyboard(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          reportTitle(reportTitleText),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: AppBackgroundStyle
                                .getColoredBackgroundRoundedBorder(
                                    radius: 20,
                                    bgColor : Colors.transparent,
                                    borderColor: AppColors.appMainColor,
                                    borderWidth: 5),
                            child: reportContentWidget,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!notesEditable) _viewButton(parentPhone)
      ],
    );
  }
  
  _reportContent(StudentReportArgs state) => Column(
    spacing: 10,
    children: [
      ..._reportTexts(state),
      notes(),
      //Under the supervision of Mr. Hassan
      underTheSupervision()

    ],
  );

  _viewButton(String parentPhone) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
          text: "View".tr,
          onClick: () {
            onViewButtonClick(parentPhone);
          }),
    );
  }

  _sendButton(String parentPhone,File file) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
          text: "Send".tr,
          onClick: () {
            onSendReport(parentPhone, file);
          }),
    );
  }

  notes() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (_isShowNotes()) ...{
              Expanded(
                child: AppTextWidget(
                  "Notes".tr,
                  style: AppTextStyle.title,
                ),
              ),
            } else ...{
              Spacer()
            },
            if (executeAction == null) ...{
              if (!notesEditable) ...{
                EditIconWidget(onClick: onEditNotes)
              } else ...{
                DoneIconWidget(onClick: onNotesEditDone)
              }
            }
          ],
        ),
        if (notesEditable) ...{
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
        } else ...{
          if (_isShowNotes())
            AppTextWidget(
              noteEditTextController.text.isNotEmpty
                  ? noteEditTextController.text
                  : "No note".tr,
              style: _getReportTextStyle(),
            ),
        }
      ],
    );
  }


  underTheSupervision(){


    var teacherName = homeController.profileInfo.value?.name ?? "";

    return SizedBox(
      width: double.infinity,
      child: AppTextWidget("${"Under the supervision of".tr} $teacherName" , style: getReportTextValueStyle()),
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

  reportTitle(String sessionName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTextWidget(
              "report_parent_title".tr,
              style: AppTextStyle.title.copyWith(color: AppColors.appMainColor , fontSize: 24 , fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            if (sessionName.isNotEmpty)...{
              AppTextWidget(
                // "${"Session".tr}:$sessionName",
                sessionName,
                style: AppTextStyle.title.copyWith(color: AppColors.color_3D3D3D80 , fontSize: 20, fontStyle: FontStyle.italic),
              ),
            }

          ],
        ),
      ],
    );
  }

  List<Widget> _reportTexts(StudentReportArgs state) {
    return [
      /*Attendance*/
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            //We would like to inform you that the student /...... attended the class on
            // Day: Saturday — Date: 14/6/2025
            reportText("${'infoText'.tr}: \n"),
            reportValue("${state.studentName} \n" , getReportTextValueStyle().copyWith(fontWeight: FontWeight.bold)),
            if (state.attended == true) ...{
              reportText("${'attended'.tr} " , _getReportTextStylePositive()),
            } else ...{
              reportText("${"didn't attend".tr} ", _getReportTextStyleNegative()),
            },
            reportText("\n"),
            reportText("${'Session Day'.tr}: \n"),
            reportValue("${state.day.tr} - ${state.sessionStartDate}"),
            // _text("${'withDate'.tr} : "),
            // _value("${state.sessionStartDate}."),
          ],
        ),
      ),
      if (state.attended == true) ...{
        /*Behavior*/
        //The student's behavior during the class was:
        // Good / Acceptable / Poor
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              reportText("${"The student's behavior during the class was".tr}: "),
              reportValue("${state.behaviorStatus.getString().tr}." , getReportTextValueStyle().copyWith(color: state.behaviorStatus.getColor())),
              if (state.behaviorNotes.isNotEmpty)
                reportText(" (${state.behaviorNotes})."),
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
              reportText("${'The status of the previous homework was'.tr}: "),
              reportValue("${state.homeworkStatus.getString().tr}." , getReportTextValueStyle().copyWith(color: state.homeworkStatus.getColor())),
              if (state.homeworkNotes.isNotEmpty)
                reportText(" (${state.homeworkNotes})."),
            ],
          ),
        ),

        /*quiz*/
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: [
              reportText('The student got'.tr),
              reportValue(" (${state.quizGrade}/${state.sessionQuizGrade}) " , quizGradeStyle(state.uiState.quizGrade, state.uiState.sessionQuizGrade)),
              reportText('marks on the quiz'.tr),
            ],
          ),
        ),
      }
    ];
  }

  TextSpan reportText(String text , [TextStyle? style ]) {
    return TextSpan(text: text, style: style ?? _getReportTextStyle());
  }

  TextSpan reportValue(String text , [TextStyle? style ]) {
    return TextSpan(
      text: text,
      style: style ?? getReportTextValueStyle(),
    );
  }

  _getReportTextStyle() =>
      AppTextStyle.teshrinArLtRegularBold.copyWith(fontStyle: FontStyle.italic, height: 2, fontSize: 16);

  Future<void> onViewReport(String parentPhone) async {
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
              Flexible(
                child: Image.file(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
              _sendButton(parentPhone, file)
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

  void onSendReport(String parentPhone, File file) {
    WhatsappUtils.sendToWhatsAppFile(file, parentPhone);
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

  void onViewButtonClick(String parentPhone) {
    setState(() {
      executeAction = () {
        onViewReport(parentPhone);
      };
    });
  }

  _isShowNotes() =>
      executeAction == null || noteEditTextController.text.isNotEmpty;

  TextStyle? _getReportTextStylePositive() => _getReportTextStyle().copyWith(color: AppColors.color_008E73);

  TextStyle? _getReportTextStyleNegative() => _getReportTextStyle().copyWith(color: AppColors.color_E75260);

  TextStyle getReportTextValueStyle() => AppTextStyle.teshrinArLtRegular
      .copyWith(
      height: 2,
      fontWeight: FontWeight.bold,
      fontSize: 16,
     fontStyle: FontStyle.italic
  );

  TextStyle quizGradeStyle(double? quizGrade, int? total) {
    var color = (quizGrade ?? 0) >= ((total ?? 0 )/ 2)
    ? AppColors.color_008E73 : AppColors.color_E75260;

    return getReportTextValueStyle().copyWith(
      color: color
    );
  }



}
