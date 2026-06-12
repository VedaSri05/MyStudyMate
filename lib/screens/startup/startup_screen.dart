import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../../services/local_storage_service.dart';
import '../welcome/welcome_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final storage = LocalStorageService();

  @override
  void initState() {
    super.initState();

    checkSavedPlan();
  }

  Future<void> checkSavedPlan() async {
    final studyPlan = await storage.getStudyPlan();

    debugPrint(
      studyPlan == null ? "NO PLAN FOUND" : "PLAN FOUND: ${studyPlan.examName}",
    );

    if (!mounted) return;

    if (studyPlan == null) {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );

      return;
    }

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          examName: studyPlan.examName,

          examDate: studyPlan.examDate,

          tasks: studyPlan.tasks,
        ),
      ),
    );

    /*
    Dashboard restore
    will be added next
    */

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
