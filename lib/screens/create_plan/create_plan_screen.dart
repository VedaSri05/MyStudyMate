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

  final TextEditingController weekdayController = TextEditingController();

  final TextEditingController weekendController = TextEditingController();

  final List<DateTime> blockedDates = [];

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,

      initialDate: blockedDates.isNotEmpty ? blockedDates.last : DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        blockedDates.removeWhere((date) => !date.isBefore(pickedDate));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Study Plan")),
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

            const SizedBox(height: 20),

            const Text(
              "Blocked Dates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select Exam Date first"),
                      ),
                    );

                    return;
                  }

                  final availableDates = <DateTime>[];

                  DateTime current = DateTime.now();

                  while (current.isBefore(selectedDate!)) {
                    final isBlocked = blockedDates.any(
                      (date) =>
                          date.day == current.day &&
                          date.month == current.month &&
                          date.year == current.year,
                    );

                    if (!isBlocked) {
                      availableDates.add(current);
                    }

                    current = current.add(const Duration(days: 1));
                  }

                  if (availableDates.isEmpty) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("No Available Dates"),
                          content: const Text(
                            "All available dates are already blocked.",
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

                  final pickedDate = await showDatePicker(
                    context: context,

                    initialDate: availableDates.last,

                    firstDate: DateTime.now(),

                    lastDate: selectedDate!.subtract(const Duration(days: 1)),

                    selectableDayPredicate: (day) {
                      return !blockedDates.any(
                        (date) =>
                            date.day == day.day &&
                            date.month == day.month &&
                            date.year == day.year,
                      );
                    },
                  );

                  if (pickedDate == null) {
                    return;
                  }

                  final isAlreadyBlocked = blockedDates.any(
                    (date) =>
                        date.day == pickedDate.day &&
                        date.month == pickedDate.month &&
                        date.year == pickedDate.year,
                  );

                  if (!context.mounted) return;

                  if (isAlreadyBlocked) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Date Already Blocked"),

                          content: const Text(
                            "This date is already in the blocked dates list.",
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

                  final today = DateTime.now();

                  final startDate = DateTime(
                    today.year,
                    today.month,
                    today.day,
                  );

                  final examDate = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                  );

                  final totalAvailableDates = examDate
                      .difference(startDate)
                      .inDays;

                  final remainingAfterThisBlock =
                      totalAvailableDates - (blockedDates.length + 1);

                  if (!context.mounted) return;

                  if (remainingAfterThisBlock < 1) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("At Least One Day Required"),
                          content: const Text(
                            "Please leave at least one day for study planning.",
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

                  setState(() {
                    if (!blockedDates.any(
                      (date) =>
                          date.day == pickedDate.day &&
                          date.month == pickedDate.month &&
                          date.year == pickedDate.year,
                    )) {
                      blockedDates.add(pickedDate);

                      blockedDates.sort((a, b) => a.compareTo(b));
                    }
                  });
                },

                child: const Text("Add Blocked Date"),
              ),
            ),

            ...blockedDates.map((date) {
              return ListTile(
                leading: const Icon(Icons.block),

                title: Text(
                  "${date.day}/"
                  "${date.month}/"
                  "${date.year}",
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),

                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,

                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Blocked Date"),

                          content: Text(
                            "Remove "
                            "${date.day}/"
                            "${date.month}/"
                            "${date.year} ?",
                          ),

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
                      setState(() {
                        blockedDates.remove(date);
                      });
                    }
                  },
                ),
              );
            }),

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
                      const SnackBar(content: Text("Please fill all fields")),
                    );

                    return;
                  }

                  final today = DateTime.now();

                  final totalStudyDays = selectedDate!
                      .difference(DateTime(today.year, today.month, today.day))
                      .inDays;

                  if (blockedDates.length >= totalStudyDays) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Plan Cannot Be Generated"),

                          content: const Text(
                            "All study days are blocked.\n\nPlease leave at least one day for planning.",
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

                  final examDetails = ExamDetailsModel(
                    examName: examController.text.trim(),
                    examDate: selectedDate!,
                    weekdayHours: int.parse(weekdayController.text),
                    weekendHours: int.parse(weekendController.text),
                    blockedDates: blockedDates,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddSubjectsScreen(examDetails: examDetails),
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
