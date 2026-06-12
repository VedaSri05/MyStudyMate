import '../models/topic_model.dart';
import '../models/daily_task_model.dart';

class PlannerService {
  int getHoursFromDifficulty(String difficulty) {
    switch (difficulty) {
      case "Very Easy":
        return 1;

      case "Easy":
        return 2;

      case "Moderate":
        return 3;

      case "Medium":
        return 4;

      case "Challenging":
        return 5;

      case "Hard":
        return 6;

      default:
        return 2;
    }
  }

  int calculateTotalRequiredHours(List<TopicModel> topics) {
    int totalHours = 0;

    for (var topic in topics) {
      totalHours += getHoursFromDifficulty(topic.difficulty);
    }

    return totalHours;
  }

  String getRealityCheckStatus({
    required int requiredHours,

    required int availableHours,
  }) {
    if (availableHours >= requiredHours) {
      return "On Track";
    }

    return "Needs Attention";
  }

  List<DailyTaskModel> generateDailyTasks({
    required DateTime examDate,
    required int weekdayHours,
    required int weekendHours,
    required List<TopicModel> topics,
  }) {
    final List<DailyTaskModel> tasks = [];

    DateTime currentDate = DateTime.now();

    int remainingDayHours = 0;

    while (currentDate.isBefore(examDate)) {
      final isWeekend =
          currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday;

      remainingDayHours = isWeekend ? weekendHours : weekdayHours;

      break;
    }

    for (final topic in topics) {
      int totalTopicHours = getHoursFromDifficulty(topic.difficulty);

      int remainingTopicHours = totalTopicHours;

      while (remainingTopicHours > 0 && currentDate.isBefore(examDate)) {
        if (remainingDayHours == 0) {
          currentDate = currentDate.add(const Duration(days: 1));

          final isWeekend =
              currentDate.weekday == DateTime.saturday ||
              currentDate.weekday == DateTime.sunday;

          remainingDayHours = isWeekend ? weekendHours : weekdayHours;
        }

        final allocatedHours = remainingTopicHours < remainingDayHours
            ? remainingTopicHours
            : remainingDayHours;

        tasks.add(
          DailyTaskModel(
            date: currentDate,
            topicName: topic.topicName,
            subjectName: topic.subjectName,
            allocatedHours: allocatedHours,
            totalTopicHours: totalTopicHours,
          ),
        );

        remainingTopicHours -= allocatedHours;

        remainingDayHours -= allocatedHours;
      }
    }

    final totalRequiredHours = calculateTotalRequiredHours(topics);

    final totalAvailableHours = calculateAvailableHours(
      examDate: examDate,
      weekdayHours: weekdayHours,
      weekendHours: weekendHours,
    );

    final extraHours = totalAvailableHours - totalRequiredHours;

    if (extraHours >= 2) {
      tasks.add(
        DailyTaskModel(
          date: examDate.subtract(const Duration(days: 7)),

          topicName: "Revision Session",

          subjectName: "General",

          allocatedHours: 2,

          totalTopicHours: 2,

          isRevision: true,
        ),
      );
    }

    return tasks;
  }

  int calculateAvailableHours({
    required DateTime examDate,
    required int weekdayHours,
    required int weekendHours,
  }) {
    DateTime currentDate = DateTime.now();

    int totalAvailableHours = 0;

    while (currentDate.isBefore(examDate)) {
      bool isWeekend =
          currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday;

      if (isWeekend) {
        totalAvailableHours += weekendHours;
      } else {
        totalAvailableHours += weekdayHours;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return totalAvailableHours;
  }

  String getSuggestion({
    required int requiredHours,
    required int availableHours,
  }) {
    if (availableHours >= requiredHours) {
      return "You have enough time. Use extra hours for revision, mock tests, and weak topic practice.";
    }

    final deficit = requiredHours - availableHours;

    if (deficit <= 10) {
      return "Increase weekday study time slightly to stay on track.";
    }

    if (deficit <= 30) {
      return "Increase weekday and weekend study hours. Prioritize important topics first.";
    }

    return "Current schedule is not sufficient. Increase study hours significantly and focus only on high-priority topics.";
  }

  List<DailyTaskModel> replanMissedTasks(List<DailyTaskModel> tasks) {
    final today = DateTime.now();

    final List<DailyTaskModel> updatedTasks = [];

    for (final task in tasks) {
      if (!task.isCompleted && task.date.isBefore(today)) {
        updatedTasks.add(
          DailyTaskModel(
            date: today.add(const Duration(days: 1)),

            topicName: task.topicName,

            subjectName: task.subjectName,

            allocatedHours: task.allocatedHours,

            totalTopicHours: task.totalTopicHours,

            isCompleted: false,
          ),
        );
      } else {
        updatedTasks.add(task);
      }
    }

    return updatedTasks;
  }
}
