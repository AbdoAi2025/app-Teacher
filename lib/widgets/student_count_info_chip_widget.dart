import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/app_colors.dart';
import 'info_chip_widget.dart';

class StudentCountInfoChipWidget extends StatelessWidget{

  final int count;

  const StudentCountInfoChipWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
   return InfoChipWidget(
     text: "$count ${'Students'.tr}",
     color: null,
     icon: Icons.people_outline,
   );
  }
}
