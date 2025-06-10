import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../models/request_model.dart';
import '../../../models/material_history_model.dart';
import '../../../models/project.dart';
import '../../../services/bom_service.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/common/info_card.dart';
import '../../../screens/bom/edit_bom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../providers/user_provider.dart';

class DisplayBoMWidget extends StatefulWidget {
  final String projectId;
  final VoidCallback onBomUpdated;
  final bool isEditable;

  const DisplayBoMWidget({
    super.key,
    required this.projectId,
    required this.onBomUpdated,
    this.isEditable = true,
  });

  @override
  State<DisplayBoMWidget> createState() => _DisplayBoMWidgetState();
}

class _DisplayBoMWidgetState extends State<DisplayBoMWidget> {
  final BoMService _bomService = BoMService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _error;
  final _requestQuantityController = TextEditingController();
  final _requestReasonController = TextEditingController();
  Map<String, bool> _showAuditTrail = {};

  @override
  void dispose() {
    _requestQuantityController.dispose();
    _requestReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'Bill of Materials',
      actions: [
        if (widget.isEditable)
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _navigateToEditBom,
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Edit Bill of Materials',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 2,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showProjectAuditTrail,
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text('Audit Trail',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 2,
                ),
              ),
            ],
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBomSummary(),
          const SizedBox(height: 16),
          _buildBomList(),
        ],
      ),
    );
  }

  Future<void> _navigateToEditBom() async {
    try {
      // Fetch project details
      final projectDoc =
          await _firestore.collection('projects').doc(widget.projectId).get();
      if (!projectDoc.exists) throw Exception('Project not found');
      final project = Project.fromFirestore(projectDoc);

      // Fetch BOM materials from the correct subcollection
      final bomSnapshot = await _firestore
          .collection('projects')
          .doc(widget.projectId)
          .collection('bom')
          .get();
      final bomMaterials = bomSnapshot.docs
          .map((doc) => ProjectBoMModel.fromFirestore(doc))
          .toList();

      // Navigate to edit screen, passing the list
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditBomScreen(
            project: project,
            existingBomMaterials: bomMaterials,
          ),
        ),
      );

      if (result == true) widget.onBomUpdated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading BOM: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showProjectAuditTrail() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill of Materials Audit Trail'),
        content: SizedBox(
          width: 500,
          height: 500,
          child: _buildProjectAuditTrail(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectAuditTrail() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _bomService.getProjectAuditTrail(widget.projectId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Error loading audit trail: \\${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final events = snapshot.data!;
        if (events.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No audit trail events for this project.'),
          );
        }
        // Fetch all users and all materials for name resolution
        return FutureBuilder<Map<String, String>>(
          future: _fetchUserAndMaterialNames(),
          builder: (context, nameSnapshot) {
            final nameMap = nameSnapshot.data ?? {};
            return ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  leading: Icon(_getAuditIcon(event['type'])),
                  title: Text(_formatAuditDescription(event, nameMap)),
                  subtitle: Text(
                      'By: \\${_formatUser(event['user'], nameMap)} • \\${_formatTimestamp(event['timestamp'])}'),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, String>> _fetchUserAndMaterialNames() async {
    final usersSnap =
        await FirebaseFirestore.instance.collection('users').get();
    final materialsSnap =
        await FirebaseFirestore.instance.collection('materials').get();
    final Map<String, String> nameMap = {};
    for (final doc in usersSnap.docs) {
      nameMap[doc.id] = doc.data()['name'] ?? doc.id;
    }
    for (final doc in materialsSnap.docs) {
      nameMap[doc.id] = doc.data()['name'] ?? doc.id;
    }
    return nameMap;
  }

  String _formatAuditDescription(
      Map<String, dynamic> event, Map<String, String> nameMap) {
    final type = event['type'] ?? '';
    final desc = event['description'] ?? '';
    if (desc.startsWith('BOM Edit:')) {
      final details = _parseDetails(desc.replaceFirst('BOM Edit: ', ''));
      final materialId = details['materialId'] ?? '';
      final material = nameMap[materialId] ?? materialId;
      final total = details['totalQuantity'] ?? details['total'] ?? '';
      final used = details['usedQuantity'] ?? details['used'] ?? '';
      final threshold = details['threshold'] ?? '';
      // Check for old and new values for diff
      final oldTotal = details['oldTotalQuantity'] ?? details['oldTotal'] ?? '';
      final newTotal = details['newTotalQuantity'] ?? details['newTotal'] ?? '';
      if (oldTotal != '' && newTotal != '') {
        final diff =
            double.tryParse(newTotal) ?? 0 - (double.tryParse(oldTotal) ?? 0);
        if (diff > 0) {
          return "+$diff $material added (total now $newTotal, used: $used, threshold: $threshold).";
        } else if (diff < 0) {
          return "$material: ${diff.abs()} removed (total now $newTotal, used: $used, threshold: $threshold).";
        } else {
          return "$material: No change (total remains $newTotal, used: $used, threshold: $threshold).";
        }
      }
      if (material.isNotEmpty && total != '') {
        return "Material '$material' total set to $total, used: $used, threshold: $threshold.";
      }
      return 'Bill of Materials updated.';
    } else if (desc.startsWith('Material History:')) {
      final qty = desc.replaceFirst('Material History: ', '');
      return 'Material used: $qty.';
    } else if (desc.startsWith('Material Movement:')) {
      final qty = desc.replaceFirst('Material Movement: ', '');
      return 'Material moved: $qty.';
    } else if (event['changes'] != null && event['changes'] is Map) {
      // If changes map is present, show diffs for each field
      final changes = event['changes'] as Map;
      final List<String> diffs = [];
      changes.forEach((key, value) {
        if (value is Map &&
            value.containsKey('old') &&
            value.containsKey('new')) {
          final oldVal = value['old'];
          final newVal = value['new'];
          if (oldVal != newVal) {
            diffs.add("$key changed from $oldVal to $newVal");
          }
        }
      });
      if (diffs.isNotEmpty) {
        return diffs.join(", ");
      }
    }
    // fallback
    return desc;
  }

  String _formatUser(dynamic userId, Map<String, String> nameMap) {
    if (userId == null || userId.toString().isEmpty) return 'Unknown';
    return nameMap[userId.toString()] ?? userId.toString();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    }
    return timestamp?.toString() ?? '';
  }

  Map<String, dynamic> _parseDetails(String detailsStr) {
    // Very basic parser for {key: value, ...} string
    final map = <String, dynamic>{};
    final regex = RegExp(r'(\w+): ([^,}]+)');
    for (final match in regex.allMatches(detailsStr)) {
      map[match.group(1)!] = match.group(2)!.trim();
    }
    return map;
  }

  IconData _getAuditIcon(String type) {
    switch (type) {
      case 'edit_bom':
        return Icons.edit;
      case 'add_material':
        return Icons.add_circle_outline;
      case 'remove_material':
        return Icons.remove_circle_outline;
      case 'use_material':
        return Icons.inventory_2;
      default:
        return Icons.history;
    }
  }

  Widget _buildBomSummary() {
    return StreamBuilder<List<ProjectBoMModel>>(
      stream: _bomService.getProjectMaterials(widget.projectId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final materials = snapshot.data!;
        if (materials.isEmpty) return const SizedBox.shrink();
        final total =
            materials.fold<double>(0, (sum, m) => sum + m.totalQuantity);
        final used =
            materials.fold<double>(0, (sum, m) => sum + m.usedQuantity);
        final remaining =
            materials.fold<double>(0, (sum, m) => sum + m.remainingQuantity);
        return Card(
          color: Colors.grey[300],
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Materials: $total',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Used: $used'),
                    Text('Remaining: $remaining'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBomList() {
    return StreamBuilder<List<ProjectBoMModel>>(
      stream: _bomService.getProjectMaterials(widget.projectId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading BOM: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final materials = snapshot.data!;
        if (materials.isEmpty) {
          return const Center(
            child: Text(
              'No materials in BOM',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Materials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material = materials[index];
                return FutureBuilder<MaterialModel?>(
                  future: _bomService.getMaterialById(material.materialId),
                  builder: (context, snapshot) {
                    final mat = snapshot.data;
                    final finished = material.remainingQuantity <= 0;
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mat?.name ?? material.materialId,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (mat != null)
                                        Text(
                                          '${mat.category} - ${mat.unit}',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                              'Total: ${material.totalQuantity}',
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                          const SizedBox(width: 10),
                                          Text('Used: ${material.usedQuantity}',
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                          const SizedBox(width: 10),
                                          Text(
                                              'Remaining: ${material.remainingQuantity}',
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: material.totalQuantity == 0
                                        ? 0
                                        : (material.usedQuantity /
                                                material.totalQuantity)
                                            .clamp(0, 1),
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TextButton.icon(
                                  onPressed: finished
                                      ? null
                                      : () => _showAdjustDialog(material),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Adjust',
                                      style: TextStyle(fontSize: 14)),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    minimumSize: const Size(0, 36),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton.icon(
                                  onPressed: () {
                                    _showAuditTrailDialog(material);
                                  },
                                  icon: const Icon(Icons.history, size: 18),
                                  label: const Text('Audit Trail',
                                      style: TextStyle(fontSize: 14)),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    minimumSize: const Size(0, 36),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAuditTrailDialog(ProjectBoMModel material) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adjustment History'),
        content: SizedBox(
          width: 400,
          child: _buildAuditTrail(material),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTrail(ProjectBoMModel material) {
    return StreamBuilder<List<MaterialHistoryModel>>(
      stream: _bomService.getMaterialHistory(material.materialId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Error loading audit trail: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          );
        }
        final history = snapshot.data!;
        if (history.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No audit trail for this material.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Adjustment History:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              ...history.map((entry) => ListTile(
                    dense: true,
                    leading: Icon(
                      entry.action == 'used'
                          ? Icons.remove_circle_outline
                          : entry.action == 'added'
                              ? Icons.add_circle_outline
                              : Icons.edit,
                      color: entry.action == 'used'
                          ? Colors.red
                          : entry.action == 'added'
                              ? Colors.green
                              : Colors.blue,
                    ),
                    title:
                        Text('${entry.action.toUpperCase()} ${entry.quantity}'),
                    subtitle:
                        Text('By: ${entry.userId} • ${entry.date.toLocal()}'),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRequestDialog(ProjectBoMModel material) async {
    _requestQuantityController.clear();
    _requestReasonController.clear();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Additional Materials'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _requestQuantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _requestReasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantity = double.tryParse(_requestQuantityController.text);
              final reason = _requestReasonController.text;

              if (quantity == null || quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid quantity'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a reason'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await _bomService.createRequest(
                  RequestModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: 'material',
                    materialId: material.materialId,
                    materialName: '', // TODO: Get material name
                    quantity: quantity,
                    unit: '', // TODO: Get material unit
                    projectId: widget.projectId,
                    requestedBy: '', // TODO: Get current user
                    status: 'pending',
                    timestamp: DateTime.now(),
                    approvedBy: '',
                    reason: reason,
                  ),
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Request submitted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error submitting request: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAdjustDialog(ProjectBoMModel material) async {
    final quantityController = TextEditingController(
      text: material.totalQuantity.toString(),
    );
    final thresholdController = TextEditingController(
      text: material.threshold.toString(),
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adjust Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: thresholdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Low Stock Threshold',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantity = double.tryParse(quantityController.text);
              final threshold = double.tryParse(thresholdController.text);

              if (quantity == null || quantity < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid quantity'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (threshold == null || threshold < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid threshold'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await _bomService.adjustQuantity(
                  widget.projectId,
                  material.materialId,
                  quantity,
                );

                await _bomService.setThreshold(
                  widget.projectId,
                  material.materialId,
                  threshold,
                );

                if (mounted) {
                  Navigator.pop(context);
                  widget.onBomUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Material adjusted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adjusting material: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
