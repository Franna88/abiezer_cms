import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';

class ProjectProvider with ChangeNotifier {
  List<ProjectModel> _allProjects = [];
  List<ProjectModel> _userProjects = [];
  String? _selectedProjectId;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<ProjectModel> get allProjects => _allProjects;
  List<ProjectModel> get userProjects => _userProjects;
  bool get isLoading => _isLoading;
  String get error => _error;

  ProjectModel? get selectedProject {
    if (_selectedProjectId == null) return null;

    return _allProjects.firstWhere(
      (project) => project.id == _selectedProjectId,
      orElse:
          () => _userProjects.firstWhere(
            (project) => project.id == _selectedProjectId,
            orElse: () => null!,
          ),
    );
  }

  // Fetch all projects (for admin)
  Future<void> fetchAllProjects() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('projects')
              .orderBy('name')
              .get();

      _allProjects =
          snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error fetching projects: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch projects for a specific user (project manager)
  Future<void> fetchUserProjects(UserModel user) async {
    if (user.role == 'admin') {
      await fetchAllProjects();
      _userProjects = _allProjects;
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('projects')
              .where('projectManagers', arrayContains: user.uid)
              .orderBy('name')
              .get();

      _userProjects =
          snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error fetching user projects: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}
