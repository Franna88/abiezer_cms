import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String _error = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.role == 'admin';
  bool get isProjectManager => _user?.role == 'project_manager';

  // Initialize user from Firebase Auth
  Future<void> initializeUser() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _fetchUserData(currentUser.uid);
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData(String uid) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      } else {
        _error = 'User data not found';
      }
    } catch (e) {
      _error = 'Error fetching user data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await _fetchUserData(credential.user!.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _error = 'No user found with this email.';
          break;
        case 'wrong-password':
          _error = 'Incorrect password.';
          break;
        case 'invalid-email':
          _error = 'Invalid email format.';
          break;
        case 'user-disabled':
          _error = 'This account has been disabled.';
          break;
        default:
          _error = 'An error occurred: ${e.message}';
      }
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
    } catch (e) {
      _error = 'Error signing out: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if the user can access a specific project
  bool canAccessProject(String projectId) {
    if (isAdmin) return true;
    return _user?.assignedProjects.contains(projectId) ?? false;
  }

  // Reset error message
  void resetError() {
    _error = '';
    notifyListeners();
  }
}
