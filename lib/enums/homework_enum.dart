
import 'dart:ui';

import '../themes/app_colors.dart';

enum HomeworkEnum {
    FULLY_DONE,
    INCOMPLETE,
    NOT_DONE;
}


extension HomeworkEnumStatusExtension on int? {
    HomeworkEnum? toHomeworkEnum() {
        return switch (this) {
            0 => HomeworkEnum.FULLY_DONE,
            1 => HomeworkEnum.INCOMPLETE,
            _ => HomeworkEnum.NOT_DONE
        };
    }
}



extension HomeworkEnumExtension on HomeworkEnum?{

    String getString(){
        return switch(this){
            HomeworkEnum.FULLY_DONE => "Fully Done",
            HomeworkEnum.INCOMPLETE => "Incompleted",
           _ => "Not Done",
        };
    }


    Color getColor() {
        return switch (this) {
            HomeworkEnum.FULLY_DONE => AppColors.color_008E73,
            HomeworkEnum.INCOMPLETE => AppColors.colorHomeworkStatusMissing,
            _ => AppColors.colorNo
        };
    }
}