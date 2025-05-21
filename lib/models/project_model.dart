import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String status; // 'active', 'completed', 'on-hold'
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> projectManagers;
  final String clientName;
  final String clientContact;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.projectManagers,
    required this.clientName,
    required this.clientContact,
  });

  // Convert Firestore document to ProjectModel
  factory ProjectModel.fromMap(Map<String, dynamic> data, String id) {
    return ProjectModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? 'active',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      projectManagers: List<String>.from(data['projectManagers'] ?? []),
      clientName: data['clientName'] ?? '',
      clientContact: data['clientContact'] ?? '',
    );
  }

  // Convert ProjectModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'projectManagers': projectManagers,
      'clientName': clientName,
      'clientContact': clientContact,
    };
  }
}
