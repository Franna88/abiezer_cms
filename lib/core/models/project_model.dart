class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String? clientName;
  final String? clientContact;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // active, completed, pending, canceled
  final List<String> assignedUsers;
  final String? projectManagerId; // ID of the assigned project manager
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.clientName,
    this.clientContact,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.assignedUsers,
    this.projectManagerId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a project from JSON data
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      clientName: json['clientName'],
      clientContact: json['clientContact'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'],
      assignedUsers: List<String>.from(json['assignedUsers'] ?? []),
      projectManagerId: json['projectManagerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert project to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'clientName': clientName,
      'clientContact': clientContact,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'assignedUsers': assignedUsers,
      'projectManagerId': projectManagerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of the project with updated fields
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? clientName,
    String? clientContact,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    List<String>? assignedUsers,
    String? projectManagerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      clientName: clientName ?? this.clientName,
      clientContact: clientContact ?? this.clientContact,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      projectManagerId: projectManagerId ?? this.projectManagerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if project is active
  bool get isActive => status == 'active';

  // Check if project is completed
  bool get isCompleted => status == 'completed';

  // Calculate project duration in days
  int get durationInDays {
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays;
  }

  // Check if a user is the project manager
  bool isUserProjectManager(String userId) {
    return projectManagerId == userId;
  }
}
