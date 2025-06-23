import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../utils/dev_data.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool _useMockData = true; // Set to false for production

  // Initialize Firestore settings for offline support
  ProjectService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  // Get projects assigned to a project manager
  Stream<List<ProjectModel>> getProjectsForManager(String userId) {
    if (_useMockData) {
      // Use mock data for development
      return Stream.value(
        DevData.projects
            .where((project) => project.projectManagers.contains(userId))
            .toList(),
      );
    }

    return _firestore
        .collection('projects')
        .where('projectManagers', arrayContains: userId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get a specific project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    if (_useMockData) {
      // Use mock data for development
      final project = DevData.projects.firstWhere(
        (p) => p.id == projectId,
        orElse: () => DevData.projects.first,
      );
      return Future.value(project);
    }

    try {
      final doc = await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        return ProjectModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting project: $e');
      return null;
    }
  }

  // Get all active projects (for admin)
  Stream<List<ProjectModel>> getAllActiveProjects() {
    if (_useMockData) {
      // Use mock data for development
      return Stream.value(
        DevData.projects
            .where((project) => project.status == 'active')
            .toList(),
      );
    }

    return _firestore
        .collection('projects')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get count of low stock materials across assigned projects
  Future<int> getLowStockMaterialsCount(String userId) async {
    if (_useMockData) {
      // Use mock data for development
      return Future.value(3); // Hardcoded for development
    }

    // This is a placeholder. In a real implementation, you would:
    // 1. Get all projects for this user
    // 2. For each project, check its BoM for low stock materials
    // 3. Count the unique low stock materials
    return 3; // Hardcoded for now
  }

  // Get count of assigned projects
  Future<int> getAssignedProjectsCount(String userId) async {
    if (_useMockData) {
      // Use mock data for development
      final count = DevData.projects
          .where(
            (project) =>
                project.projectManagers.contains(userId) &&
                project.status == 'active',
          )
          .length;
      return Future.value(count);
    }

    try {
      final snapshot = await _firestore
          .collection('projects')
          .where('projectManagers', arrayContains: userId)
          .where('status', isEqualTo: 'active')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting assigned projects count: $e');
      return 0;
    }
  }

  // Add a manager to a project's project_manager_ids array
  Future<void> addManagerToProject(String projectId, String userId) async {
    try {
      await _firestore.collection('projects').doc(projectId).update({
        'project_manager_ids': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('Error adding manager to project: $e');
      rethrow;
    }
  }

  // Remove a manager from a project's project_manager_ids array
  Future<void> removeManagerFromProject(String projectId, String userId) async {
    try {
      await _firestore.collection('projects').doc(projectId).update({
        'project_manager_ids': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      print('Error removing manager from project: $e');
      rethrow;
    }
  }

  // Update project image URL
  Future<void> updateProjectImageUrl(String projectId, String imageUrl) async {
    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update({'projectImageUrl': imageUrl});
    } catch (e) {
      print('Error updating project image URL: $e');
      rethrow;
    }
  }
}
