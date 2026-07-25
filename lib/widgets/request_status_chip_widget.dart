import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/request_status_enum.dart';

class RequestStatusChipWidget extends StatelessWidget {
  final RequestStatusEnum status;

  const RequestStatusChipWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.labelKey.tr,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}