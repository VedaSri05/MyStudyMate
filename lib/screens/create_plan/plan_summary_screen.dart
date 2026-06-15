import 'package:flutter/material.dart';
import '../../services/planner_service.dart';
import '../../models/topic_model.dart';
import 'generated_schedule_screen.dart';
import '../../models/exam_details_model.dart';
import '../../models/study_plan_model.dart';
import '../../services/local_storage_service.dart';

class PlanSummaryScreen extends StatelessWidget {
  final List<TopicModel> topics;
  final ExamDetailsModel examDetails;
  final int totalSubjects;
  final int totalTopics;
  final int totalRequiredHours;
  final int availableHours;
  final String status;

  const PlanSummaryScreen({
    super.key,
    required this.totalSubjects,
    required this.totalTopics,
    required this.totalRequiredHours,
    required this.availableHours,
    required this.status,
    required this.topics,
    required this.examDetails,
  });
  @override
  Widget build(BuildContext context) {
    final plannerService = PlannerService();

    final suggestion = plannerService.getSuggestion(
      requiredHours: totalRequiredHours,

      availableHours: availableHours,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Plan Summary")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Study Plan Summary",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              summaryCard("Total Subjects", totalSubjects.toString()),

              summaryCard("Total Topics", totalTopics.toString()),

              summaryCard(
                "Required Study Hours",
                totalRequiredHours.toString(),
              ),

              summaryCard("Available Hours", availableHours.toString()),

              if (availableHours > totalRequiredHours)
                summaryCard(
                  "Revision Time Available",
                  "${availableHours - totalRequiredHours} hr(s)",
                ),

              summaryCard("Preparation Status", status),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Suggestion",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(suggestion),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () async {
                    final plannerService = PlannerService();

                    if (availableHours <= 0) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Plan Cannot Be Generated"),

                            content: const Text(
                              "All available study days are blocked.\n\nPlease leave at least one day for preparation.",
                            ),

                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );

                      return;
                    }

                    final storage = LocalStorageService();

                    if (availableHours < totalRequiredHours) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Plan Not Possible"),

                            content: const Text(
                              "Required study hours exceed available hours.\n\nRemove some topics and try again.",
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );

                      return;
                    }

                    final tasks = plannerService.generateDailyTasks(
                      examDate: examDetails.examDate,

                      weekdayHours: examDetails.weekdayHours,

                      weekendHours: examDetails.weekendHours,

                      topics: topics,

                      blockedDates: examDetails.blockedDates,
                    );
                    final studyPlan = StudyPlanModel(
                      planId: DateTime.now().millisecondsSinceEpoch.toString(),

                      createdAt: DateTime.now(),

                      examName: examDetails.examName,

                      examDate: examDetails.examDate,

                      weekdayHours: examDetails.weekdayHours,

                      weekendHours: examDetails.weekendHours,

                      subjects: topics
                          .map((topic) => topic.subjectName)
                          .toSet()
                          .toList(),

                      topics: topics,

                      tasks: tasks,
                    );

                    await storage.saveStudyPlan(studyPlan);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneratedScheduleScreen(
                          tasks: tasks,
                          examName: examDetails.examName,
                          examDate: examDetails.examDate,
                        ),
                      ),
                    );
                  },

                  child: const Text("Continue"),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Modify Plan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
