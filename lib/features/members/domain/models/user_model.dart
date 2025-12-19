import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, member }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String? samajId;
  final String? houseId;
  final String? area;
  final String? profession;
  final String? address;
  final List<String>? familyMembers;
  final UserRole role;
  final DateTime createdAt;
  final bool isVerified;
  final bool isActive;
  final List<String>?
      blockedUsers; // For blocking unwanted messages/interactions
  final bool allowDirectMessages; // Allow direct messages from other members
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.samajId,
    this.houseId,
    this.area,
    this.profession,
    this.address,
    this.familyMembers,
    this.role = UserRole.member,
    required this.createdAt,
    this.isVerified = false,
    this.isActive = true,
    this.blockedUsers,
    this.allowDirectMessages = true,
    this.additionalInfo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    UserRole userRole = UserRole.member;
    if (map['role'] != null) {
      try {
        userRole = UserRole.values.firstWhere(
          (e) => e.toString() == 'UserRole.${map['role']}',
          orElse: () => UserRole.member,
        );
      } catch (e) {
        userRole = UserRole.member;
      }
    }

    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      samajId: map['samajId'],
      houseId: map['houseId'],
      area: map['area'],
      profession: map['profession'],
      address: map['address'],
      familyMembers: map['familyMembers'] != null
          ? List<String>.from(map['familyMembers'])
          : null,
      role: userRole,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: map['isVerified'] ?? false,
      isActive: map['isActive'] ?? true,
      blockedUsers: map['blockedUsers'] != null
          ? List<String>.from(map['blockedUsers'])
          : null,
      allowDirectMessages: map['allowDirectMessages'] ?? true,
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'samajId': samajId,
      'houseId': houseId,
      'area': area,
      'profession': profession,
      'address': address,
      'familyMembers': familyMembers,
      'role': role.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'isActive': isActive,
      'blockedUsers': blockedUsers,
      'allowDirectMessages': allowDirectMessages,
      'additionalInfo': additionalInfo,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? samajId,
    String? houseId,
    String? area,
    String? profession,
    String? address,
    List<String>? familyMembers,
    UserRole? role,
    DateTime? createdAt,
    bool? isVerified,
    bool? isActive,
    List<String>? blockedUsers,
    bool? allowDirectMessages,
    Map<String, dynamic>? additionalInfo,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      samajId: samajId ?? this.samajId,
      houseId: houseId ?? this.houseId,
      area: area ?? this.area,
      profession: profession ?? this.profession,
      address: address ?? this.address,
      familyMembers: familyMembers ?? this.familyMembers,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      allowDirectMessages: allowDirectMessages ?? this.allowDirectMessages,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isMember => role == UserRole.member;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, samajId: $samajId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
