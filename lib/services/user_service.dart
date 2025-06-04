import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'audit_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuditService _auditService = AuditService();

  // Get all users stream
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Create new user
  Future<UserModel?> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    List<String> assignedProjects = const [],
  }) async {
    try {
      // Create auth user
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user document
        final UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          role: role,
          photoUrl: '',
          assignedProjects: assignedProjects,
          phone: phone,
        );

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());

        // Log the creation
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          await _auditService.logUserCreation(newUser, currentUser.uid);
        }

        return newUser;
      }
      return null;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // Update user
  Future<UserModel?> updateUser({
    required String userId,
    required String name,
    required String email,
    required String role,
    String? phone,
    List<String> assignedProjects = const [],
  }) async {
    try {
      // Get the current user data for audit logging
      final oldUserDoc = await _firestore.collection('users').doc(userId).get();
      final oldUser = UserModel.fromMap(oldUserDoc.data()!, userId);

      final updatedUser = UserModel(
        id: userId,
        name: name,
        email: email,
        role: role,
        phone: phone,
        assignedProjects: assignedProjects,
        photoUrl: oldUser.photoUrl, // Preserve the existing photo URL
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .update(updatedUser.toMap());

      // Log the update
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _auditService.logUserUpdate(
            oldUser, updatedUser, currentUser.uid);
      }

      return updatedUser;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      // Get the user data for audit logging
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final user = UserModel.fromMap(userDoc.data()!, userId);

      // Delete from Authentication
      User? currentUser = _auth.currentUser;
      if (currentUser?.uid == userId) {
        await currentUser?.delete();
      }

      // Delete from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Log the deletion
      if (currentUser != null) {
        await _auditService.logUserDeletion(user, currentUser.uid);
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Update user's assigned projects
  Future<void> updateUserProjects(String userId, List<String> projects) async {
    try {
      // Get the current user data for audit logging
      final oldUserDoc = await _firestore.collection('users').doc(userId).get();
      final oldUser = UserModel.fromMap(oldUserDoc.data()!, userId);

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'assignedProjects': projects});

      // Create updated user model for audit logging
      final updatedUser = oldUser.copyWith(assignedProjects: projects);

      // Log the update
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _auditService.logUserUpdate(
            oldUser, updatedUser, currentUser.uid);
      }
    } catch (e) {
      print('Error updating user projects: $e');
      rethrow;
    }
  }

  // Update user's profile photo
  Future<void> updateUserPhoto(String userId, String photoUrl) async {
    try {
      // Get the current user data for audit logging
      final oldUserDoc = await _firestore.collection('users').doc(userId).get();
      final oldUser = UserModel.fromMap(oldUserDoc.data()!, userId);

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'photoUrl': photoUrl});

      // Create updated user model for audit logging
      final updatedUser = oldUser.copyWith(photoUrl: photoUrl);

      // Log the update
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _auditService.logUserUpdate(
            oldUser, updatedUser, currentUser.uid);
      }
    } catch (e) {
      print('Error updating user photo: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getProjectManagers() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'project_manager')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
