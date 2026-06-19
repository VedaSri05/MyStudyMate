import 'package:flutter/material.dart';
import 'screens/startup/startup_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  runApp(const StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartupScreen(),
    );
  }
}
