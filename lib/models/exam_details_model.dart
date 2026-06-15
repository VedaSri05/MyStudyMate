class ExamDetailsModel {

  final String examName;
  final DateTime examDate;
  final int weekdayHours;
  final int weekendHours;

  final List<DateTime> blockedDates;

  ExamDetailsModel({
    required this.examName,
    required this.examDate,
    required this.weekdayHours,
    required this.weekendHours,
    this.blockedDates = const [],
  });
}