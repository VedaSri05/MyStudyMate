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
    required List<DateTime> blockedDates,
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
        if (isBlockedDate(currentDate, blockedDates)) {
          currentDate = currentDate.add(const Duration(days: 1));

          final isWeekend =
              currentDate.weekday == DateTime.saturday ||
              currentDate.weekday == DateTime.sunday;

          remainingDayHours = isWeekend ? weekendHours : weekdayHours;

          continue;
        }
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
      blockedDates: blockedDates,
    );

    final extraHours = totalAvailableHours - totalRequiredHours;

    if (extraHours <= 0) {
      return tasks;
    }

    if (remainingDayHours > 0 &&
        currentDate.isBefore(examDate.subtract(const Duration(days: 1)))) {
      tasks.add(
        DailyTaskModel(
          date: currentDate,

          topicName: "Revision Session 1",

          subjectName: "Revision",

          allocatedHours: remainingDayHours,

          totalTopicHours: remainingDayHours,

          isRevision: true,
        ),
      );
    }

    final finalRevisionDate = findPreviousAvailableDate(
      examDate.subtract(const Duration(days: 1)),
      blockedDates,
    );

    DateTime? actualFinalRevisionDate = finalRevisionDate;

    DateTime revisionDate = currentDate;

    final finalRevisionIsWeekend =
        finalRevisionDate.weekday == DateTime.saturday ||
        finalRevisionDate.weekday == DateTime.sunday;

    int finalRevisionHours = finalRevisionIsWeekend
        ? weekendHours
        : weekdayHours;

    if (actualFinalRevisionDate == currentDate) {
      finalRevisionHours = remainingDayHours;
    }

    if (extraHours > 0) {
      revisionDate = currentDate.add(const Duration(days: 1));

      final finalRevisionReservedHours = finalRevisionHours;

      int remainingRevisionHours = extraHours - finalRevisionReservedHours;

      if (remainingRevisionHours < 0) {
        remainingRevisionHours = 0;
      }

      int revisionNumber = 1;

      while (remainingRevisionHours > 0 &&
          revisionDate.isBefore(finalRevisionDate)) {
        if (isBlockedDate(revisionDate, blockedDates)) {
          revisionDate = revisionDate.add(const Duration(days: 1));

          continue;
        }
        final isWeekend =
            revisionDate.weekday == DateTime.saturday ||
            revisionDate.weekday == DateTime.sunday;

        final dayCapacity = isWeekend ? weekendHours : weekdayHours;

        int revisionHours = remainingRevisionHours > dayCapacity
            ? dayCapacity
            : remainingRevisionHours;

        if (revisionHours <= 0) {
          break;
        }

        tasks.add(
          DailyTaskModel(
            date: revisionDate,

            topicName: "Revision Session $revisionNumber",

            subjectName: "Revision",

            allocatedHours: revisionHours,

            totalTopicHours: revisionHours,

            isRevision: true,
          ),
        );

        remainingRevisionHours -= revisionHours;

        revisionNumber++;

        revisionDate = revisionDate.add(const Duration(days: 1));
      }
    }

    if (actualFinalRevisionDate.year == currentDate.year &&
        actualFinalRevisionDate.month == currentDate.month &&
        actualFinalRevisionDate.day == currentDate.day) {
      finalRevisionHours = remainingDayHours;
    }

    tasks.add(
      DailyTaskModel(
        date: actualFinalRevisionDate,

        topicName: "Final Revision + Mock Test",

        subjectName: "Revision",

        allocatedHours: finalRevisionHours,

        totalTopicHours: finalRevisionHours,

        isRevision: true,
      ),
    );

    return tasks;
  }

  int calculateAvailableHours({
    required DateTime examDate,
    required int weekdayHours,
    required int weekendHours,
    required List<DateTime> blockedDates,
  }) {
    DateTime currentDate = DateTime.now();

    int totalAvailableHours = 0;

    while (currentDate.isBefore(examDate)) {
      if (isBlockedDate(currentDate, blockedDates)) {
        currentDate = currentDate.add(const Duration(days: 1));

        continue;
      }

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

  DateTime findPreviousAvailableDateWithCapacity(
    DateTime date,
    List<DateTime> blockedDates,
    List<DailyTaskModel> tasks,
    int requiredHours,
    int weekdayHours,
    int weekendHours,
  ) {
    DateTime newDate = date;

    while (true) {
      if (isBlockedDate(newDate, blockedDates)) {
        newDate = newDate.subtract(const Duration(days: 1));

        continue;
      }

      final isWeekend =
          newDate.weekday == DateTime.saturday ||
          newDate.weekday == DateTime.sunday;

      final dayCapacity = isWeekend ? weekendHours : weekdayHours;

      final usedHours = tasks
          .where(
            (task) =>
                task.date.year == newDate.year &&
                task.date.month == newDate.month &&
                task.date.day == newDate.day,
          )
          .fold(0, (sum, task) => sum + task.allocatedHours);

      final freeHours = dayCapacity - usedHours;

      if (freeHours >= requiredHours) {
        return newDate;
      }

      newDate = newDate.subtract(const Duration(days: 1));
    }
  }

  DateTime findPreviousAvailableDate(
    DateTime date,
    List<DateTime> blockedDates,
  ) {
    DateTime newDate = date;

    while (isBlockedDate(newDate, blockedDates)) {
      newDate = newDate.subtract(const Duration(days: 1));
    }

    return newDate;
  }

  bool isBlockedDate(DateTime date, List<DateTime> blockedDates) {
    return blockedDates.any(
      (blockedDate) =>
          blockedDate.year == date.year &&
          blockedDate.month == date.month &&
          blockedDate.day == date.day,
    );
  }
}
