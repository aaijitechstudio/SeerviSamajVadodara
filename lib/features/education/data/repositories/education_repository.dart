import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/career_model.dart';
import '../../domain/models/scholarship_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/models/exam_model.dart';
import '../../domain/models/success_story_model.dart';

/// Repository for Education & Career data
/// Loads data from local JSON files (offline-first, no admin needed)
class EducationRepository {
  static const String _careersPath = 'assets/data/careers.json';
  static const String _scholarshipsPath = 'assets/data/scholarships.json';
  static const String _skillsPath = 'assets/data/skills.json';
  static const String _examsPath = 'assets/data/exams.json';
  static const String _successStoriesPath = 'assets/data/success_stories.json';

  /// Load careers data
  Future<List<CareerModel>> getCareers({String? category}) async {
    try {
      final jsonString = await rootBundle.loadString(_careersPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final careersList = jsonData['careers'] as List<dynamic>;

      final careers = careersList
          .map((json) => CareerModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (category != null) {
        return careers.where((c) => c.category == category).toList();
      }

      return careers;
    } catch (e) {
      // Return empty list if file doesn't exist or error occurs
      return [];
    }
  }

  /// Load scholarships data
  Future<List<ScholarshipModel>> getScholarships({String? type}) async {
    try {
      final jsonString = await rootBundle.loadString(_scholarshipsPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final scholarshipsList = jsonData['scholarships'] as List<dynamic>;

      final scholarships = scholarshipsList
          .map((json) => ScholarshipModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (type != null) {
        return scholarships.where((s) => s.type == type).toList();
      }

      return scholarships;
    } catch (e) {
      return [];
    }
  }

  /// Load skills data
  Future<List<SkillModel>> getSkills({String? category}) async {
    try {
      final jsonString = await rootBundle.loadString(_skillsPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final skillsList = jsonData['skills'] as List<dynamic>;

      final skills = skillsList
          .map((json) => SkillModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (category != null) {
        return skills.where((s) => s.category == category).toList();
      }

      return skills;
    } catch (e) {
      return [];
    }
  }

  /// Load exams data
  Future<List<ExamModel>> getExams({String? category}) async {
    try {
      final jsonString = await rootBundle.loadString(_examsPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final examsList = jsonData['exams'] as List<dynamic>;

      final exams = examsList
          .map((json) => ExamModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (category != null) {
        return exams.where((e) => e.category == category).toList();
      }

      return exams;
    } catch (e) {
      return [];
    }
  }

  /// Load success stories
  Future<List<SuccessStoryModel>> getSuccessStories() async {
    try {
      final jsonString = await rootBundle.loadString(_successStoriesPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final storiesList = jsonData['stories'] as List<dynamic>;

      return storiesList
          .map((json) => SuccessStoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Search across all content
  Future<Map<String, List<dynamic>>> search(String query) async {
    final results = <String, List<dynamic>>{
      'careers': [],
      'scholarships': [],
      'skills': [],
      'exams': [],
      'stories': [],
    };

    final lowerQuery = query.toLowerCase();

    // Search careers
    final careers = await getCareers();
    results['careers'] = careers
        .where((c) =>
            c.title.toLowerCase().contains(lowerQuery) ||
            c.description.toLowerCase().contains(lowerQuery))
        .toList();

    // Search scholarships
    final scholarships = await getScholarships();
    results['scholarships'] = scholarships
        .where((s) =>
            s.title.toLowerCase().contains(lowerQuery) ||
            s.description.toLowerCase().contains(lowerQuery))
        .toList();

    // Search skills
    final skills = await getSkills();
    results['skills'] = skills
        .where((s) =>
            s.title.toLowerCase().contains(lowerQuery) ||
            s.description.toLowerCase().contains(lowerQuery))
        .toList();

    // Search exams
    final exams = await getExams();
    results['exams'] = exams
        .where((e) =>
            e.title.toLowerCase().contains(lowerQuery) ||
            e.description.toLowerCase().contains(lowerQuery))
        .toList();

    // Search success stories
    final stories = await getSuccessStories();
    results['stories'] = stories
        .where((s) =>
            s.name.toLowerCase().contains(lowerQuery) ||
            s.field.toLowerCase().contains(lowerQuery) ||
            s.journey.toLowerCase().contains(lowerQuery))
        .toList();

    return results;
  }
}

