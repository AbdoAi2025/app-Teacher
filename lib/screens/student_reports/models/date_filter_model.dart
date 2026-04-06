import 'package:get/get.dart';

enum DateFilterType {
  teachingYear,
  term,
  customRange
}

enum Term {
  first,
  second
}

class TeachingYear {
  final int startYear;
  final int endYear;

  TeachingYear({required this.startYear, required this.endYear});

  String get displayName => '$startYear-$endYear';

  DateTime get startDate => DateTime(startYear, 8, 1); // August 1st
  DateTime get endDate => DateTime(endYear, 7, 31); // July 31st

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
              ? DateTime(year.startYear, 8, 1) // Aug 1st
              : DateTime(year.endYear, 2, 1), // Feb 1st next year
          endDate: termSelected == Term.first
              ? DateTime(year.endYear, 1, 31) // Jan 31st next year
              : DateTime(year.endYear, 7, 31), // July 31st next year
        );

  DateFilter.customRange(DateTime start, DateTime end)
      : this(
          type: DateFilterType.customRange,
          startDate: start,
          endDate: end,
        );

  String get displayName {
    switch (type) {
      case DateFilterType.teachingYear:
        return '${'Teaching Year'.tr}: ${teachingYear?.displayName}';
      case DateFilterType.term:
        return '${teachingYear?.displayName} - ${"${term == Term.first ? 'First' : 'Second'} Term".tr}';
      case DateFilterType.customRange:
        final startStr = '${startDate?.day}/${startDate?.month}/${startDate?.year}';
        final endStr = '${endDate?.day}/${endDate?.month}/${endDate?.year}';
        return '$startStr - $endStr';
    }
  }

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
    final currentTeachingYear = currentMonth >= 8
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

    return currentMonth >= 8
        ? TeachingYear(startYear: currentYear, endYear: currentYear + 1)
        : TeachingYear(startYear: currentYear - 1, endYear: currentYear);
  }

  static Term? getCurrentTerm() {
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;

    if (currentMonth >= 8 || currentMonth == 1) {
      return Term.first;
    } else if (currentMonth >= 2 && currentMonth <= 7) {
      return Term.second;
    }

    return null;
  }
}