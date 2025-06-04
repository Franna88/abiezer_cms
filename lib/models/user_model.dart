class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String photoUrl;
  final List<String> assignedProjects;
  final String? phone; // Optional for new users

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.photoUrl,
    required this.assignedProjects,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'assignedProjects': assignedProjects,
      if (phone != null) 'phone': phone,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map, String userId) {
    return UserModel(
      id: userId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      assignedProjects: List<String>.from(map['assignedProjects'] ?? []),
      phone: map['phone'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? photoUrl,
    List<String>? assignedProjects,
    String? phone,
  }) {
    return UserModel(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      assignedProjects: assignedProjects ?? this.assignedProjects,
      phone: phone ?? this.phone,
    );
  }
}
