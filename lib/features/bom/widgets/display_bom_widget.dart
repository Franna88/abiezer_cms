import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../models/request_model.dart';
import '../../../models/material_history_model.dart';
import '../../../services/bom_service.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/common/info_card.dart';

class DisplayBoMWidget extends StatefulWidget {
  final String projectId;
  final VoidCallback onBomUpdated;

  const DisplayBoMWidget({
    super.key,
    required this.projectId,
    required this.onBomUpdated,
  });

  @override
  State<DisplayBoMWidget> createState() => _DisplayBoMWidgetState();
}

class _DisplayBoMWidgetState extends State<DisplayBoMWidget> {
  final BoMService _bomService = BoMService();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBomSummary(),
          const SizedBox(height: 16),
          _buildBomList(),
          const SizedBox(height: 24),
          _buildMaterialRequests(),
        ],
      ),
    );
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
        final allFinished = materials.every((m) => m.remainingQuantity <= 0);
        final lowStock =
            materials.any((m) => m.isLowStock && m.remainingQuantity > 0);
        String status = allFinished
            ? 'All Finished'
            : lowStock
                ? 'Low Stock'
                : 'In Progress';
        Color statusColor = allFinished
            ? Colors.green
            : lowStock
                ? Colors.orange
                : Colors.blue;
        return Card(
          color: statusColor.withOpacity(0.08),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Chip(
                  label:
                      Text(status, style: const TextStyle(color: Colors.white)),
                  backgroundColor: statusColor,
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
                    final lowStock = material.isLowStock && !finished;
                    final statusColor = finished
                        ? Colors.green
                        : lowStock
                            ? Colors.orange
                            : Colors.blue;
                    final statusLabel = finished
                        ? 'Finished'
                        : lowStock
                            ? 'Low Stock'
                            : 'OK';
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (mat != null)
                                        Text(
                                          '${mat.category} - ${mat.unit}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                              'Total: ${material.totalQuantity}'),
                                          const SizedBox(width: 12),
                                          Text(
                                              'Used: ${material.usedQuantity}'),
                                          const SizedBox(width: 12),
                                          Text(
                                              'Remaining: ${material.remainingQuantity}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Chip(
                                  label: Text(statusLabel,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: statusColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: material.totalQuantity == 0
                                  ? 0
                                  : (material.usedQuantity /
                                          material.totalQuantity)
                                      .clamp(0, 1),
                              minHeight: 8,
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: finished
                                      ? null
                                      : () => _showRequestDialog(material),
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Request More'),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: finished
                                      ? null
                                      : () => _showAdjustDialog(material),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Adjust'),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _showAuditTrail[material.materialId] =
                                          !(_showAuditTrail[
                                                  material.materialId] ??
                                              false);
                                    });
                                  },
                                  icon: Icon(
                                      _showAuditTrail[material.materialId] ==
                                              true
                                          ? Icons.expand_less
                                          : Icons.expand_more),
                                  label: const Text('Audit Trail'),
                                ),
                              ],
                            ),
                            if (_showAuditTrail[material.materialId] == true)
                              _buildAuditTrail(material),
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

  Widget _buildMaterialRequests() {
    return StreamBuilder<List<RequestModel>>(
      stream: _bomService.getProjectRequests(widget.projectId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading requests: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data!;

        if (requests.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Requests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  child: ListTile(
                    title: Text(request.materialName),
                    subtitle: Text(
                      'Quantity: ${request.quantity} ${request.unit}\nReason: ${request.reason}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        request.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(request.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
