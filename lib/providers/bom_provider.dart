import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bill_of_materials.dart';
import '../models/material_movement.dart';

class BomProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BillOfMaterials? _currentBom;
  List<MaterialMovement> _movements = [];
  bool _isLoading = false;
  String? _error;

  BillOfMaterials? get currentBom => _currentBom;
  List<MaterialMovement> get movements => _movements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBomForProject(String projectId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final bomDoc =
          await _firestore.collection('billOfMaterials').doc(projectId).get();

      if (bomDoc.exists) {
        _currentBom = BillOfMaterials.fromFirestore(bomDoc);
      } else {
        _currentBom = null;
      }

      // Load movements
      final movementsSnapshot = await _firestore
          .collection('materialMovements')
          .doc(projectId)
          .collection('movements')
          .orderBy('timestamp', descending: true)
          .get();

      _movements = movementsSnapshot.docs
          .map((doc) => MaterialMovement.fromFirestore(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBom(
      String projectId, String userId, List<BomMaterial> materials) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final bom = BillOfMaterials(
        projectId: projectId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: userId,
        status: 'active',
        materials: materials,
      );

      await _firestore
          .collection('billOfMaterials')
          .doc(projectId)
          .set(bom.toMap());

      _currentBom = bom;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordMaterialMovement({
    required String projectId,
    required String materialId,
    required MovementType actionType,
    required double quantity,
    required String performedBy,
    required String performedByRole,
    required String notes,
    String? location,
    String? reference,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get current material stock
      final bomDoc =
          await _firestore.collection('billOfMaterials').doc(projectId).get();

      if (!bomDoc.exists) {
        throw Exception('BOM not found for project');
      }

      final bom = BillOfMaterials.fromFirestore(bomDoc);
      final material = bom.materials.firstWhere(
        (m) => m.materialId == materialId,
        orElse: () => throw Exception('Material not found in BOM'),
      );

      final previousQuantity = material.currentStock;
      double newQuantity;

      switch (actionType) {
        case MovementType.add:
          newQuantity = previousQuantity + quantity;
          break;
        case MovementType.remove:
          newQuantity = previousQuantity - quantity;
          break;
        case MovementType.use:
          newQuantity = previousQuantity - quantity;
          break;
      }

      // Create movement record
      final movementRef = _firestore
          .collection('materialMovements')
          .doc(projectId)
          .collection('movements')
          .doc();

      final movement = MaterialMovement(
        movementId: movementRef.id,
        projectId: projectId,
        materialId: materialId,
        timestamp: DateTime.now(),
        actionType: actionType,
        quantity: quantity,
        previousQuantity: previousQuantity,
        newQuantity: newQuantity,
        performedBy: performedBy,
        performedByRole: performedByRole,
        notes: notes,
        location: location,
        reference: reference,
      );

      // Update BOM material stock
      final updatedMaterials = bom.materials.map((m) {
        if (m.materialId == materialId) {
          return BomMaterial(
            materialId: m.materialId,
            name: m.name,
            quantity: m.quantity,
            unit: m.unit,
            currentStock: newQuantity,
            initialQuantity: m.initialQuantity,
            unitPrice: m.unitPrice,
            totalCost: m.totalCost,
          );
        }
        return m;
      }).toList();

      // Update BOM
      await _firestore.collection('billOfMaterials').doc(projectId).update({
        'materials': updatedMaterials.map((m) => m.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Save movement
      await movementRef.set(movement.toMap());

      // Update local state
      _currentBom = BillOfMaterials(
        projectId: bom.projectId,
        createdAt: bom.createdAt,
        updatedAt: DateTime.now(),
        createdBy: bom.createdBy,
        status: bom.status,
        materials: updatedMaterials,
      );

      _movements.insert(0, movement);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
