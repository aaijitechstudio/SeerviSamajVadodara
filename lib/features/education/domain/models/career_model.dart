/// Career model for Education & Career screen
class CareerModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category; // 'after10', 'after12', 'college', 'working'
  final List<String> requiredSubjects;
  final List<String> careerOptions;
  final List<String> freeResources;
  final List<String> commonMistakes;
  final String? salaryRange;
  final Map<String, String>? translations; // For multi-language support

  CareerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.requiredSubjects = const [],
    this.careerOptions = const [],
    this.freeResources = const [],
    this.commonMistakes = const [],
    this.salaryRange,
    this.translations,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String? ?? 'school',
      category: json['category'] as String,
      requiredSubjects: (json['requiredSubjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      careerOptions: (json['careerOptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      freeResources: (json['freeResources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      salaryRange: json['salaryRange'] as String?,
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
      'icon': icon,
      'category': category,
      'requiredSubjects': requiredSubjects,
      'careerOptions': careerOptions,
      'freeResources': freeResources,
      'commonMistakes': commonMistakes,
      'salaryRange': salaryRange,
      'translations': translations,
    };
  }
}

