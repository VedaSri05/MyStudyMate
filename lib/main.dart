import 'package:flutter/material.dart';
import 'screens/startup/startup_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  await NotificationService.scheduleDailyReminder(
    id: 1,
    hour: 8,
    minute: 0,
    title: "📚 MyStudyMate",
    body: "Good morning! Time to start today's study tasks.",
  );

  await NotificationService.scheduleDailyReminder(
    id: 2,
    hour: 18,
    minute: 0,
    title: "📖 MyStudyMate",
    body: "Don't forget to complete today's study goals.",
  );

  runApp(const MyStudyMateApp());
}

class MyStudyMateApp extends StatelessWidget {
  const MyStudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyStudyMate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartupScreen(),
    );
  }
}
