import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/material_model.dart';
import '../models/project_bom_model.dart';
import '../models/material_history_model.dart';
import '../models/request_model.dart';
import 'package:rxdart/rxdart.dart';

class BoMService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Material Catalog Operations
  Stream<List<MaterialModel>> getMaterials() {
    return _firestore.collection('materials').orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => MaterialModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addMaterial(MaterialModel material) {
    return _firestore.collection('materials').add(material.toFirestore());
  }

  Future<void> updateMaterial(MaterialModel material) {
    return _firestore
        .collection('materials')
        .doc(material.id)
        .update(material.toFirestore());
  }

  Future<void> deleteMaterial(String materialId) async {
    // Start a batch operation
    final batch = _firestore.batch();

    // Get all projects that might be using this material
    final projectsSnapshot = await _firestore.collection('projects').get();

    // Remove material from all project BoMs
    for (var project in projectsSnapshot.docs) {
      final bomRef = _firestore
          .collection('projects')
          .doc(project.id)
          .collection('bom')
          .where('materialId', isEqualTo: materialId);

      final bomDocs = await bomRef.get();
      for (var doc in bomDocs.docs) {
        batch.delete(doc.reference);
      }
    }

    // Delete material history
    final historyRef = _firestore
        .collection('material_history')
        .where('materialId', isEqualTo: materialId);
    final historyDocs = await historyRef.get();
    for (var doc in historyDocs.docs) {
      batch.delete(doc.reference);
    }

    // Delete the material itself
    batch.delete(_firestore.collection('materials').doc(materialId));

    // Commit all deletions in one batch
    await batch.commit();
  }

  // Project BoM Operations
  Stream<List<ProjectBoMModel>> getProjectBoM(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('bom')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectBoMModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addProjectMaterial(ProjectBoMModel projectMaterial) {
    return _firestore
        .collection('projects')
        .doc(projectMaterial.projectId)
        .collection('bom')
        .add(projectMaterial.toFirestore());
  }

  Future<void> updateProjectMaterial(ProjectBoMModel projectMaterial,
      {required String userId}) async {
    final bomRef = _firestore
        .collection('projects')
        .doc(projectMaterial.projectId)
        .collection('bom')
        .doc(projectMaterial.id);
    final historyRef = _firestore
        .collection('projects')
        .doc(projectMaterial.projectId)
        .collection('bom_history')
        .doc();
    final auditRef = _firestore.collection('audit_log').doc();

    final doc = await bomRef.get();
    if (doc.exists) {
      // Save old version to history
      await historyRef.set({
        'materialId': doc['materialId'],
        'projectId': doc['projectId'],
        'totalQuantity': doc['totalQuantity'],
        'usedQuantity': doc['usedQuantity'],
        'threshold': doc['threshold'],
        'createdAt': doc['createdAt'],
        'updatedAt': doc['updatedAt'],
        'versionedAt': FieldValue.serverTimestamp(),
        'versionedBy': userId,
      });
      // Update the BOM
      await bomRef.update(projectMaterial.toFirestore());
    } else {
      // Create the BOM if it doesn't exist
      await bomRef.set(projectMaterial.toFirestore());
    }
    // Write audit log
    await auditRef.set({
      'action': 'update_bom_material',
      'userId': userId,
      'materialId': projectMaterial.materialId,
      'projectId': projectMaterial.projectId,
      'timestamp': FieldValue.serverTimestamp(),
      'details': projectMaterial.toFirestore(),
    });
  }

  Future<void> setProjectMaterial(ProjectBoMModel projectMaterial) {
    return _firestore
        .collection('projects')
        .doc(projectMaterial.projectId)
        .collection('bom')
        .doc(projectMaterial.id)
        .set(projectMaterial.toFirestore());
  }

  Future<void> adjustQuantity(
    String projectId,
    String materialId,
    double newQuantity,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('bom')
        .doc(materialId)
        .update({
      'totalQuantity': newQuantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setThreshold(
    String projectId,
    String materialId,
    double threshold,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('bom')
        .doc(materialId)
        .update({
      'threshold': threshold,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Material History Operations
  Stream<List<MaterialHistoryModel>> getMaterialHistory(String materialId) {
    return _firestore
        .collection('material_history')
        .where('materialId', isEqualTo: materialId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MaterialHistoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> logMaterialHistory(MaterialHistoryModel history) {
    return _firestore.collection('material_history').add(history.toFirestore());
  }

  // Get total stock level for a material across all projects
  Stream<double> getMaterialStockLevel(String materialId) {
    return _firestore.collection('projects').get().asStream().asyncMap((
      projects,
    ) async {
      double totalStock = 0;

      for (var project in projects.docs) {
        final bomDoc = await _firestore
            .collection('projects')
            .doc(project.id)
            .collection('bom')
            .where('materialId', isEqualTo: materialId)
            .get();

        if (bomDoc.docs.isNotEmpty) {
          final projectBom = ProjectBoMModel.fromFirestore(bomDoc.docs.first);
          totalStock += projectBom.remainingQuantity;
        }
      }

      return totalStock;
    });
  }

  // Audit Trail Operations
  Future<void> logAction(
    String action,
    String userId,
    String materialId, {
    String? projectId,
  }) {
    return _firestore.collection('audit_log').add({
      'action': action,
      'userId': userId,
      'materialId': materialId,
      'projectId': projectId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Material Stock Operations
  Future<void> addStock(
    String materialId,
    double quantity, {
    String? reason,
    String? photoUrl,
  }) async {
    final batch = _firestore.batch();

    // Update material stock
    final materialRef = _firestore.collection('materials').doc(materialId);
    batch.update(materialRef, {
      'initialStock': FieldValue.increment(quantity),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Log history
    final historyRef = _firestore.collection('material_history').doc();
    final history = MaterialHistoryModel(
      id: historyRef.id,
      materialId: materialId,
      projectId: '', // Empty for general stock
      projectName: 'Stock Addition',
      quantity: quantity,
      date: DateTime.now(),
      userId: 'currentUser', // TODO: Get from auth
      action: 'added',
    );
    batch.set(historyRef, history.toFirestore());

    // Create request if needed
    if (reason != null) {
      final requestRef = _firestore.collection('requests').doc();
      final request = RequestModel(
        id: requestRef.id,
        type: 'purchase',
        materialId: materialId,
        materialName: '', // TODO: Get material name
        quantity: quantity,
        unit: '', // TODO: Get from material
        projectId: '',
        requestedBy: 'currentUser', // TODO: Get from auth
        status: 'pending',
        timestamp: DateTime.now(),
        approvedBy: '',
        reason: reason,
        photoUrl: photoUrl,
      );
      batch.set(requestRef, request.toMap());
    }

    await batch.commit();
  }

  // Get current stock level for a material (not including project allocations)
  Stream<double> getCurrentStock(String materialId) {
    return _firestore
        .collection('materials')
        .doc(materialId)
        .snapshots()
        .map((doc) => (doc.data()?['initialStock'] ?? 0.0).toDouble());
  }

  // Calculate available stock (current stock minus allocated to projects)
  Stream<double> getAvailableStock(String materialId) {
    return _firestore.collection('projects').get().asStream().asyncMap((
      projects,
    ) async {
      // Get current stock
      final materialDoc =
          await _firestore.collection('materials').doc(materialId).get();
      double currentStock =
          (materialDoc.data()?['initialStock'] ?? 0.0).toDouble();

      // Subtract allocated stock
      for (var project in projects.docs) {
        final bomDoc = await _firestore
            .collection('projects')
            .doc(project.id)
            .collection('bom')
            .where('materialId', isEqualTo: materialId)
            .get();

        if (bomDoc.docs.isNotEmpty) {
          final projectBom = ProjectBoMModel.fromFirestore(bomDoc.docs.first);
          currentStock -= projectBom.totalQuantity;
        }
      }

      return currentStock;
    });
  }

  // Get materials for a specific project
  Stream<List<ProjectBoMModel>> getProjectMaterials(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('bom')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectBoMModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get material requests for a project
  Stream<List<RequestModel>> getProjectRequests(String projectId) {
    return _firestore
        .collection('requests')
        .where('projectId', isEqualTo: projectId)
        .where('type', isEqualTo: 'material')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RequestModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Create a new material request
  Future<void> createRequest(RequestModel request) {
    return _firestore
        .collection('requests')
        .doc(request.id)
        .set(request.toMap());
  }

  Future<MaterialModel?> getMaterialById(String materialId) async {
    final doc = await _firestore.collection('materials').doc(materialId).get();
    if (doc.exists) {
      return MaterialModel.fromFirestore(doc);
    }
    return null;
  }

  Future<MaterialModel?> getMaterial(String materialId) async {
    try {
      final doc =
          await _firestore.collection('materials').doc(materialId).get();
      if (doc.exists) {
        return MaterialModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting material: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProjectBom(String projectId) async {
    try {
      final doc =
          await _firestore.collection('billOfMaterials').doc(projectId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting project BOM: $e');
      return null;
    }
  }

  Future<void> updateProjectBom(ProjectBoMModel projectBom) async {
    try {
      await _firestore
          .collection('billOfMaterials')
          .doc(projectBom.projectId)
          .collection('materials')
          .doc(projectBom.materialId)
          .set(projectBom.toFirestore());
    } catch (e) {
      print('Error updating project material: $e');
      rethrow;
    }
  }

  Future<void> removeProjectMaterial(
      String projectId, String materialId) async {
    await _firestore
        .collection('projects')
        .doc(projectId)
        .collection('bom')
        .doc(materialId)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getProjectAuditTrail(String projectId) {
    final auditLogStream = _firestore
        .collection('audit_log')
        .where('projectId', isEqualTo: projectId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'type': data['action'] ?? 'edit_bom',
                'timestamp': (data['timestamp'] as Timestamp).toDate(),
                'user': data['userId'] ?? '',
                'description':
                    'BOM Edit: ' + (data['details']?.toString() ?? ''),
              };
            }).toList());

    final materialHistoryStream = _firestore
        .collection('material_history')
        .where('projectId', isEqualTo: projectId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'type': data['action'] ?? 'use_material',
                'timestamp': (data['date'] as Timestamp).toDate(),
                'user': data['userId'] ?? '',
                'description': 'Material History: ' +
                    (data['quantity']?.toString() ?? '') +
                    ' units',
              };
            }).toList());

    final materialMovementsStream = _firestore
        .collection('materialMovements')
        .doc(projectId)
        .collection('movements')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'type': data['actionType'] ?? 'use_material',
                'timestamp': (data['timestamp'] as Timestamp).toDate(),
                'user': data['performedBy'] ?? '',
                'description': 'Material Movement: ' +
                    (data['quantity']?.toString() ?? '') +
                    ' units',
              };
            }).toList());

    return Rx.combineLatest3<
        List<Map<String, dynamic>>,
        List<Map<String, dynamic>>,
        List<Map<String, dynamic>>,
        List<Map<String, dynamic>>>(
      auditLogStream,
      materialHistoryStream,
      materialMovementsStream,
      (audit, history, movements) {
        final all = [...audit, ...history, ...movements];
        all.sort((a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
        return all;
      },
    );
  }
}
