/// Exam and competitive exam model
class ExamModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'upsc', 'banking', 'defence', 'teaching', 'engineering', 'medical'
  final String eligibility;
  final List<String> freeResources;
  final String? examFrequency;
  final String? officialWebsite;
  final Map<String, String>? translations;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.eligibility,
    this.freeResources = const [],
    this.examFrequency,
    this.officialWebsite,
    this.translations,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      eligibility: json['eligibility'] as String,
      freeResources: (json['freeResources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      examFrequency: json['examFrequency'] as String?,
      officialWebsite: json['officialWebsite'] as String?,
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
      'eligibility': eligibility,
      'freeResources': freeResources,
      'examFrequency': examFrequency,
      'officialWebsite': officialWebsite,
      'translations': translations,
    };
  }
}

