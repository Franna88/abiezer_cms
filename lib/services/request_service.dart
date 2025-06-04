import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';
import '../utils/dev_data.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool _useMockData = true; // Set to false for production

  // Initialize Firestore settings for offline support
  RequestService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  // Get requests for a specific user
  Stream<List<RequestModel>> getRequestsForUser(String userId) {
    if (_useMockData) {
      // Use mock data for development
      return Stream.value(
        DevData.requests.where((req) => req.requestedBy == userId).toList(),
      );
    }

    return _firestore
        .collection('requests')
        .where('requestedBy', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => RequestModel.fromFirestore(doc))
                  .toList(),
        );
  }

  // Get pending requests for a specific user
  Future<List<RequestModel>> getPendingRequestsForUser(String userId) async {
    if (_useMockData) {
      // Use mock data for development
      return DevData.requests
          .where((req) => req.requestedBy == userId && req.status == 'pending')
          .toList();
    }

    try {
      final snapshot =
          await _firestore
              .collection('requests')
              .where('requestedBy', isEqualTo: userId)
              .where('status', isEqualTo: 'pending')
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => RequestModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting pending requests: $e');
      return [];
    }
  }

  // Create a new request
  Future<String?> createRequest({
    required String type,
    required String materialId,
    required String materialName,
    required double quantity,
    required String unit,
    required String projectId,
    required String requestedBy,
    String? reason,
    String? photoUrl,
  }) async {
    if (_useMockData) {
      // Add to mock data
      final newRequest = RequestModel(
        id: 'req-${DevData.requests.length + 1}',
        type: type,
        materialId: materialId,
        materialName: materialName,
        quantity: quantity,
        unit: unit,
        projectId: projectId,
        requestedBy: requestedBy,
        status: 'pending',
        timestamp: DateTime.now(),
        approvedBy: '',
        reason: reason,
        photoUrl: photoUrl,
        rejectionReason: '',
      );
      DevData.requests.add(newRequest);
      return newRequest.id;
    }

    try {
      final request = RequestModel(
        id: '',
        type: type,
        materialId: materialId,
        materialName: materialName,
        quantity: quantity,
        unit: unit,
        projectId: projectId,
        requestedBy: requestedBy,
        status: 'pending',
        timestamp: DateTime.now(),
        approvedBy: '',
        approvedAt: null,
        reason: reason,
        photoUrl: photoUrl,
        rejectionReason: '',
      );

      final docRef = await _firestore
          .collection('requests')
          .add(request.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating request: $e');
      return null;
    }
  }

  // Get pending requests count for a user
  Future<int> getPendingRequestsCount(String userId) async {
    if (_useMockData) {
      // Use mock data for development
      return DevData.requests
          .where((req) => req.requestedBy == userId && req.status == 'pending')
          .length;
    }

    try {
      final snapshot =
          await _firestore
              .collection('requests')
              .where('requestedBy', isEqualTo: userId)
              .where('status', isEqualTo: 'pending')
              .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting pending requests count: $e');
      return 0;
    }
  }
}
