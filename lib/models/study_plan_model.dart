import 'topic_model.dart';
import 'daily_task_model.dart';

class StudyPlanModel {
  final String planId;

  final DateTime createdAt;

  final String examName;

  final DateTime examDate;

  final int weekdayHours;

  final int weekendHours;

  final List<String> subjects;

  final List<TopicModel> topics;

  final List<DailyTaskModel> tasks;
  final List<DateTime> blockedDates;

  StudyPlanModel({
    required this.planId,
    required this.createdAt,
    required this.examName,
    required this.examDate,
    required this.weekdayHours,
    required this.weekendHours,
    required this.subjects,
    required this.topics,
    required this.tasks,
    required this.blockedDates,
  });

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,

      'createdAt': createdAt.toIso8601String(),

      'examName': examName,

      'examDate': examDate.toIso8601String(),

      'weekdayHours': weekdayHours,

      'weekendHours': weekendHours,

      'subjects': subjects,

      'topics': topics.map((topic) => topic.toJson()).toList(),

      'tasks': tasks.map((task) => task.toJson()).toList(),

      'blockedDates': blockedDates
          .map((date) => date.toIso8601String())
          .toList(),
    };
  }

  factory StudyPlanModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanModel(
      planId: json['planId'],

      createdAt: DateTime.parse(json['createdAt']),

      examName: json['examName'],

      examDate: DateTime.parse(json['examDate']),

      weekdayHours: json['weekdayHours'],

      weekendHours: json['weekendHours'],

      subjects: List<String>.from(json['subjects']),

      topics: (json['topics'] as List)
          .map((topic) => TopicModel.fromJson(topic))
          .toList(),

      tasks: (json['tasks'] as List)
          .map((task) => DailyTaskModel.fromJson(task))
          .toList(),

      blockedDates: (json['blockedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }
}
