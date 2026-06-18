import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../create_group_controller.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class GroupStepIndicator extends StatelessWidget {
  final CreateGroupController controller;

  const GroupStepIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            _stepCircle(context, 0, AppStringsKeys.groupInfo.tr, step),
            _stepLine(context, step > 0),
            _stepCircle(context, 1, AppStringsKeys.students.tr, step),
            _stepLine(context, step > 1),
            _stepCircle(context, 2, AppStringsKeys.timings.tr, step),
          ],
        ),
      );
    });
  }

  Widget _stepCircle(BuildContext context, int index, String label, int current) {
    final isDone = current > index;
    final isActive = current == index;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone || isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[500],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine(BuildContext context, bool completed) {
    return Container(
      height: 2,
      width: 24,
      margin: const EdgeInsets.only(bottom: 20),
      color: completed ? Theme.of(context).primaryColor : Colors.grey[300],
    );
  }
}