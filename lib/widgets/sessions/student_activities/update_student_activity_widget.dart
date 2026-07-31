import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacher_app/data/repositories/activity_images_repository.dart';
import 'package:teacher_app/domain/models/activity_image_model.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_shared/widgets/image_gallery_viewer.dart';
import 'package:teacher_shared/widgets/image_load_network.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import '../../../bottomsheets/app_bottom_sheets.dart';
import '../../../enums/student_behavior_enum.dart';
import '../../../screens/session_details/states/session_details_ui_state.dart';
import '../../../utils/grade_utils.dart';
import '../../../utils/message_utils.dart';
import '../../app_radio_widget.dart';
import '../../app_text_field_widget.dart';
import '../../app_txt_widget.dart';
import '../../label_widget.dart';
import '../../primary_button_widget.dart';
import '../../switch_button_widget.dart';
import '../../title_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class UpdateStudentActivityWidget extends StatefulWidget {

  final SessionActivityItemUiState uiState;
  final Function() onCloseClick;
  final Function(SessionActivityItemUiState) onSaveClick;

  const UpdateStudentActivityWidget({
    super.key,
    required this.uiState,
    required this.onCloseClick,
    required this.onSaveClick,
  });

  @override
  State<UpdateStudentActivityWidget> createState() =>
      _UpdateStudentActivityWidgetState();

  static void showBottomSheet(SessionActivityItemUiState uiState, Function(SessionActivityItemUiState) onSaveClick) {
    showAppBottomSheet(
        UpdateStudentActivityWidget(
          uiState: uiState,
          onCloseClick: (){
            Get.back();
          },
          onSaveClick: onSaveClick,
        ), isScrollControlled : true);
  }
}

class _UpdateStudentActivityWidgetState extends State<UpdateStudentActivityWidget> {

  late SessionActivityItemUiState uiState = widget.uiState;

  late final TextEditingController _behaviorNotesEditTextController = TextEditingController(text: uiState.behaviorNotes);
  late final TextEditingController _homeworkNotesEditTextController = TextEditingController(text: uiState.homeworkNotes);

  late bool? attended = widget.uiState.attended ?? true;
  late double? quizGrade = widget.uiState.quizGrade;
  late StudentBehaviorEnum? behaviorStatus = widget.uiState.behaviorStatus ?? StudentBehaviorEnum.GOOD;
  late HomeworkEnum? homeworkStatus = widget.uiState.homeworkStatus ?? HomeworkEnum.FULLY_DONE;

