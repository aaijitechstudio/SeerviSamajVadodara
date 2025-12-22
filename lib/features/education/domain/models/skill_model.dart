/// Skill development model
class SkillModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'computer', 'language', 'digital', 'vocational'
  final List<String> whoShouldLearn;
  final List<String> freeResources;
  final List<String> careerOutcomes;
  final String? duration;
  final Map<String, String>? translations;

  SkillModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.whoShouldLearn = const [],
    this.freeResources = const [],
    this.careerOutcomes = const [],
    this.duration,
    this.translations,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      whoShouldLearn: (json['whoShouldLearn'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      freeResources: (json['freeResources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      careerOutcomes: (json['careerOutcomes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      duration: json['duration'] as String?,
      translations: json['translations'] != null
          ? Map<String, String>.from(
              json['translations'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'whoShouldLearn': whoShouldLearn,
      'freeResources': freeResources,
      'careerOutcomes': careerOutcomes,
      'duration': duration,
      'translations': translations,
    };
  }
}

