import 'package:flutter/material.dart';
import '../../models/daily_task_model.dart';
import '../study_timer/study_timer_screen.dart';
import '../../services/local_storage_service.dart';
import '../../services/planner_service.dart';
import '../welcome/welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String examName;
  final DateTime examDate;
  final List<DailyTaskModel> tasks;

  const DashboardScreen({
    super.key,
    required this.examName,
    required this.examDate,
    required this.tasks,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<DailyTaskModel> tasks;
  List<String> completedTopicNames = [];
  final LocalStorageService storage = LocalStorageService();
  final PlannerService plannerService = PlannerService();

  List<DailyTaskModel> get todaysTasks {
    final now = DateTime.now();

    return tasks.where((task) {
      return task.date.day == now.day &&
          task.date.month == now.month &&
          task.date.year == now.year;
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    tasks = widget.tasks;

    for (int i = 0; i < tasks.length; i++) {
      if (completedTopicNames.contains(tasks[i].topicName)) {
        tasks[i] = DailyTaskModel(
          date: tasks[i].date,
          topicName: tasks[i].topicName,
          subjectName: tasks[i].subjectName,
          allocatedHours: tasks[i].allocatedHours,
          totalTopicHours: tasks[i].totalTopicHours,
          isCompleted: true,
        );
      }
    }

    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final examName = await storage.getExamName();

    final examDate = await storage.getExamDate();

    completedTopicNames = await storage.getCompletedTopics();

    setState(() {});

    debugPrint("Saved Exam: $examName");

    debugPrint("Saved Date: $examDate");
  }

  int get completedTasks {
    return tasks
        .where(
          (task) =>
              task.isCompleted || completedTopicNames.contains(task.topicName),
        )
        .length;
  }

  int get totalTasks {
    return tasks.length;
  }

  int get daysLeft {
    return widget.examDate.difference(DateTime.now()).inDays + 1;
  }

  double get progress {
    if (totalTasks == 0) return 0;
    return completedTasks / totalTasks;
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index] = DailyTaskModel(
        date: tasks[index].date,
        topicName: tasks[index].topicName,
        subjectName: tasks[index].subjectName,
        allocatedHours: tasks[index].allocatedHours,
        totalTopicHours: tasks[index].totalTopicHours,
        isCompleted: !tasks[index].isCompleted,
        isRevision: tasks[index].isRevision,
      );
    });
    saveCompletionStatus();
  }

  Future<void> saveCompletionStatus() async {
    final completedTopics = tasks
        .where((task) => task.isCompleted)
        .map((task) => task.topicName)
        .toList();

    await storage.saveCompletedTopics(completedTopics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StudyFlow AI"),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,

                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        ListTile(
                          leading: const Icon(Icons.delete),

                          title: const Text("Delete Current Plan"),

                          onTap: () async {
                            await storage.clearStudyPlan();

                            if (!mounted) return;

                            Navigator.pop(context);

                            Navigator.pushAndRemoveUntil(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const WelcomeScreen(),
                              ),

                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.blue),
                title: Text(widget.examName),
                subtitle: Text("$daysLeft days left"),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Progress",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(value: progress),

                    const SizedBox(height: 10),

                    Text("$completedTasks / $totalTasks tasks completed"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (todaysTasks.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.celebration),

                  title: Text("No tasks today"),

                  subtitle: Text("Enjoy your free time 🎉"),
                ),
              )
            else
              ...todaysTasks.asMap().entries.map((entry) {
                final index = tasks.indexOf(entry.value);

                final task = entry.value;

                return Card(
                  child: CheckboxListTile(
                    value:
                        task.isCompleted ||
                        completedTopicNames.contains(task.topicName),

                    onChanged: (_) {
                      toggleTask(index);
                    },

                    title: Text(task.topicName),

                    subtitle: Text(
                      "${task.subjectName} • ${task.allocatedHours}h",
                    ),
                  ),
                );
              }),

            const SizedBox(height: 20),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudyTimerScreen(),
                    ),
                  );
                },
                child: const Text("Start Study Session"),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    tasks = plannerService.replanMissedTasks(tasks);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tasks replanned successfully"),
                    ),
                  );
                },
                child: const Text("I Was Busy Today"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
