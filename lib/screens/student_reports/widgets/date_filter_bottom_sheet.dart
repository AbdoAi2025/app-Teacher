import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import '../models/date_filter_model.dart';

class DateFilterBottomSheet extends StatefulWidget {
  final DateFilter currentFilter;
  final Function(DateFilter) onFilterApplied;

  const DateFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterApplied,
  });

  @override
  State<DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();

  static void show({
    required BuildContext context,
    required DateFilter currentFilter,
    required Function(DateFilter) onFilterApplied,
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
          child: DateFilterBottomSheet(
            currentFilter: currentFilter,
            onFilterApplied: onFilterApplied,
          ),
        ),
      ),
    );
  }
}

class _DateFilterBottomSheetState extends State<DateFilterBottomSheet> {
  late DateFilterType selectedType;
  TeachingYear? selectedTeachingYear;
  Term? selectedTerm;
  DateTime? customStartDate;
  DateTime? customEndDate;

  final List<TeachingYear> availableYears = DateFilterHelper.generateAvailableYears();

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentFilter();
  }

  void _initializeFromCurrentFilter() {
    selectedType = widget.currentFilter.type;
    selectedTeachingYear = widget.currentFilter.teachingYear;
    selectedTerm = widget.currentFilter.term;
    customStartDate = widget.currentFilter.startDate;
    customEndDate = widget.currentFilter.endDate;

    // Set default teaching year if none selected
    if (selectedTeachingYear == null && availableYears.isNotEmpty) {
      selectedTeachingYear = DateFilterHelper.getCurrentTeachingYear();
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterTypeSection(),
                  SizedBox(height: 20),
                  if (selectedType == DateFilterType.teachingYear ||
                      selectedType == DateFilterType.term)
                    _buildTeachingYearSection(),
                  if (selectedType == DateFilterType.term)
                    _buildTermSection(),
                  if (selectedType == DateFilterType.customRange)
                    _buildCustomRangeSection(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: AppTextWidget(
            'Filter by Date'.tr,
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

  Widget _buildFilterTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(
          'Filter Type'.tr,
          style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        _buildFilterTypeOption(DateFilterType.teachingYear, 'Teaching Year'.tr),
        _buildFilterTypeOption(DateFilterType.term, 'Term'.tr),
        _buildFilterTypeOption(DateFilterType.customRange, 'Custom Range'.tr),
      ],
    );
  }

  Widget _buildFilterTypeOption(DateFilterType type, String title) {
    return RadioListTile<DateFilterType>(
      title: AppTextWidget(title, style: AppTextStyle.label),
      value: type,
      groupValue: selectedType,
      onChanged: (value) {
        setState(() {
          selectedType = value!;
          // Reset dependent values when type changes
          if (type != DateFilterType.term) {
            selectedTerm = null;
          }
          if (type != DateFilterType.customRange) {
            customStartDate = null;
            customEndDate = null;
          }
        });
      },
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.appMainColor,
    );
  }

  Widget _buildTeachingYearSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        AppTextWidget(
          'Select Teaching Year'.tr,
          style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.color_DBD5CC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TeachingYear>(
              value: selectedTeachingYear,
              hint: AppTextWidget('Select Year'.tr, style: AppTextStyle.label),
              items: availableYears.map((year) {
                return DropdownMenuItem<TeachingYear>(
                  value: year,
                  child: AppTextWidget(year.displayName, style: AppTextStyle.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTeachingYear = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        AppTextWidget(
          'Select Term'.tr,
          style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTermOption(Term.first, 'First Term'.tr, 'Aug - Jan'.tr),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildTermOption(Term.second, 'Second Term'.tr, 'Feb - Jul'.tr),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermOption(Term term, String title, String subtitle) {
    final isSelected = selectedTerm == term;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTerm = term;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appMainColor.withOpacity(0.1) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.appMainColor : AppColors.color_DBD5CC,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AppTextWidget(
              title,
              style: AppTextStyle.title.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.appMainColor : AppColors.colorBlack,
              ),
            ),
            SizedBox(height: 4),
            AppTextWidget(
              subtitle,
              style: AppTextStyle.subTitle.copyWith(
                color: isSelected ? AppColors.appMainColor : AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        AppTextWidget(
          'Custom Date Range'.tr,
          style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDatePicker('From Date'.tr, customStartDate, (date) {
              setState(() {
                customStartDate = date;
              });
            })),
            SizedBox(width: 12),
            Expanded(child: _buildDatePicker('To Date'.tr, customEndDate, (date) {
              setState(() {
                customEndDate = date;
              });
            })),
          ],
        ),
        if (customStartDate != null && customEndDate != null &&
            customEndDate!.isBefore(customStartDate!))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AppTextWidget(
              'End date must be after start date'.tr,
              style: AppTextStyle.teshrinArLtRegular.copyWith(color: AppColors.colorNo),
            ),
          ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget(label, style: AppTextStyle.label),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.color_DBD5CC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppTextWidget(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Select Date'.tr,
                    style: AppTextStyle.label.copyWith(
                      color: selectedDate != null ? AppColors.colorBlack : AppColors.textSecondaryColor,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColors.textSecondaryColor, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: PrimaryButtonWidget(
            text: 'Apply Filter'.tr,
            onClick: _applyFilter,
            enabled: _isFilterValid(),
          ),
        ),

        TextButton(
          onPressed: _clearFilter,
          child: AppTextWidget(
            'Clear Filter'.tr,
            style: AppTextStyle.teshrinArLtRegular.copyWith(color: AppColors.textSecondaryColor),
          ),
        ),
      ],
    );
  }

  bool _isFilterValid() {
    switch (selectedType) {
      case DateFilterType.teachingYear:
        return selectedTeachingYear != null;
      case DateFilterType.term:
        return selectedTeachingYear != null && selectedTerm != null;
      case DateFilterType.customRange:
        return customStartDate != null &&
               customEndDate != null &&
               !customEndDate!.isBefore(customStartDate!);
    }
  }

  void _applyFilter() {
    if (!_isFilterValid()) return;

    DateFilter filter;

    switch (selectedType) {
      case DateFilterType.teachingYear:
        filter = DateFilter.teachingYear(selectedTeachingYear!);
        break;
      case DateFilterType.term:
        filter = DateFilter.term(selectedTeachingYear!, selectedTerm!);
        break;
      case DateFilterType.customRange:
        filter = DateFilter.customRange(customStartDate!, customEndDate!);
        break;
    }

    widget.onFilterApplied(filter);
    Get.back();
  }

  void _clearFilter() {
    // Reset to current teaching year instead of "all"
    widget.onFilterApplied(DateFilter.teachingYear(DateFilterHelper.getCurrentTeachingYear()));
    Get.back();
  }
}