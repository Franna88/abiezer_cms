import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../services/bom_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/common/info_card.dart';
import '../../../providers/user_provider.dart';

class CreateBoMWidget extends StatefulWidget {
  final String projectId;
  final VoidCallback onBomCreated;
  final List<ProjectBoMModel>? existingBomMaterials;

  const CreateBoMWidget({
    super.key,
    required this.projectId,
    required this.onBomCreated,
    this.existingBomMaterials,
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
  final List<String> _categories = [
    'All',
    'Construction',
    'Electrical',
    'Plumbing',
    'Tools'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingBomMaterials != null &&
        widget.existingBomMaterials!.isNotEmpty) {
      _loadExistingBomMaterials();
    }
  }

  Future<void> _loadExistingBomMaterials() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      for (final bomMaterial in widget.existingBomMaterials!) {
        final materialModel =
            await _bomService.getMaterial(bomMaterial.materialId);
        if (materialModel != null && mounted) {
          setState(() {
            _selectedMaterials.add(materialModel);
            _materialQuantities[materialModel.id] = bomMaterial.totalQuantity;
            _materialThresholds[materialModel.id] = bomMaterial.threshold;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
        // Material Catalog Section
        Expanded(
          flex: 2,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.inventory, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Material Catalog', style: AppTextStyles.heading1),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSearchAndFilter(),
                  const SizedBox(height: 16),
                  _buildMaterialCatalog(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Cart Section
        Expanded(
          flex: 3,
          child: Card(
            color: AppColors.background,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text('Selected Materials', style: AppTextStyles.heading1),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCart(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Material Catalog', style: AppTextStyles.heading1),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSearchAndFilter(),
                const SizedBox(height: 16),
                _buildMaterialCatalog(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: AppColors.background,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text('Selected Materials', style: AppTextStyles.heading1),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCart(),
              ],
            ),
          ),
        ),
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
          items: _categories
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: materials.length,
          itemBuilder: (context, index) {
            final material = materials[index];
            final isSelected =
                _selectedMaterials.any((m) => m.id == material.id);
            return Card(
              elevation: 1,
              child: ListTile(
                title: Text(material.name, style: AppTextStyles.heading2),
                subtitle: Text(
                    '${material.category} - ${material.unit} - Stock: ${material.initialStock}'),
                trailing: isSelected
                    ? Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('In Cart',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        backgroundColor: AppColors.success,
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedMaterials.add(material);
                            _materialQuantities[material.id] = 1;
                            _materialThresholds[material.id] = 0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${material.name} added to cart'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              final controller =
                  TextEditingController(text: quantity.toInt().toString());
              return Card(
                color: Colors.grey[50],
                child: ListTile(
                  title: Text(material.name, style: AppTextStyles.heading2),
                  subtitle: Text('${material.category} - ${material.unit}'),
                  leading: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () async {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Material'),
                          content: Text(
                              'Are you sure you want to remove "${material.name}" from the Bill of Materials?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Remove',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (shouldRemove == true) {
                        // If material exists in BOM, remove from Firestore
                        ProjectBoMModel? existing;
                        if (widget.existingBomMaterials != null) {
                          try {
                            existing = widget.existingBomMaterials!
                                .firstWhere((m) => m.materialId == material.id);
                          } catch (_) {
                            existing = null;
                          }
                        }
                        if (existing != null) {
                          setState(() => _isLoading = true);
                          try {
                            await _bomService.removeProjectMaterial(
                                widget.projectId, existing.id);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error removing material: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                        setState(() {
                          _selectedMaterials.removeAt(index);
                          _materialQuantities.remove(material.id);
                          _materialThresholds.remove(material.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${material.name} removed from cart and BOM'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                  ),
                  trailing: SizedBox(
                    width: 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                _materialQuantities[material.id] = quantity - 1;
                              }
                            });
                          },
                        ),
                        SizedBox(
                          width: 48,
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (val) {
                              final numVal = int.tryParse(val);
                              if (numVal != null && numVal > 0) {
                                setState(() {
                                  _materialQuantities[material.id] =
                                      numVal.toDouble();
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _materialQuantities[material.id] = quantity + 1;
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
        if (_selectedMaterials.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Items: ${_selectedMaterials.length}',
                  style: AppTextStyles.body1),
              // Optionally add total cost here if available
            ],
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
                  : Text(widget.existingBomMaterials != null
                      ? 'Update BOM'
                      : 'Create BOM'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _createBom() async {
    if (_selectedMaterials.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one material'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final Map<String, ProjectBoMModel> existingMap = {
      for (var m in widget.existingBomMaterials ?? []) m.materialId: m
    };
    final List<String> updatedMaterialIds = [];
    final List<String> newMaterialIds = [];
    final List<String> removedMaterialIds = [];
    final Map<String, double> diffMap = {};

    try {
      for (final material in _selectedMaterials) {
        final quantity = _materialQuantities[material.id] ?? 1;
        final threshold = _materialThresholds[material.id] ?? 0;

        if (quantity <= 0) {
          throw Exception('Quantity must be greater than 0');
        }

        if (existingMap.containsKey(material.id)) {
          final existing = existingMap[material.id]!;
          final diff = quantity - existing.totalQuantity;
          diffMap[material.name] = diff;

          final projectBom = existing.copyWith(
            totalQuantity: quantity,
            threshold: threshold,
          );

          await _bomService.updateProjectMaterial(
            projectBom,
            userId: userId,
          );
          updatedMaterialIds.add(material.id);
        } else {
          diffMap[material.name] = quantity;
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
          newMaterialIds.add(material.id);
        }
      }

      for (final materialId in existingMap.keys) {
        if (!_selectedMaterials.any((m) => m.id == materialId)) {
          removedMaterialIds.add(materialId);
        }
      }

      if (!mounted) return;
      if (diffMap.isNotEmpty || removedMaterialIds.isNotEmpty) {
        final summaryLines = <String>[];
        summaryLines.addAll(diffMap.entries.map((e) {
          final action = e.value > 0
              ? 'Added'
              : e.value < 0
                  ? 'Subtracted'
                  : 'No Change';
          return '${e.key}: $action ${e.value.abs()}';
        }));

        if (removedMaterialIds.isNotEmpty) {
          for (final removedId in removedMaterialIds) {
            final removedMaterial = widget.existingBomMaterials?.firstWhere(
              (m) => m.materialId == removedId,
              orElse: () => ProjectBoMModel(
                id: '',
                projectId: '',
                materialId: removedId,
                totalQuantity: 0,
                usedQuantity: 0,
                threshold: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
            if (removedMaterial != null) {
              summaryLines.add('${removedMaterial.materialId}: Deleted');
            }
          }
        }

        final summary = summaryLines.join('\n');
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('BOM Update Summary'),
            content: SingleChildScrollView(
              child: Text(summary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      widget.onBomCreated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error ${widget.existingBomMaterials != null ? 'updating' : 'creating'} BOM: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
