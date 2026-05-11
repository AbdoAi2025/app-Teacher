import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import '../../../../bottomsheets/week_days_selection_bottom_sheet.dart';
import '../create_group_controller.dart';

class AddTimingsStep extends StatelessWidget {
  final CreateGroupController controller;
  final VoidCallback onPrevious;
  final VoidCallback onDone;

  const AddTimingsStep({
    super.key,
    required this.controller,
    required this.onPrevious,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final timings = controller.timings;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: timings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _TimingCard(
                index: i,
                controller: controller,
              ),
            );
          }),
        ),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.addTiming,
                icon: const Icon(Icons.add),
                label: Text('Add Timing'.tr),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final err = controller.stepError.value;
              if (err.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(err,
                    style: const TextStyle(color: Colors.red, fontSize: 13)),
              );
            }),
            Obx(() => controller.isStepLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    spacing: 8,
                    children: [
                      IconButton.outlined(
                        onPressed: onPrevious,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Spacer(),
                      IconButton.outlined(
                        onPressed: onDone,
                        icon: const Icon(Icons.check_rounded),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}

class _TimingCard extends StatelessWidget {
  final int index;
  final CreateGroupController controller;

  const _TimingCard({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final timing = controller.timings[index];
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              children: [
                Text(
                  '${'Timing'.tr} ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => showConfirmationMessage(
                    'Are you sure you want to delete this timing?'.tr,
                    () => controller.removeTiming(index),
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            AppTextFieldWidget(
              controller: TextEditingController(
                  text: timing.day != null
                      ? AppDateUtils.getDayName(timing.day!).tr
                      : ''),
              label: 'Select Day'.tr,
              hint: 'Select Day'.tr,
              readOnly: true,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              onTap: () => _pickDay(context),
            ),
            AppTextFieldWidget(
              controller: TextEditingController(
                  text: controller.getTimeFormat(timing.timeFrom)),
              label: 'Time From'.tr,
              hint: 'Select Time From'.tr,
              readOnly: true,
              prefixIcon: const Icon(Icons.access_time),
              onTap: () => _pickTimeFrom(context),
            ),
            AppTextFieldWidget(
              controller: TextEditingController(
                  text: controller.getTimeFormat(timing.timeTo)),
              label: 'Time To'.tr,
              hint: 'Select Time To'.tr,
              readOnly: true,
              prefixIcon: const Icon(Icons.access_time_outlined),
              onTap: () => _pickTimeTo(context),
            ),
          ],
        ),
      );
    });
  }

  void _pickDay(BuildContext context) {
    WeekDaysSelectionBottomSheet.showBottomSheet(
        (day) => controller.updateTimingDay(index, day));
  }

  Future<void> _pickTimeFrom(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: controller.timings[index].timeFrom ?? TimeOfDay.now(),
    );
    if (picked != null) controller.updateTimingTimeFrom(index, picked);
  }

  Future<void> _pickTimeTo(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: controller.timings[index].timeTo ?? TimeOfDay.now(),
    );
    if (picked != null) controller.updateTimingTimeTo(index, picked);
  }
}