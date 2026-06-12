import 'dart:async';
import 'package:flutter/material.dart';

class StudyTimerScreen extends StatefulWidget {
  const StudyTimerScreen({super.key});

  @override
  State<StudyTimerScreen> createState() =>
      _StudyTimerScreenState();
}

class _StudyTimerScreenState
    extends State<StudyTimerScreen> {

  Timer? timer;

  int seconds = 0;

  bool isRunning = false;

  void startTimer() {

    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {

        setState(() {
          seconds++;
        });
      },
    );
  }

  void pauseTimer() {

    timer?.cancel();

    isRunning = false;
  }

  void resetTimer() {

    timer?.cancel();

    setState(() {

      seconds = 0;

      isRunning = false;
    });
  }

  String formatTime() {

    final hours =
        (seconds ~/ 3600)
            .toString()
            .padLeft(2, '0');

    final minutes =
        ((seconds % 3600) ~/ 60)
            .toString()
            .padLeft(2, '0');

    final secs =
        (seconds % 60)
            .toString()
            .padLeft(2, '0');

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

      appBar: AppBar(
        title:
            const Text("Study Timer"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(
              formatTime(),

              style:
                  const TextStyle(
                fontSize: 48,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 40),

            ElevatedButton(
              onPressed:
                  startTimer,

              child:
                  const Text(
                "Start",
              ),
            ),

            const SizedBox(
                height: 10),

            ElevatedButton(
              onPressed:
                  pauseTimer,

              child:
                  const Text(
                "Pause",
              ),
            ),

            const SizedBox(
                height: 10),

            ElevatedButton(
              onPressed:
                  resetTimer,

              child:
                  const Text(
                "Reset",
              ),
            ),
          ],
        ),
      ),
    );
  }
}