class AcademicDateRange {
  const AcademicDateRange({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}

class AcademicCycle {
  const AcademicCycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.firstHalfEndDate,
    required this.secondHalfStartDate,
    required this.firstHalfPlatformTests,
    required this.firstHalfPresentialTests,
    required this.secondHalfPlatformTests,
    required this.secondHalfPresentialTests,
    this.recessTime = '11:20',
    this.specialTestRanges = const {},
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime firstHalfEndDate;
  final DateTime secondHalfStartDate;
  final AcademicDateRange firstHalfPlatformTests;
  final AcademicDateRange firstHalfPresentialTests;
  final AcademicDateRange secondHalfPlatformTests;
  final AcademicDateRange secondHalfPresentialTests;
  final String recessTime;
  final Map<String, AcademicDateRange> specialTestRanges;
}
