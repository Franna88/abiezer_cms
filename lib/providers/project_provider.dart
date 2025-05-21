import 'dart:async';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';
import '../services/project_service.dart';

class ProjectProvider with ChangeNotifier {
  final ProjectService _projectService = ProjectService();

  List<ProjectModel> _projects = [];
  ProjectModel? _selectedProject;
  bool _isLoading = false;
  String _error = '';
  StreamSubscription? _projectSubscription;

  // Getters
  List<ProjectModel> get projects => _projects;
  ProjectModel? get selectedProject => _selectedProject;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasProjects => _projects.isNotEmpty;

  // Load projects based on user role
  void loadProjects(UserModel? user) {
    if (user == null) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    // Cancel any existing subscription
    _projectSubscription?.cancel();

    // Get projects based on user role
    if (user.role == 'admin') {
      _projectSubscription = _projectService.getAllProjects().listen(
        (projects) {
          _projects = projects;
          // Select first project by default if available and none selected
          if (_selectedProject == null && _projects.isNotEmpty) {
            _selectedProject = _projects.first;
          } else if (_selectedProject != null) {
            // Update selected project if it exists in the new list
            final updatedProject = _projects.firstWhere(
              (p) => p.id == _selectedProject!.id,
              orElse:
                  () =>
                      _projects.isNotEmpty
                          ? _projects.first
                          : _selectedProject!,
            );
            _selectedProject = updatedProject;
          }
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _error = 'Error loading projects: $error';
          _isLoading = false;
          notifyListeners();
        },
      );
    } else {
      // Project manager - only show assigned projects
      _projectSubscription = _projectService
          .getProjectManagerProjects(user)
          .listen(
            (projects) {
              _projects = projects;
              // Select first project by default if available and none selected
              if (_selectedProject == null && _projects.isNotEmpty) {
                _selectedProject = _projects.first;
              } else if (_selectedProject != null) {
                // Update selected project if it exists in the new list
                final updatedProject = _projects.firstWhere(
                  (p) => p.id == _selectedProject!.id,
                  orElse:
                      () =>
                          _projects.isNotEmpty
                              ? _projects.first
                              : _selectedProject!,
                );
                _selectedProject = updatedProject;
              }
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _error = 'Error loading projects: $error';
              _isLoading = false;
              notifyListeners();
            },
          );
    }
  }

  // Select a project
  void selectProject(ProjectModel project) {
    _selectedProject = project;
    notifyListeners();
  }

  // Select a project by ID
  void selectProjectById(String projectId) {
    final project = _projects.firstWhere(
      (p) => p.id == projectId,
      orElse:
          () =>
              _selectedProject ??
              (_projects.isNotEmpty
                  ? _projects.first
                  : throw Exception('No projects available')),
    );
    _selectedProject = project;
    notifyListeners();
  }

  // Reset error message
  void resetError() {
    _error = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _projectSubscription?.cancel();
    super.dispose();
  }
}
