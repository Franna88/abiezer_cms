import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/material_model.dart';
import '../../../models/project_bom_model.dart';
import '../../../services/bom_service.dart';
import '../../../widgets/common/responsive_table.dart';
import '../../../widgets/bom/material_form.dart';
import '../../../widgets/bom/search_filter_bar.dart';
import '../../../widgets/bom/material_card.dart';
import '../widgets/project_bom_view.dart';

class AdminBoMScreen extends StatefulWidget {
  const AdminBoMScreen({super.key});

  @override
  State<AdminBoMScreen> createState() => _AdminBoMScreenState();
}

class _AdminBoMScreenState extends State<AdminBoMScreen> {
  final BoMService _bomService = BoMService();
  bool _showCatalog = true;
  bool _showAddForm = false;
  MaterialModel? _selectedMaterial;
  bool _isLoading = false;
  String _selectedProjectId = ''; // TODO: Get from project selector

  // Search and filter state
  String _searchQuery = '';
  String? _selectedCategory;

  void _toggleView() {
    setState(() {
      _showCatalog = !_showCatalog;
      _showAddForm = false;
      _selectedMaterial = null;
      _searchQuery = '';
      _selectedCategory = null;
    });
  }

  void _toggleAddForm() {
    setState(() {
      _showAddForm = !_showAddForm;
      _selectedMaterial = null;
    });
  }

  void _editMaterial(MaterialModel material) {
    setState(() {
      _selectedMaterial = material;
      _showAddForm = true;
    });
  }

  Future<void> _handleMaterialSubmit(MaterialModel material) async {
    setState(() => _isLoading = true);
    try {
      if (material.id.isEmpty) {
        await _bomService.addMaterial(material);
      } else {
        await _bomService.updateMaterial(material);
      }
      setState(() {
        _showAddForm = false;
        _selectedMaterial = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<String> _getCategories(List<MaterialModel> materials) {
    return materials.map((m) => m.category).toSet().toList()..sort();
  }

  Widget _buildMaterialGrid(List<MaterialModel> materials) {
    // Apply filters
    var filteredMaterials = materials.where((material) {
      if (_selectedCategory != null && material.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return material.name.toLowerCase().contains(query) ||
            material.category.toLowerCase().contains(query) ||
            material.supplier.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800
                ? 2
                : 1;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.5, // Adjusted for better card fit
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          padding: EdgeInsets.zero, // Remove padding
          shrinkWrap: true, // Add this to prevent extra space
          physics: const AlwaysScrollableScrollPhysics(), // Keep scrolling
          itemCount: filteredMaterials.length,
          itemBuilder: (context, index) {
            final material = filteredMaterials[index];
            return MaterialCard(
              material: material,
              onEdit: () => _editMaterial(material),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth > 600
              ? AppSpacing.tabletPadding
              : AppSpacing.mobilePadding;

          return Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bill of Materials', style: AppTextStyles.heading1),
                    Row(
                      children: [
                        if (!_showAddForm && _showCatalog)
                          ElevatedButton.icon(
                            onPressed: _toggleAddForm,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Material'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                AppSpacing.minButtonWidth,
                                AppSpacing.minButtonHeight,
                              ),
                            ),
                          ),
                        SizedBox(width: AppSpacing.md),
                        Switch(
                          value: _showCatalog,
                          onChanged: (_) => _toggleView(),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          _showCatalog ? 'Catalog View' : 'Project View',
                          style: AppTextStyles.body1,
                        ),
                      ],
                    ),
                  ],
                ),
                if (!_showCatalog) ...[
                  SizedBox(height: AppSpacing.md),
                  // TODO: Replace with actual project selector
                  DropdownButton<String>(
                    value:
                        _selectedProjectId.isEmpty ? null : _selectedProjectId,
                    hint: const Text('Select a project'),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'project1',
                        child: Text('Project 1'),
                      ),
                      DropdownMenuItem(
                        value: 'project2',
                        child: Text('Project 2'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedProjectId = value);
                      }
                    },
                  ),
                ],
                SizedBox(height: AppSpacing.lg),
                if (_showAddForm)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: MaterialForm(
                        material: _selectedMaterial,
                        onSubmit: _handleMaterialSubmit,
                        onClose: _toggleAddForm,
                        isLoading: _isLoading,
                      ),
                    ),
                  )
                else if (_showCatalog)
                  Expanded(
                    child: StreamBuilder<List<MaterialModel>>(
                      stream: _bomService.getMaterials(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final materials = snapshot.data!;
                        final categories = _getCategories(materials);

                        return Column(
                          children: [
                            SearchFilterBar(
                              searchQuery: _searchQuery,
                              onSearchChanged: (value) =>
                                  setState(() => _searchQuery = value),
                              selectedCategory: _selectedCategory,
                              categories: categories,
                              onCategoryChanged: (value) =>
                                  setState(() => _selectedCategory = value),
                            ),
                            SizedBox(height: AppSpacing.md),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.lg,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.lg,
                                  ),
                                  child: _buildMaterialGrid(materials),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else if (_selectedProjectId.isNotEmpty)
                  Expanded(child: ProjectBoMView(projectId: _selectedProjectId))
                else
                  const Expanded(
                    child: Center(
                      child: Text('Please select a project to view its BoM'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
