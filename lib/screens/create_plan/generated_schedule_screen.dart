import 'package:flutter/material.dart';
import '../../models/daily_task_model.dart';
import '../dashboard/dashboard_screen.dart';

class GeneratedScheduleScreen extends StatelessWidget {
  final List<DailyTaskModel> tasks;
  final String examName;
  final DateTime examDate;

  const GeneratedScheduleScreen({
    super.key,
    required this.tasks,
    required this.examName,
    required this.examDate,
  });

  @override
  Widget build(BuildContext context) {
    final groupedTasks = groupTasksByDate();

    final dates = groupedTasks.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Study Schedule")),

      body: ListView.builder(
        itemCount: dates.length,

        itemBuilder: (context, index) {
          final date = dates[index];

          final dayTasks = groupedTasks[date]!;

          return Card(
            margin: const EdgeInsets.all(10),

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "📅 $date",

                    style: const TextStyle(
                      fontSize: 18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(),

                  ...dayTasks.map((task) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: Icon(
                        task.isRevision ? Icons.refresh : Icons.book,
                      ),

                      title: Text(task.topicName),

                      subtitle: Text(task.subjectName),

                      trailing: Text("${task.allocatedHours}h"),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                examName: examName,
                examDate: examDate,
                tasks: tasks,
              ),
            ),
          );
        },
        label: const Text("Dashboard"),
      ),
    );
  }

  Map<String, List<DailyTaskModel>> groupTasksByDate() {
    final Map<String, List<DailyTaskModel>> grouped = {};

    for (final task in tasks) {
      final key =
          "${task.date.day}/"
          "${task.date.month}/"
          "${task.date.year}";

      grouped.putIfAbsent(key, () => []);

      grouped[key]!.add(task);
    }

    return grouped;
  }
}
