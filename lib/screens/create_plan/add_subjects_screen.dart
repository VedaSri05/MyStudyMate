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
    if (subjectController.text.trim().isEmpty) return;

    setState(() {
      subjects.add(subjectController.text.trim());
    });

    subjectController.clear();
    subjectFocus.requestFocus();
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            subjects.removeAt(index);
                          });
                        },
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
