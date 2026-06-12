class ExamDetailsModel {

  final String examName;

  final DateTime examDate;

  final int weekdayHours;

  final int weekendHours;

  ExamDetailsModel({
    required this.examName,
    required this.examDate,
    required this.weekdayHours,
    required this.weekendHours,
  });
}