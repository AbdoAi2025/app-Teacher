import 'package:get/get.dart';
import '../screens/student_reports/models/date_filter_model.dart';
import '../domain/groups/groups_managers.dart';

class DateFilterManager {

  Function()? onFilterChanged;

  DateFilterManager({this.onFilterChanged});

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
    _onDateFilterChanged();
  }

  void resetToCurrentTeachingYear() {
    _currentDateFilter.value = DateFilter.teachingYear(DateFilterHelper.getCurrentTeachingYear());
    _onDateFilterChanged();
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

  void _onDateFilterChanged() {
    if (onFilterChanged != null) {
      onFilterChanged!();
    }
  }
}