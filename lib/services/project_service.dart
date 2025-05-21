import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all projects - for admin users
  Stream<List<ProjectModel>> getAllProjects() {
    return _firestore.collection('projects').orderBy('name').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get projects for a specific project manager
  Stream<List<ProjectModel>> getProjectManagerProjects(UserModel user) {
    // If the user has no assigned projects, return an empty list
    if (user.assignedProjects.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('projects')
        .where(FieldPath.documentId, whereIn: user.assignedProjects)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get a single project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final doc = await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        return ProjectModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print('Error getting project: $e');
    }
    return null;
  }

  // Create a new project
  Future<String?> createProject(ProjectModel project) async {
    try {
      final docRef = await _firestore
          .collection('projects')
          .add(project.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating project: $e');
      return null;
    }
  }

  // Update an existing project
  Future<bool> updateProject(ProjectModel project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      return true;
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  // Delete a project
  Future<bool> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }
}
