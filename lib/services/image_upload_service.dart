import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageUploadResult {
  final String? downloadUrl;
  final String? error;
  final bool success;

  ImageUploadResult({
    this.downloadUrl,
    this.error,
    required this.success,
  });

  factory ImageUploadResult.success(String downloadUrl) {
    return ImageUploadResult(
      downloadUrl: downloadUrl,
      success: true,
    );
  }

  factory ImageUploadResult.failure(String error) {
    return ImageUploadResult(
      error: error,
      success: false,
    );
  }
}

class ImageUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const Duration _uploadTimeout = Duration(minutes: 5);
  static const int _maxFileSize = 5 * 1024 * 1024; // 5MB

  static final Map<String, StreamController<double>> _progressControllers = {};
  static final Map<String, UploadTask> _activeTasks = {};

  // Upload project image with progress tracking
  static Future<ImageUploadResult> uploadProjectImage({
    required XFile imageFile,
    required String projectName,
    required String uploadId,
    Function(double progress)? onProgress,
  }) async {
    try {
      print('📋 Starting image upload validation...');

      // Validate file size
      final bytes = await imageFile.readAsBytes();
      if (bytes.length > _maxFileSize) {
        return ImageUploadResult.failure(
          'Image size too large. Maximum size is 5MB.',
        );
      }

      // Validate file type
      final extension = path.extension(imageFile.name).toLowerCase();
      if (!['.jpg', '.jpeg', '.png', '.webp'].contains(extension)) {
        return ImageUploadResult.failure(
          'Invalid file type. Please select a JPG, PNG, or WebP image.',
        );
      }

      print('✅ Image validation passed');
      print(
          '📁 File size: ${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB');

      // Create unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${path.basename(imageFile.name)}';
      final ref = _storage.ref().child('project_images/$projectName/$fileName');

      print('📤 Starting upload to: project_images/$projectName/$fileName');

      // Create upload task
      final uploadTask = ref.putData(
        bytes,
        SettableMetadata(
          contentType: _getContentType(extension),
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'projectName': projectName,
            'originalName': imageFile.name,
          },
        ),
      );

      // Store task for potential cancellation
      _activeTasks[uploadId] = uploadTask;

      // Create progress controller
      final progressController = StreamController<double>.broadcast();
      _progressControllers[uploadId] = progressController;

      // Listen to upload progress
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          progressController.add(progress);
          onProgress?.call(progress);

          print('📊 Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        },
        onError: (error) {
          print('❌ Upload progress error: $error');
          progressController.addError(error);
        },
        onDone: () {
          print('✅ Upload progress completed');
          progressController.close();
          _progressControllers.remove(uploadId);
          _activeTasks.remove(uploadId);
        },
      );

      // Wait for upload with timeout
      final TaskSnapshot snapshot = await uploadTask.timeout(
        _uploadTimeout,
        onTimeout: () {
          throw TimeoutException(
            'Upload timed out after ${_uploadTimeout.inMinutes} minutes',
            _uploadTimeout,
          );
        },
      );

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Upload completed successfully');
      print('🔗 Download URL: $downloadUrl');

      return ImageUploadResult.success(downloadUrl);
    } catch (e) {
      print('❌ Upload failed: $e');

      // Clean up on error
      _progressControllers[uploadId]?.close();
      _progressControllers.remove(uploadId);
      _activeTasks.remove(uploadId);

      String errorMessage;
      if (e is TimeoutException) {
        errorMessage =
            'Upload timed out. Please check your internet connection and try again.';
      } else if (e is FirebaseException) {
        errorMessage = _handleFirebaseError(e);
      } else {
        errorMessage = 'Upload failed: ${e.toString()}';
      }

      return ImageUploadResult.failure(errorMessage);
    }
  }

  // Cancel upload
  static Future<bool> cancelUpload(String uploadId) async {
    try {
      final task = _activeTasks[uploadId];
      if (task != null) {
        await task.cancel();
        _progressControllers[uploadId]?.close();
        _progressControllers.remove(uploadId);
        _activeTasks.remove(uploadId);
        print('🚫 Upload cancelled: $uploadId');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error cancelling upload: $e');
      return false;
    }
  }

  // Get upload progress stream
  static Stream<double>? getProgressStream(String uploadId) {
    return _progressControllers[uploadId]?.stream;
  }

  // Delete uploaded image
  static Future<bool> deleteImage(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      print('🗑️ Image deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }

  // Helper method to get content type
  static String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  // Handle Firebase-specific errors
  static String _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'storage/unauthorized':
        return 'You don\'t have permission to upload images. Please contact an administrator.';
      case 'storage/canceled':
        return 'Upload was cancelled.';
      case 'storage/unknown':
        return 'An unknown error occurred. Please try again.';
      case 'storage/invalid-format':
        return 'Invalid image format. Please select a valid image file.';
      case 'storage/invalid-argument':
        return 'Invalid upload parameters. Please try again.';
      default:
        return 'Upload failed: ${e.message ?? e.code}';
    }
  }

  // Clean up all active uploads (call on app dispose)
  static void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _progressControllers.clear();
    _activeTasks.clear();
  }
}
