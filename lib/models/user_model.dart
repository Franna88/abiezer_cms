class UserModel {
  final String uid;
  final String email;
  final String role; // "admin" or "project_manager"
  final String name;
  final List<String> assignedProjects;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    required this.assignedProjects,
    this.photoUrl = '',
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'project_manager',
      name: data['name'] ?? '',
      assignedProjects: List<String>.from(data['assignedProjects'] ?? []),
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'name': name,
      'assignedProjects': assignedProjects,
      'photoUrl': photoUrl,
    };
  }

  // Create a copy of the UserModel with some fields updated
  UserModel copyWith({
    String? email,
    String? role,
    String? name,
    List<String>? assignedProjects,
    String? photoUrl,
  }) {
    return UserModel(
      uid: this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      assignedProjects: assignedProjects ?? this.assignedProjects,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
