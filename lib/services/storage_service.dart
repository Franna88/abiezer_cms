import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const int maxFileSize = 2 * 1024 * 1024; // 2MB
  static const int compressQuality = 80; // 80% quality

  // Compress and validate image before upload
  static Future<File?> compressAndValidateImage(XFile file) async {
    final originalFile = File(file.path);
    final fileSize = await originalFile.length();
    if (fileSize <= maxFileSize) {
      return originalFile;
    }
    // Compress image
    final targetPath = file.path.replaceFirst(
      path.extension(file.path),
      '_compressed${path.extension(file.path)}',
    );
    final compressedXFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: compressQuality,
    );
    if (compressedXFile != null &&
        await compressedXFile.length() <= maxFileSize) {
      return File(compressedXFile.path);
    }
    return null; // File too large even after compression
  }

  // Upload usage photo
  static Future<String> uploadUsagePhoto({
    required String projectId,
    required String materialId,
    required XFile file,
  }) async {
    final compressedFile = await compressAndValidateImage(file);
    if (compressedFile == null) {
      throw Exception(
          'Image is too large to upload (max 2MB after compression)');
    }
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child(
          'usage_photos/$projectId/$materialId/$fileName',
        );

    final uploadTask = ref.putFile(compressedFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Upload request photo
  static Future<String> uploadRequestPhoto({
    required String projectId,
    required String materialId,
    required XFile file,
  }) async {
    final compressedFile = await compressAndValidateImage(file);
    if (compressedFile == null) {
      throw Exception(
          'Image is too large to upload (max 2MB after compression)');
    }
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child(
          'request_photos/$projectId/$materialId/$fileName',
        );

    final uploadTask = ref.putFile(compressedFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Upload project document
  Future<String> uploadProjectDocument(File file, String projectName) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final ref =
          _storage.ref().child('project_documents/$projectName/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading project document: $e');
      rethrow;
    }
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
