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
    return Scaffold(
      appBar: AppBar(title: const Text("Study Schedule")),

      body: ListView.builder(
        itemCount: tasks.length,

        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              title: Text(task.topicName),

              leading: Icon(task.isRevision ? Icons.refresh : Icons.book),

              subtitle: Text(
                "${task.subjectName}\n"
                "${task.date.day}/${task.date.month}/${task.date.year}",
              ),

              trailing: Text("${task.allocatedHours}h"),
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
}
