import 'package:flutter/material.dart';
import '../../models/topic_model.dart';
import '../../services/planner_service.dart';
import 'plan_summary_screen.dart';
import '../../models/exam_details_model.dart';
import '../../services/local_storage_service.dart';

class AddTopicsScreen extends StatefulWidget {
  final List<String> subjects;

  final ExamDetailsModel examDetails;

  const AddTopicsScreen({
    super.key,
    required this.subjects,
    required this.examDetails,
  });

  @override
  State<AddTopicsScreen> createState() => _AddTopicsScreenState();
}

class _AddTopicsScreenState extends State<AddTopicsScreen> {
  final LocalStorageService storage = LocalStorageService();
  final PlannerService plannerService = PlannerService();
  final List<TopicModel> topics = [];
  final Map<String, FocusNode> topicFocusNodes = {};

  final Map<String, TextEditingController> topicControllers = {};

  final Map<String, String> selectedDifficulty = {};

  @override
  void showDeleteDialog(TopicModel topic) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Topic"),

          content: Text("Delete '${topic.topicName}'?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  topics.remove(topic);
                });

                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void editTopicDialog(TopicModel topic) {
    final controller = TextEditingController(text: topic.topicName);

    String difficulty = topic.difficulty;

    showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Topic"),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: controller,

                    decoration: const InputDecoration(labelText: "Topic Name"),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: difficulty,

                    items: const [
                      DropdownMenuItem(
                        value: "Very Easy",
                        child: Text("Very Easy (1h)"),
                      ),

                      DropdownMenuItem(value: "Easy", child: Text("Easy (2h)")),

                      DropdownMenuItem(
                        value: "Moderate",
                        child: Text("Moderate (3h)"),
                      ),

                      DropdownMenuItem(
                        value: "Medium",
                        child: Text("Medium (4h)"),
                      ),

                      DropdownMenuItem(
                        value: "Challenging",
                        child: Text("Challenging (5h)"),
                      ),

                      DropdownMenuItem(value: "Hard", child: Text("Hard (6h)")),
                    ],

                    onChanged: (value) {
                      setDialogState(() {
                        difficulty = value!;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                TextButton(
                  onPressed: () {
                    final index = topics.indexOf(topic);

                    setState(() {
                      topics[index] = TopicModel(
                        subjectName: topic.subjectName,

                        topicName: controller.text,

                        difficulty: difficulty,
                      );
                    });

                    Navigator.pop(context);
                  },

                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    for (var subject in widget.subjects) {
      topicControllers[subject] = TextEditingController();
      topicFocusNodes[subject] = FocusNode();

      selectedDifficulty[subject] = "Easy";
    }
  }

  void addTopic(String subject) {
    final topicName = topicControllers[subject]!.text.trim();

    if (topicName.isEmpty) return;

    setState(() {
      topics.add(
        TopicModel(
          subjectName: subject,
          topicName: topicName,
          difficulty: selectedDifficulty[subject]!,
        ),
      );

      topicControllers[subject]!.clear();
      topicFocusNodes[subject]!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Topics")),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          ...widget.subjects.map((subject) {
            final subjectTopics = topics
                .where((topic) => topic.subjectName == subject)
                .toList();

            return Card(
              margin: const EdgeInsets.only(bottom: 20),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: topicControllers[subject],
                      focusNode: topicFocusNodes[subject],
                      textInputAction: TextInputAction.done,

                      onSubmitted: (_) {
                        addTopic(subject);
                      },

                      decoration: const InputDecoration(
                        labelText: "Topic Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      initialValue: selectedDifficulty[subject],

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: "Very Easy",
                          child: Text("Very Easy (1h)"),
                        ),

                        DropdownMenuItem(
                          value: "Easy",
                          child: Text("Easy (2h)"),
                        ),

                        DropdownMenuItem(
                          value: "Moderate",
                          child: Text("Moderate (3h)"),
                        ),

                        DropdownMenuItem(
                          value: "Medium",
                          child: Text("Medium (4h)"),
                        ),

                        DropdownMenuItem(
                          value: "Challenging",
                          child: Text("Challenging (5h)"),
                        ),

                        DropdownMenuItem(
                          value: "Hard",
                          child: Text("Hard (6h)"),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          selectedDifficulty[subject] = value!;
                        });
                      },
                    ),

                    const Text(
                      "Estimated study time:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () => addTopic(subject),

                        child: const Text("+ Add Topic"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...subjectTopics.map((topic) {
                      return ListTile(
                        leading: const Icon(Icons.book),

                        title: Text(topic.topicName),

                        subtitle: Text(topic.difficulty),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),

                              onPressed: () {
                                final topicController = TextEditingController(
                                  text: topic.topicName,
                                );

                                String selectedDifficulty = topic.difficulty;

                                showDialog(
                                  context: context,

                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: const Text("Edit Topic"),

                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              TextField(
                                                controller: topicController,

                                                decoration:
                                                    const InputDecoration(
                                                      labelText: "Topic Name",
                                                    ),
                                              ),

                                              const SizedBox(height: 15),

                                              DropdownButtonFormField<String>(
                                                initialValue:
                                                    selectedDifficulty,

                                                items: const [
                                                  DropdownMenuItem(
                                                    value: "Very Easy",
                                                    child: Text(
                                                      "Very Easy (1h)",
                                                    ),
                                                  ),

                                                  DropdownMenuItem(
                                                    value: "Easy",
                                                    child: Text("Easy (2h)"),
                                                  ),

                                                  DropdownMenuItem(
                                                    value: "Moderate",
                                                    child: Text(
                                                      "Moderate (3h)",
                                                    ),
                                                  ),

                                                  DropdownMenuItem(
                                                    value: "Medium",
                                                    child: Text("Medium (4h)"),
                                                  ),

                                                  DropdownMenuItem(
                                                    value: "Challenging",
                                                    child: Text(
                                                      "Challenging (5h)",
                                                    ),
                                                  ),

                                                  DropdownMenuItem(
                                                    value: "Hard",
                                                    child: Text("Hard (6h)"),
                                                  ),
                                                ],

                                                onChanged: (value) {
                                                  setDialogState(() {
                                                    selectedDifficulty = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },

                                              child: const Text("Cancel"),
                                            ),

                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  final index = topics.indexOf(
                                                    topic,
                                                  );

                                                  topics[index] = TopicModel(
                                                    subjectName:
                                                        topic.subjectName,

                                                    topicName: topicController
                                                        .text
                                                        .trim(),

                                                    difficulty:
                                                        selectedDifficulty,
                                                  );
                                                });

                                                Navigator.pop(context);
                                              },

                                              child: const Text("Save"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),

                              onPressed: () {
                                showDeleteDialog(topic);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          SizedBox(
            height: 55,

            child: ElevatedButton(
              onPressed: topics.isEmpty
                  ? null
                  : () async {
                      final totalRequiredHours = plannerService
                          .calculateTotalRequiredHours(topics);
                      final totalTopics = topics.length;

                      final totalSubjects = widget.subjects.length;

                      /*
                      Temporary value

                      Later we'll calculate from:
                      Exam Date
                      Weekday Hours
                      Weekend Hours
                      Blocked Dates
                      */

                      final availableHours = plannerService
                          .calculateAvailableHours(
                            examDate: widget.examDetails.examDate,
                            weekdayHours: widget.examDetails.weekdayHours,
                            weekendHours: widget.examDetails.weekendHours,
                          );

                      final status = plannerService.getRealityCheckStatus(
                        requiredHours: totalRequiredHours,
                        availableHours: availableHours,
                      );

                      await storage.savePlanDetails(
                        examName: widget.examDetails.examName,
                        examDate: widget.examDetails.examDate,
                        weekdayHours: widget.examDetails.weekdayHours,
                        weekendHours: widget.examDetails.weekendHours,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanSummaryScreen(
                            totalSubjects: totalSubjects,

                            totalTopics: totalTopics,

                            totalRequiredHours: totalRequiredHours,

                            availableHours: availableHours,

                            status: status,

                            topics: topics,

                            examDetails: widget.examDetails,
                          ),
                        ),
                      );
                    },

              child: const Text(
                "Generate Plan",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
