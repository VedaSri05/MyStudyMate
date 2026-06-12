class DailyTaskModel {
  final DateTime date;

  final String topicName;

  final String subjectName;

  final int allocatedHours;

  final int totalTopicHours;

  final bool isCompleted;

  final bool isRevision;

  DailyTaskModel({
    required this.date,
    required this.topicName,
    required this.subjectName,
    required this.allocatedHours,
    required this.totalTopicHours,
    this.isCompleted = false,
    this.isRevision = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'topicName': topicName,
      'subjectName': subjectName,
      'allocatedHours': allocatedHours,
      'totalTopicHours': totalTopicHours,
      'isCompleted': isCompleted,
      'isRevision': isRevision,
    };
  }

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      date: DateTime.parse(json['date']),

      topicName: json['topicName'],

      subjectName: json['subjectName'],

      allocatedHours: json['allocatedHours'],

      totalTopicHours: json['totalTopicHours'],

      isCompleted: json['isCompleted'] ?? false,
      isRevision: json['isRevision'] ?? false,
    );
  }
}
