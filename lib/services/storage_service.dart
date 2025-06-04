import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload usage photo
  static Future<String> uploadUsagePhoto({
    required String projectId,
    required String materialId,
    required XFile file,
  }) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child(
      'usage_photos/$projectId/$materialId/$fileName',
    );

    final uploadTask = ref.putFile(File(file.path));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Upload request photo
  static Future<String> uploadRequestPhoto({
    required String projectId,
    required String materialId,
    required XFile file,
  }) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child(
      'request_photos/$projectId/$materialId/$fileName',
    );

    final uploadTask = ref.putFile(File(file.path));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deletePhoto(String photoUrl) async {
    try {
      final ref = _storage.refFromURL(photoUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting photo: $e');
      rethrow;
    }
  }
}
