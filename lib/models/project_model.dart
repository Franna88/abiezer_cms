import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String status; // 'active', 'completed', 'on-hold', 'cancelled'
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> projectManagers;
  final String client;
  final double budget;
  final String imageUrl;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.projectManagers,
    required this.client,
    required this.budget,
    this.imageUrl = '',
  });

  // Create from Firestore document
  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProjectModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? 'active',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      projectManagers: List<String>.from(data['projectManagers'] ?? []),
      client: data['client'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'status': status,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'projectManagers': projectManagers,
      'client': client,
      'budget': budget,
      'imageUrl': imageUrl,
    };
  }

  // Create a copy of the Project with some fields updated
  ProjectModel copyWith({
    String? name,
    String? description,
    String? location,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? projectManagers,
    String? client,
    double? budget,
    String? imageUrl,
  }) {
    return ProjectModel(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectManagers: projectManagers ?? this.projectManagers,
      client: client ?? this.client,
      budget: budget ?? this.budget,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
