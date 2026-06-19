import 'dart:async';
import 'package:flutter/material.dart';

class StudyTimerScreen extends StatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  State<StudyTimerScreen> createState() => _StudyTimerScreenState();
}

class _StudyTimerScreenState extends State<StudyTimerScreen> {
  Timer? timer;
  
  int seconds = 25 * 60;

  bool isRunning = false;

  bool isBreakTime = false;

  void startTimer() {
    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        pauseTimer();

        if (!isBreakTime) {
          setState(() {
            isBreakTime = true;
            seconds = 5 * 60;
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("🎉 Focus Session Completed"),

                content: const Text("Time for a 5 minute break."),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Start Break"),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            isBreakTime = false;
            seconds = 25 * 60;
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("☕ Break Completed"),

                content: const Text("Ready for your next focus session?"),

                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Let's Go"),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();

    isRunning = false;
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      seconds = isBreakTime ? 5 * 60 : 25 * 60;

      isRunning = false;
    });
  }

  String formatTime() {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');

    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');

    final secs = (seconds % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$secs";
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro Timer")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              isBreakTime ? "☕ Break Time" : "📚 Focus Session",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              formatTime(),

              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            ElevatedButton(onPressed: startTimer, child: const Text("Start")),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: pauseTimer, child: const Text("Pause")),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: resetTimer, child: const Text("Reset")),
          ],
        ),
      ),
    );
  }
}
