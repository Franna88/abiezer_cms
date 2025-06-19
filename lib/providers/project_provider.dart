import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project_model.dart';
import '../models/bom_item_model.dart';
import '../models/user_model.dart';
import 'user_provider.dart';

class ProjectProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProjectModel> _allProjects = [];
  List<ProjectModel> _userProjects = [];
  String? _selectedProjectId;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<ProjectModel> get allProjects => _allProjects;
  List<ProjectModel> get userProjects => _userProjects;
  List<ProjectModel> get assignedProjects => _userProjects;
  bool get isLoading => _isLoading;
  String get error => _error;

  ProjectModel? get selectedProject {
    if (_selectedProjectId == null) return null;
    return _allProjects.firstWhere(
      (project) => project.id == _selectedProjectId,
      orElse: () => _userProjects.firstWhere(
        (project) => project.id == _selectedProjectId,
        orElse: () => null!,
      ),
    );
  }

  // Stream for BoM items of selected project
  Stream<List<BoMItemModel>>? get selectedProjectBoMStream {
    if (selectedProject == null) return null;

    return _firestore
        .collection('project_boms')
        .doc(selectedProject!.id)
        .collection('items')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BoMItemModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Load assigned projects (for project managers)
  Future<void> loadAssignedProjects(List<String> assignedProjectIds) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (assignedProjectIds.isEmpty) {
        _userProjects = [];
        notifyListeners();
        return;
      }

      // Fetch projects in batches to avoid query limitations
      List<ProjectModel> projects = [];
      for (var i = 0; i < assignedProjectIds.length; i += 10) {
        final batch = assignedProjectIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection('projects')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        projects.addAll(
          snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList(),
        );
      }

      // Sort projects by name
      projects.sort((a, b) => a.name.compareTo(b.name));
      _userProjects = projects;

      notifyListeners();
    } catch (e) {
      _error = 'Error loading assigned projects: ${e.toString()}';
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all projects (for admin)
  Future<void> fetchAllProjects() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final snapshot =
          await _firestore.collection('projects').orderBy('name').get();

      _allProjects =
          snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error fetching projects: ${e.toString()}';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch projects for a specific user
  Future<void> fetchUserProjects(UserModel user) async {
    if (user.role == 'admin') {
      await fetchAllProjects();
      _userProjects = _allProjects;
      return;
    }

    await loadAssignedProjects(user.assignedProjects);
  }

  // Set selected project
  void setSelectedProject(String? projectId) {
    _selectedProjectId = projectId;
    notifyListeners();
  }

  // Reset error
  void resetError() {
    _error = '';
    notifyListeners();
  }

  // Log material usage
  Future<void> logMaterialUsage({
    required String projectId,
    required String materialId,
    required int quantity,
    String? note,
    String? photoUrl,
  }) async {
    // Update usage in Firestore
    await _firestore
        .collection('project_boms')
        .doc(projectId)
        .collection('items')
        .doc(materialId)
        .update({
      'used': FieldValue.increment(quantity),
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // Log the usage
    await _firestore.collection('usage_logs').add({
      'projectId': projectId,
      'materialId': materialId,
      'quantity': quantity,
      'note': note,
      'photoUrl': photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  // Submit material request
  Future<void> submitMaterialRequest({
    required String projectId,
    required String materialId,
    required int quantity,
    required String reason,
    String? photoUrl,
  }) async {
    await _firestore.collection('material_requests').add({
      'projectId': projectId,
      'materialId': materialId,
      'quantity': quantity,
      'reason': reason,
      'photoUrl': photoUrl,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  // Fetch projects assigned to a specific project manager
  Future<List<ProjectModel>> fetchAssignedProjects(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('projects')
          .where('project_manager_ids', arrayContains: userId)
          .get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching assigned projects: $e');
      return [];
    }
  }
}
