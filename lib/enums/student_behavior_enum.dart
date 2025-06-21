import 'dart:ui';

import 'package:teacher_app/themes/app_colors.dart';

enum StudentBehaviorEnum {
  GOOD,
  ACCEPTABLE,
  BAD;
}

extension StudentBehaviorStatusExtension on int? {
  StudentBehaviorEnum? toBehaviorEnum() {
    return switch (this) {
      0 => StudentBehaviorEnum.GOOD,
      1 => StudentBehaviorEnum.ACCEPTABLE,
      2 => StudentBehaviorEnum.BAD,
      _ => null
    };
  }
}

extension StudentBehaviorEnumExtension on StudentBehaviorEnum? {
  String getString() {
    return switch (this) {
      StudentBehaviorEnum.ACCEPTABLE => "Acceptable",
      StudentBehaviorEnum.BAD => "Poor",
      _ =>"Good"
    };
  }

  Color getColor() {
    return switch (this) {
      StudentBehaviorEnum.ACCEPTABLE => AppColors.colorBehaviorStatusAcceptable,
      StudentBehaviorEnum.BAD => AppColors.colorNo,
      _ => AppColors.colorYes
    };
  }
}
