import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'info_chip_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SessionsCountInfoChipWidget extends StatelessWidget {
  final int count;

  const SessionsCountInfoChipWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return InfoChipWidget(
      text: "$count ${AppStringsKeys.sessions.tr}",
      icon: Icons.menu_book_outlined,
    );
  }
}