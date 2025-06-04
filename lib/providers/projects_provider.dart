import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project.dart';

class ProjectsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Project> _projects = [];
  String _searchQuery = '';
  String _statusFilter = '';
  String _managerFilter = '';
  bool _isLoading = false;

  List<Project> get projects => _filterProjects();
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get managerFilter => _managerFilter;

  List<Project> _filterProjects() {
    return _projects.where((project) {
      bool matchesSearch =
          project.name.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesStatus =
          _statusFilter.isEmpty || project.status == _statusFilter;
      bool matchesManager = _managerFilter.isEmpty ||
          project.projectManagerIds.contains(_managerFilter);

      return matchesSearch && matchesStatus && matchesManager;
    }).toList();
  }

  Future<void> loadProjects() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('projects').get();
      _projects =
          snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createProject({
    required String name,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required List<String> projectManagerIds,
    required String createdBy,
    required String description,
  }) async {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to create a project');
      }

      final projectData = {
        'name': name,
        'location': location,
        'description': description,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'status': status,
        'project_manager_ids': projectManagerIds,
        'created_at': Timestamp.fromDate(DateTime.now()),
        'created_by': createdBy,
      };

      final docRef = await _firestore.collection('projects').add(projectData);

      final newProject = Project(
        id: docRef.id,
        name: name,
        location: location,
        description: description,
        startDate: startDate,
        endDate: endDate,
        status: status,
        projectManagerIds: projectManagerIds,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      _projects.add(newProject);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setManagerFilter(String managerId) {
    _managerFilter = managerId;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = '';
    _managerFilter = '';
    notifyListeners();
  }
}
