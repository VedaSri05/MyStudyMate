import 'package:flutter/material.dart';
import 'add_topics_screen.dart';
import '../../models/exam_details_model.dart';

class AddSubjectsScreen extends StatefulWidget {
  final ExamDetailsModel examDetails;

  const AddSubjectsScreen({super.key, required this.examDetails});

  @override
  State<AddSubjectsScreen> createState() => _AddSubjectsScreenState();
}

class _AddSubjectsScreenState extends State<AddSubjectsScreen> {
  final TextEditingController subjectController = TextEditingController();
  final FocusNode subjectFocus = FocusNode();

  List<String> subjects = [];

  void addSubject() {
    final subjectName = subjectController.text.trim();

    if (subjectName.isEmpty) {
      return;
    }

    if (subjects.any(
      (subject) => subject.toLowerCase() == subjectName.toLowerCase(),
    )) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Subject already exists")));

      return;
    }

    setState(() {
      subjects.add(subjectName);
    });

    subjectController.clear();

    subjectFocus.requestFocus();
  }

  void editSubject(int index) {
    final controller = TextEditingController(text: subjects[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Subject"),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Subject Name"),
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
                if (controller.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  subjects[index] = controller.text.trim();
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Subjects")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              focusNode: subjectFocus,
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                addSubject();
              },

              decoration: const InputDecoration(
                labelText: "Subject Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addSubject,
                child: const Text("+ Add Subject"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: Text(subjects[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editSubject(index);
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,

                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Subject"),

                                    content: Text("Delete ${subjects[index]}?"),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },

                                        child: const Text("Cancel"),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },

                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete == true) {
                                deleteSubject(index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: subjects.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTopicsScreen(
                              subjects: subjects,
                              examDetails: widget.examDetails,
                            ),
                          ),
                        );
                      },
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
