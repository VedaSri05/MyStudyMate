import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/study_plan_model.dart';
import 'package:flutter/foundation.dart';

class LocalStorageService {
  Future<void> savePlanDetails({
    required String examName,
    required DateTime examDate,
    required int weekdayHours,
    required int weekendHours,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('exam_name', examName);

    await prefs.setString('exam_date', examDate.toIso8601String());

    await prefs.setInt('weekday_hours', weekdayHours);

    await prefs.setInt('weekend_hours', weekendHours);
  }

  Future<String?> getExamName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('exam_name');
  }

  Future<DateTime?> getExamDate() async {
    final prefs = await SharedPreferences.getInstance();

    final date = prefs.getString('exam_date');

    if (date == null) {
      return null;
    }

    return DateTime.parse(date);
  }

  Future<void> saveCompletedTopics(List<String> topics) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('completed_topics', topics);
  }

  Future<List<String>> getCompletedTopics() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('completed_topics') ?? [];
  }

  Future<void> saveStudyPlan(StudyPlanModel plan) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(plan.toJson());

    debugPrint("SAVING PLAN: $jsonString");

    final result = await prefs.setString('study_plan', jsonString);

    debugPrint("KEYS AFTER SAVE: ${prefs.getKeys()}");

    debugPrint("SAVE RESULT: $result");

    debugPrint("PLAN SAVED SUCCESSFULLY");
  }

  Future<void> clearStudyPlan() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('study_plan');

    await prefs.remove('exam_name');

    await prefs.remove('exam_date');

    await prefs.remove('weekday_hours');

    await prefs.remove('weekend_hours');
  }

  Future<StudyPlanModel?> getStudyPlan() async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint("ALL KEYS: ${prefs.getKeys()}");

    final jsonString = prefs.getString('study_plan');

    debugPrint("STUDY PLAN JSON: $jsonString");

    if (jsonString == null) {
      return null;
    }

    final jsonMap = jsonDecode(jsonString);

    return StudyPlanModel.fromJson(jsonMap);
  }
}
