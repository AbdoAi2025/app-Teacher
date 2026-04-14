import 'package:get/get.dart';
import '../screens/student_reports/models/date_filter_model.dart';

class DateFilterManager extends GetxService {
  static DateFilterManager get instance => Get.find<DateFilterManager>();

  final Rx<DateFilter> _currentDateFilter = Rx<DateFilter>(
    DateFilter.teachingYear(DateFilterHelper.getCurrentTeachingYear())
  );

  DateFilter get currentDateFilter => _currentDateFilter.value;
  Rx<DateFilter> get currentDateFilterRx => _currentDateFilter;

  String get currentFilterDisplayText {
    return _currentDateFilter.value.displayName;
  }

  void applyDateFilter(DateFilter filter) {
    _currentDateFilter.value = filter;
  }

  void resetToCurrentTeachingYear() {
    _currentDateFilter.value = DateFilter.teachingYear(DateFilterHelper.getCurrentTeachingYear());
  }

  bool get hasCustomFilter {
    final currentYear = DateFilterHelper.getCurrentTeachingYear();
    final currentFilter = _currentDateFilter.value;

    if (currentFilter.type == DateFilterType.teachingYear &&
        currentFilter.teachingYear == currentYear) {
      return false;
    }

    return true;
  }
}