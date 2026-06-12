import 'package:flutter/material.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/startup/startup_screen.dart';

void main() {
  runApp(const StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartupScreen(),
    );
  }
}