/// Success story model
class SuccessStoryModel {
  final String id;
  final String name;
  final String field;
  final String journey;
  final String message;
  final String? photoUrl;
  final String? currentPosition;
  final Map<String, String>? translations;

  SuccessStoryModel({
    required this.id,
    required this.name,
    required this.field,
    required this.journey,
    required this.message,
    this.photoUrl,
    this.currentPosition,
    this.translations,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      field: json['field'] as String,
      journey: json['journey'] as String,
      message: json['message'] as String,
      photoUrl: json['photoUrl'] as String?,
      currentPosition: json['currentPosition'] as String?,
      translations: json['translations'] != null
          ? Map<String, String>.from(
              json['translations'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'field': field,
      'journey': journey,
      'message': message,
      'photoUrl': photoUrl,
      'currentPosition': currentPosition,
      'translations': translations,
    };
  }
}

