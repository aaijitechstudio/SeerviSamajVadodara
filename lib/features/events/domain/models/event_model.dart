import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime? endDate;
  final String? location;
  final String? imageUrl;
  final String? organizerId;
  final String? organizerName;
  final DateTime createdAt;
  final bool isActive;
  final List<String>? registeredUsers;
  final Map<String, dynamic>? metadata;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.endDate,
    this.location,
    this.imageUrl,
    this.organizerId,
    this.organizerName,
    required this.createdAt,
    this.isActive = true,
    this.registeredUsers,
    this.metadata,
  });

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      eventDate: (map['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
      location: map['location'],
      imageUrl: map['imageUrl'],
      organizerId: map['organizerId'],
      organizerName: map['organizerName'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      registeredUsers: map['registeredUsers'] != null
          ? List<String>.from(map['registeredUsers'])
          : null,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'location': location,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'registeredUsers': registeredUsers,
      'metadata': metadata,
    };
  }

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isPast => eventDate.isBefore(DateTime.now());
}
