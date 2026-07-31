import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

enum DateFilterType {
  all,
  teachingYear,
  term,
  customRange
}

enum Term {
  first,
  second
}

class TeachingYearConfig {
  static const int yearStartMonth = 7;  // July
  static const int yearStartDay   = 1;
  static const int yearEndMonth   = 6;  // June
  static const int yearEndDay     = 30;
  static const int term2StartMonth = 2; // February
  static const int term1EndMonth   = 1; // January
  static const int term1EndDay     = 31;
}

class TeachingYear {
  final int startYear;
  final int endYear;

  TeachingYear({required this.startYear, required this.endYear});

  String get displayName => '$startYear-$endYear';

  DateTime get startDate => DateTime(startYear, TeachingYearConfig.yearStartMonth, TeachingYearConfig.yearStartDay);
  DateTime get endDate => DateTime(endYear, TeachingYearConfig.yearEndMonth, TeachingYearConfig.yearEndDay);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeachingYear &&
          runtimeType == other.runtimeType &&
          startYear == other.startYear &&
          endYear == other.endYear;

  @override
  int get hashCode => startYear.hashCode ^ endYear.hashCode;

  @override
  String toString() => displayName;
}

class DateFilter {
  final DateFilterType type;
  final TeachingYear? teachingYear;
  final Term? term;
  final DateTime? startDate;
  final DateTime? endDate;

  DateFilter({
    required this.type,
    this.teachingYear,
    this.term,
    this.startDate,
    this.endDate,
  });


  DateFilter.teachingYear(TeachingYear year)
      : this(
          type: DateFilterType.teachingYear,
          teachingYear: year,
          startDate: year.startDate,
          endDate: year.endDate,
        );

  DateFilter.term(TeachingYear year, Term termSelected)
      : this(
          type: DateFilterType.term,
          teachingYear: year,
          term: termSelected,
          startDate: termSelected == Term.first
              ? DateTime(year.startYear, TeachingYearConfig.yearStartMonth, TeachingYearConfig.yearStartDay)
              : DateTime(year.endYear, TeachingYearConfig.term2StartMonth, 1),
          endDate: termSelected == Term.first
              ? DateTime(year.endYear, TeachingYearConfig.term1EndMonth, TeachingYearConfig.term1EndDay)
              : DateTime(year.endYear, TeachingYearConfig.yearEndMonth, TeachingYearConfig.yearEndDay),
        );

  DateFilter.customRange(DateTime start, DateTime end)
      : this(
          type: DateFilterType.customRange,
          startDate: start,
          endDate: end,
        );

  DateFilter.all()
      : this(
          type: DateFilterType.all,
        );

  String get displayName {
    switch (type) {
      case DateFilterType.all:
        return AppStringsKeys.all.tr;
      case DateFilterType.teachingYear:
        return '${AppStringsKeys.teachingYear.tr}: ${teachingYear?.displayName}';
      case DateFilterType.term:
        return '${teachingYear?.displayName} - ${"${term == Term.first ? 'First' : 'Second'} Term".tr}';
      case DateFilterType.customRange:
        final startStr = '${startDate?.day}/${startDate?.month}/${startDate?.year}';
        final endStr = '${endDate?.day}/${endDate?.month}/${endDate?.year}';
        return '$startStr - $endStr';
    }
  }

  String? get dateFromFormatted => startDate != null && type != DateFilterType.all ? DateFormat('yyyy-MM-dd').format(startDate!) : null;
  String? get dateToFormatted => endDate != null && type != DateFilterType.all ? DateFormat('yyyy-MM-dd').format(endDate!) : null;

  bool get hasDateRange => startDate != null && endDate != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateFilter &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          teachingYear == other.teachingYear &&
          term == other.term &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      type.hashCode ^
      teachingYear.hashCode ^
      term.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
}

class DateFilterHelper {
  static List<TeachingYear> generateAvailableYears({int yearsBack = 5, int yearsForward = 1}) {
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;
    final currentMonth = currentDate.month;

    // Determine the current teaching year
    final currentTeachingYear = currentMonth >= TeachingYearConfig.yearStartMonth
        ? TeachingYear(startYear: currentYear, endYear: currentYear + 1)
        : TeachingYear(startYear: currentYear - 1, endYear: currentYear);

    final years = <TeachingYear>[];

    // Generate years from past to future
    for (int i = yearsBack; i >= -yearsForward; i--) {
      final startYear = currentTeachingYear.startYear - i;
      final endYear = currentTeachingYear.endYear - i;
      years.add(TeachingYear(startYear: startYear, endYear: endYear));
    }

    return years;
  }

  static TeachingYear getCurrentTeachingYear() {
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;
    final currentMonth = currentDate.month;

    return currentMonth >= TeachingYearConfig.yearStartMonth
        ? TeachingYear(startYear: currentYear, endYear: currentYear + 1)
        : TeachingYear(startYear: currentYear - 1, endYear: currentYear);
  }

  static Term? getCurrentTerm() {
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;

    if (currentMonth >= TeachingYearConfig.yearStartMonth || currentMonth == TeachingYearConfig.term1EndMonth) {
      return Term.first;
    } else if (currentMonth >= TeachingYearConfig.term2StartMonth && currentMonth < TeachingYearConfig.yearStartMonth) {
      return Term.second;
    }

    return null;
  }
}
