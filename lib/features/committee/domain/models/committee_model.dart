class CommitteeModel {
  final String id;
  final String name;
  final String position;
  final String positionEn; // English position for localization
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? fatherName; // S/O (Son of)
  final String? location; // Location in parentheses
  final String? area; // Area/Region for executive members
  final String? gotra; // Gotra
  final int order;

  CommitteeModel({
    required this.id,
    required this.name,
    required this.position,
    required this.positionEn,
    required this.phone,
    this.email,
    this.imageUrl,
    this.fatherName,
    this.location,
    this.area,
    this.gotra,
    this.order = 0,
  });

  factory CommitteeModel.fromMap(Map<String, dynamic> map, String id) {
    return CommitteeModel(
      id: id,
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      positionEn: map['positionEn'] ?? map['position'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      imageUrl: map['imageUrl'],
      fatherName: map['fatherName'],
      location: map['location'],
      area: map['area'],
      gotra: map['gotra'],
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'positionEn': positionEn,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'fatherName': fatherName,
      'location': location,
      'area': area,
      'gotra': gotra,
      'order': order,
    };
  }
}
