/// Scholarship model for Education & Career screen
class ScholarshipModel {
  final String id;
  final String title;
  final String description;
  final String type; // 'government', 'state', 'minority', 'community'
  final String eligibility;
  final List<String> documents;
  final String? officialWebsite;
  final String? applicationProcess;
  final String? amount;
  final Map<String, String>? translations;

  ScholarshipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.eligibility,
    this.documents = const [],
    this.officialWebsite,
    this.applicationProcess,
    this.amount,
    this.translations,
  });

  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      eligibility: json['eligibility'] as String,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      officialWebsite: json['officialWebsite'] as String?,
      applicationProcess: json['applicationProcess'] as String?,
      amount: json['amount'] as String?,
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
      'type': type,
      'eligibility': eligibility,
      'documents': documents,
      'officialWebsite': officialWebsite,
      'applicationProcess': applicationProcess,
      'amount': amount,
      'translations': translations,
    };
  }
}

