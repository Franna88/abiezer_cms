import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../services/bom_service.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/common/info_card.dart';

class CreateBoMWidget extends StatefulWidget {
  final String projectId;
  final VoidCallback onBomCreated;

  const CreateBoMWidget({
    super.key,
    required this.projectId,
    required this.onBomCreated,
  });

  @override
  State<CreateBoMWidget> createState() => _CreateBoMWidgetState();
}

class _CreateBoMWidgetState extends State<CreateBoMWidget> {
  final BoMService _bomService = BoMService();
  final List<MaterialModel> _selectedMaterials = [];
  final Map<String, double> _materialQuantities = {};
  final Map<String, double> _materialThresholds = {};
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return InfoCard(
      title: 'Create Bill of Materials',
      child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Material Catalog (Left)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchAndFilter(),
              const SizedBox(height: 16),
              _buildMaterialCatalog(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Cart (Right)
        Expanded(
          flex: 3,
          child: _buildCart(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchAndFilter(),
        const SizedBox(height: 16),
        _buildMaterialCatalog(),
        const SizedBox(height: 24),
        _buildCart(),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _selectedCategory,
          items: ['All', 'Construction', 'Electrical', 'Plumbing', 'Tools']
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedCategory = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMaterialCatalog() {
    return StreamBuilder<List<MaterialModel>>(
      stream: _bomService.getMaterials(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading materials: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final materials = snapshot.data!
            .where((material) =>
                (_selectedCategory == 'All' ||
                    material.category == _selectedCategory) &&
                (_searchQuery.isEmpty ||
                    material.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase())))
            .toList();

        if (materials.isEmpty) {
          return const Center(
            child: Text(
              'No materials found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Catalog',
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
                final isSelected =
                    _selectedMaterials.any((m) => m.id == material.id);
                final quantity = _materialQuantities[material.id] ?? 1;
                return Card(
                  child: ListTile(
                    title: Text(material.name),
                    subtitle: Text(
                        '${material.category} - ${material.unit} - Stock: ${material.initialStock}'),
                    trailing: isSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    final current =
                                        _materialQuantities[material.id] ?? 1;
                                    if (current > 1) {
                                      _materialQuantities[material.id] =
                                          current - 1;
                                    }
                                  });
                                },
                              ),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '${_materialQuantities[material.id]?.toInt() ?? 1}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    _materialQuantities[material.id] =
                                        (quantity + 1);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green),
                                onPressed: null,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    _selectedMaterials.add(material);
                                    _materialQuantities[material.id] = 1;
                                    _materialThresholds[material.id] = 0;
                                  });
                                },
                              ),
                            ],
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

  Widget _buildCart() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Materials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedMaterials.isEmpty)
              const Center(
                child: Text(
                  'No materials selected',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedMaterials.length,
                itemBuilder: (context, index) {
                  final material = _selectedMaterials[index];
                  final quantity = _materialQuantities[material.id] ?? 1;
                  return Card(
                    color: Colors.grey[50],
                    child: ListTile(
                      title: Text(material.name),
                      subtitle: Text('${material.category} - ${material.unit}'),
                      leading: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            _selectedMaterials.removeAt(index);
                            _materialQuantities.remove(material.id);
                            _materialThresholds.remove(material.id);
                          });
                        },
                      ),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    _materialQuantities[material.id] =
                                        quantity - 1;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                quantity.toInt().toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _materialQuantities[material.id] =
                                      quantity + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedMaterials.clear();
                      _materialQuantities.clear();
                      _materialThresholds.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createBom,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create BOM'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBom() async {
    if (_selectedMaterials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one material'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      for (final material in _selectedMaterials) {
        final quantity = _materialQuantities[material.id] ?? 1;
        final threshold = _materialThresholds[material.id] ?? 0;

        if (quantity <= 0) {
          throw Exception('Quantity must be greater than 0');
        }

        final projectBom = ProjectBoMModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          projectId: widget.projectId,
          materialId: material.id,
          totalQuantity: quantity,
          usedQuantity: 0,
          threshold: threshold,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _bomService.setProjectMaterial(projectBom);

        // Check if material needs to be added to purchase list
        if (material.initialStock < quantity) {
          await _bomService.addStock(
            material.id,
            quantity - material.initialStock,
            reason: 'Initial stock for project ${widget.projectId}',
          );
        }
      }

      widget.onBomCreated();
    } catch (e) {
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating BOM: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
