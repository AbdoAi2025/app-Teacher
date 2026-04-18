import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/domain/managers/grade_manager.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';

class GradesSelectionBottomSheet extends StatefulWidget {
  final Function(GradeApiModel) onGradeSelected;
  final String? currentGradeId;

  const GradesSelectionBottomSheet({
    super.key,
    required this.onGradeSelected,
    this.currentGradeId,
  });

  @override
  State<GradesSelectionBottomSheet> createState() => _GradesSelectionBottomSheetState();

  static void show({
    required BuildContext context,
    required Function(GradeApiModel) onGradeSelected,
    String? currentGradeId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GradesSelectionBottomSheet(
            onGradeSelected: onGradeSelected,
            currentGradeId: currentGradeId,
          ),
        ),
      ),
    );
  }
}

class _GradesSelectionBottomSheetState extends State<GradesSelectionBottomSheet> {
  final GradeManager _gradeManager = GradeManager();
  final ScrollController _scrollController = ScrollController();
  List<ItemSelectionUiState> _items = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadGrades();

    // Listen to grade manager state changes
    ever(_gradeManager.state, (state) {
      if (state == GradeManagerState.success && mounted) {
        // Reset items to force re-initialization with current grades
        setState(() {
          _items.clear();
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scrollToSelectedItem();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadGrades() {
    if (_gradeManager.grades.isEmpty) {
      _gradeManager.loadGrades();
    } else {
      // If grades are already loaded, trigger scroll immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedItem();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          Expanded(
            child: _buildGradesContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: AppTextWidget(
            'Select Grade'.tr,
            style: AppTextStyle.title.copyWith(fontSize: 18),
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: AppColors.textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildGradesContent() {
    return Obx(() {
      switch (_gradeManager.state.value) {
        case GradeManagerState.loading:
          return Center(child: LoadingWidget());

        case GradeManagerState.error:
          return _buildErrorView();

        case GradeManagerState.success:
          return _buildGradesList();
      }
    });
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondaryColor,
          ),
          SizedBox(height: 16),
          AppTextWidget(
            _gradeManager.errorMessage ?? 'Failed to load grades'.tr,
            style: AppTextStyle.label.copyWith(color: AppColors.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _gradeManager.refresh(),
            child: AppTextWidget('Retry'.tr, style: AppTextStyle.label),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesList() {
    // Only initialize items if they're empty to prevent resetting selections
    if (_items.isEmpty) {
      _items = _gradeManager.getGradeSelectionItems();

      // Mark current grade as selected if provided
      if (widget.currentGradeId != null) {
        for (int i = 0; i < _items.length; i++) {
          if (_items[i].id == widget.currentGradeId) {
            _items[i].isSelected = true;
            _selectedIndex = i;
            break;
          }
        }
      }
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemCount: _items.length,
            separatorBuilder: (context, index) => _buildSeparator(),
            itemBuilder: (context, index) => _buildGradeItem(_items[index], index),
          ),
        ),
        SizedBox(height: 20),
        _buildSelectButton(),
      ],
    );
  }

  Widget _buildGradeItem(ItemSelectionUiState item, int index) {
    return InkWell(
      onTap: () => _onGradeItemTap(item, index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            _buildRadioButton(item),
            SizedBox(width: 16),
            Expanded(
              child: AppTextWidget(
                item.name,
                style: AppTextStyle.label.copyWith(
                  color: item.isSelected ? AppColors.appMainColor : AppColors.colorBlack,
                  fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(ItemSelectionUiState item) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: item.isSelected ? AppColors.appMainColor : AppColors.color_DBD5CC,
          width: 2,
        ),
      ),
      child: item.isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appMainColor,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 0.5,
      color: AppColors.color_DBD5CC,
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: 'Select'.tr,
        onClick: _onSelectButtonTap,
        enabled: _items.any((item) => item.isSelected),
      ),
    );
  }

  void _onGradeItemTap(ItemSelectionUiState item, int index) {
    setState(() {
      // Clear previous selection
      for (var existingItem in _items) {
        existingItem.isSelected = false;
      }
      // Set new selection
      item.isSelected = true;
      _selectedIndex = index;
    });
  }

  void _onSelectButtonTap() {
    final selectedItem = _items.where((item) => item.isSelected).firstOrNull;
    if (selectedItem != null) {
      final grade = _gradeManager.findGradeById(selectedItem.id);
      if (grade != null) {
        widget.onGradeSelected(grade);
        Get.back();
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedIndex != null && _scrollController.hasClients) {
      const itemHeight = 60.0; // Approximate height of each item + separator
      final scrollOffset = _selectedIndex! * itemHeight;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final viewportHeight = _scrollController.position.viewportDimension;

      // Only scroll if the selected item is not visible
      if (scrollOffset > viewportHeight || scrollOffset < 0) {
        final targetOffset = (scrollOffset - viewportHeight / 2).clamp(0.0, maxScrollExtent);

        _scrollController.animateTo(
          targetOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}