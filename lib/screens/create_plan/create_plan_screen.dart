import 'package:flutter/material.dart';
import 'add_subjects_screen.dart';
import '../../models/exam_details_model.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final TextEditingController examController = TextEditingController();

  final TextEditingController weekdayController =
      TextEditingController();

  final TextEditingController weekendController =
      TextEditingController();

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Study Plan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: examController,
              decoration: const InputDecoration(
                labelText: "Exam Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  selectedDate == null
                      ? "Select Exam Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: weekdayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weekday Study Hours",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: weekendController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weekend Study Hours",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                if (examController.text.isEmpty ||
                    selectedDate == null ||
                    weekdayController.text.isEmpty ||
                    weekendController.text.isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please fill all fields",
                      ),
                    ),
                  );

                  return;
                }

                final examDetails = ExamDetailsModel(
                examName: examController.text.trim(),
                examDate: selectedDate!,
                weekdayHours:
                    int.parse(weekdayController.text),
                weekendHours:
                    int.parse(weekendController.text),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddSubjectsScreen(
                    examDetails: examDetails,
                  ),
                ),
              );
              },
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}