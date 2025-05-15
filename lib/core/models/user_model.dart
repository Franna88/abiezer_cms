class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // admin, project_manager
  final String? phoneNumber;
  final String? photoUrl;
  final List<String> assignedProjects;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.photoUrl,
    required this.assignedProjects,
    required this.createdAt,
    required this.lastLoginAt,
  });

  // Create a user from JSON data - useful for API responses
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      assignedProjects: List<String>.from(json['assignedProjects'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
    );
  }

  // Convert user to JSON - useful for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'assignedProjects': assignedProjects,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  // Create a copy of the user with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
    String? photoUrl,
    List<String>? assignedProjects,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      assignedProjects: assignedProjects ?? this.assignedProjects,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // Check if user is an admin
  bool get isAdmin => role == 'admin';

  // Check if user is a project manager
  bool get isProjectManager => role == 'project_manager';

  // Check if user has access to a specific project
  bool hasAccessToProject(String projectId) {
    // Admin has access to all projects
    if (isAdmin) return true;

    // Project managers only have access to assigned projects
    return isProjectManager && assignedProjects.contains(projectId);
  }

  // Check if user can create projects
  bool get canCreateProjects => isAdmin;

  // Check if user can assign project managers
  bool get canAssignProjectManagers => isAdmin;

  // Check if user can mark materials as used
  bool get canMarkMaterialsUsed => isAdmin || isProjectManager;

  // Check if user can mark project as complete
  bool get canMarkProjectComplete => isAdmin || isProjectManager;

  // Check if user can create bill of materials
  bool get canCreateBillOfMaterials => isAdmin;

  // Check if user can view any project
  bool get canViewAnyProject => isAdmin;
}