  final _imagesRepo = ActivityImagesRepository();
  final _imagePicker = ImagePicker();
  List<ActivityImageModel> _images = [];
  bool _imagesLoading = false;
  final Set<int> _deletingIds = {};
  bool _uploadingImages = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() => _imagesLoading = true);
    try {
      _images = await _imagesRepo.getImages(uiState.activityId);
    } catch (e) {
      appLog('loadImages error: $e');
    }
    if (mounted) setState(() => _imagesLoading = false);
  }

  Future<void> _pickAndUploadImages() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;

    final List<XFile> picked;
    if (source == ImageSource.camera) {
      final photo = await _imagePicker.pickImage(source: ImageSource.camera);
      picked = photo != null ? [photo] : [];
    } else {
      picked = await _imagePicker.pickMultiImage();
    }
    if (picked.isEmpty) return;

    setState(() => _uploadingImages = true);
    try {
      final files = picked.map((x) => File(x.path)).toList();
      final added = await _imagesRepo.addImages(uiState.activityId, files);
      setState(() => _images = [..._images, ...added]);
    } catch (e) {
      showErrorMessage(e.toString());
    }
    if (mounted) setState(() => _uploadingImages = false);
  }

  void _openImageFullScreen(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGalleryViewer(
          imageUrls: _images.map((e) => e.url).toList(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text('camera'.tr),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('gallery'.tr),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteImage(ActivityImageModel image) async {
    showConfirmationMessage(
      AppStringsKeys.areYouSureToDelete.tr,
      () async {
        setState(() => _deletingIds.add(image.id));
        try {
          await _imagesRepo.deleteImage(image.id);
          if (mounted) setState(() => _images.removeWhere((i) => i.id == image.id));
        } catch (e) {
          showErrorMessage(e.toString());
        }
        if (mounted) setState(() => _deletingIds.remove(image.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _title(),
                _suTitle(),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: GestureDetector(
              onPanDown: (v) => KeyboardUtils.hideKeyboard(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _attendance(),
                        _homework(),
                        _behavior(),
                        _grade(),
                      ],
                    ),
                    _imagesSection(),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _saveButton(),
            ),
          ),
        ],
      ),
    );
  }

  _title() {
    return Row(
      children: [
        Expanded(child: Center(child: TitleWidget(AppStringsKeys.updateStudentActivity.tr , textAlign: TextAlign.center))),
        _closeIcon()
      ],
    );
  }

  _attendance() {
    return LabelValueRowWidget(
        label: AppStringsKeys.attendance.tr,
        mainAxisSize: MainAxisSize.min,
        valueWidget: SizedBox(
          child: SwitchButtonWidget(
              value: attended ?? false,
              onChanged: (value) {
                setState(() {
                  attended = value;
                });
              }),
        ));
  }

  _behavior() {
    appLog("_behavior behaviorStatus: $behaviorStatus");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        LabelWidget(AppStringsKeys.behavior.tr),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...StudentBehaviorEnum.values.map((e) {
                return AppRadioWidget(
                  value: e == behaviorStatus,
                  label: e.getString().tr,
                  onChanged: () {
                    setState(() {
                      behaviorStatus = e;
                    });

                  },
                );
              }),
              _behaviorNotes()
            ],
          ),
        )
      ],
    );
  }

  _homework() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        LabelWidget(AppStringsKeys.homework.tr),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...HomeworkEnum.values.map((e) {
                return AppRadioWidget(
                  value: e == homeworkStatus,
                  label: e.getString().tr,
                  onChanged: () {
                    setState(() {
                      homeworkStatus = e;
                    });
                  },
                );
              }),
              _homeworkNotes()
            ],
          ),
        )
      ],
    );
  }

  _grade() {

   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelWidget(AppStringsKeys.score.tr),
        _gradeNotes()
      ],
    );
  }

  _imagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Row(
          children: [
            Expanded(child: LabelWidget('images'.tr)),
            if (_uploadingImages)
              const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              IconButton(
                onPressed: _pickAndUploadImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                color: AppColors.appMainColor,
                tooltip: 'addImages'.tr,
              ),
          ],
        ),
        if (_imagesLoading)
          const Center(child: CircularProgressIndicator())
        else if (_images.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final img = _images[i];
                final isDeleting = _deletingIds.contains(img.id);
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _openImageFullScreen(i),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageLoadNetwork(
                          url: img.url,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isDeleting)
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white)),
                        ),
                      )
                    else
                      Positioned(
                        top: 2, right: 2,
                        child: GestureDetector(
                          onTap: () => _deleteImage(img),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(text: AppStringsKeys.save.tr, onClick: onSaveClick,),
    );
  }

  _behaviorNotes() {
    return AppTextFieldWidget(
        hint: AppStringsKeys.behaviorNotes.tr,
        controller: _behaviorNotesEditTextController);
  }

  _homeworkNotes() {
    return AppTextFieldWidget(
        hint: AppStringsKeys.homeworkNotes.tr,
        controller: _homeworkNotesEditTextController);
  }

  _gradeNotes() {
    return AppTextFieldWidget(
      hint: AppStringsKeys.enterGrade.tr,
      controller: TextEditingController(text: GradeUtils.getGradeFormat(quizGrade)),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        quizGrade = double.tryParse(value ?? "");
      },
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget("/${uiState.sessionQuizGrade}"),
        ],
      ),
    );
  }

  _closeIcon() {
    return InkWell(
        onTap: (){
         widget.onCloseClick();
        },
        child: Icon(Icons.close));
  }

  _suTitle() => Center(child: AppTextWidget(uiState.studentName , style: AppTextStyle.value,));

  onSaveClick() {
    if (quizGrade != null && quizGrade! < 0) {
      showErrorMessage(AppStringsKeys.gradeLessThanZero.tr);
      return;
    }
    final maxGrade = uiState.sessionQuizGrade;
    if (quizGrade != null && maxGrade != null && quizGrade! > maxGrade) {
      showErrorMessage(AppStringsKeys.gradeExceedsMax.trParams({'s': maxGrade.toString()}));
      return;
    }
    widget.onSaveClick(
        uiState.copyWith(
            attended: attended,
            quizGrade: quizGrade,
            behaviorStatus: behaviorStatus,
            homeworkStatus: homeworkStatus,
            behaviorNotes: _behaviorNotesEditTextController.text,
            homeworkNotes: _homeworkNotesEditTextController.text
        )
    );
  }
}
