import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/bill_of_materials_model.dart';
import '../../core/models/material_model.dart';
import '../../core/models/project_model.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/common/section_header.dart';
import 'widgets/material_cart_item.dart';

class CreateBomScreen extends StatefulWidget {
  final String projectId;
  final UserModel currentUser;
  final BillOfMaterialsModel? existingBom; // If editing an existing BOM

  const CreateBomScreen({
    super.key,
    required this.projectId,
    required this.currentUser,
    this.existingBom,
  });

  @override
  State<CreateBomScreen> createState() => _CreateBomScreenState();
}

class _CreateBomScreenState extends State<CreateBomScreen> {
  bool _isLoading = true;
  late ProjectModel _project;
  List<MaterialModel> _availableMaterials = [];
  List<MaterialModel> _leftoverMaterials = [];
  List<BomItemModel> _selectedMaterials = [];
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _materialSource = 'all'; // 'all', 'new', 'leftover'
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Load project details
    await _loadProjectDetails();

    // Load available materials
    await _loadAvailableMaterials();

    // If editing existing BOM, load selected materials
    if (widget.existingBom != null) {
      _selectedMaterials = List.from(widget.existingBom!.items);
      _calculateTotalCost();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadProjectDetails() async {
    // In a real app, this would fetch the project details from a backend service
    // For now, we'll just simulate a loading delay and use dummy data
    await Future.delayed(const Duration(milliseconds: 500));

    // Find the project in our dummy data by ID
    _project = _getDummyProject(widget.projectId);
  }

  Future<void> _loadAvailableMaterials() async {
    // In a real app, this would fetch the available materials from a backend service
    // For now, we'll just simulate a loading delay and use dummy data
    await Future.delayed(const Duration(milliseconds: 500));

    // Load new materials
    _availableMaterials = [
      MaterialModel(
        id: '1',
        name: 'Cement',
        category: 'Cement & Aggregates',
        unitOfMeasure: 'Bag',
        unitPrice: 85.0,
        description: 'Standard 50kg bag of Portland cement',
        isActive: true,
        status: 'new',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MaterialModel(
        id: '2',
        name: 'Hardboard',
        category: 'Boards & Sheets',
        unitOfMeasure: 'Sheet',
        unitPrice: 145.0,
        description: 'Standard 2.4m x 1.2m hardboard sheet',
        isActive: true,
        status: 'new',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MaterialModel(
        id: '3',
        name: 'Abebond',
        category: 'Adhesives & Chemicals',
        unitOfMeasure: 'Liter',
        unitPrice: 75.0,
        description: 'Multi-purpose adhesive for construction',
        isActive: true,
        status: 'new',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    // Load leftover materials from other projects
    _leftoverMaterials = [
      MaterialModel(
        id: '4',
        name: 'Paint Brushes',
        category: 'Paint & Finishing',
        unitOfMeasure: 'Each',
        unitPrice: 35.0,
        description: 'Premium paint brushes (75mm)',
        isActive: true,
        status: 'leftover',
        sourceProjectId: '2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MaterialModel(
        id: '5',
        name: 'Brick Force',
        category: 'Fasteners & Fixings',
        unitOfMeasure: 'Roll',
        unitPrice: 250.0,
        description: 'Standard brick force for reinforcement',
        isActive: true,
        status: 'leftover',
        sourceProjectId: '3',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // This would be replaced with a real API call in a production app
  ProjectModel _getDummyProject(String id) {
    return ProjectModel(
      id: id,
      name: 'Central Square Development',
      description:
          'Mixed-use development with residential and commercial spaces',
      location: 'Johannesburg CBD',
      clientName: 'Metroplex Developments',
      clientContact: 'contact@metroplex.co.za',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: null,
      status: AppConstants.projectStatusActive,
      assignedUsers: ['2', '3', '4'],
      projectManagerId: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  void _calculateTotalCost() {
    _totalCost = _selectedMaterials.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.material.unitPrice),
    );
  }

  List<MaterialModel> get _filteredMaterials {
    List<MaterialModel> materials = [];

    // Add materials based on source filter
    if (_materialSource == 'all' || _materialSource == 'new') {
      materials.addAll(_availableMaterials);
    }

    if (_materialSource == 'all' || _materialSource == 'leftover') {
      materials.addAll(_leftoverMaterials);
    }

    return materials.where((material) {
      // Filter by search query
      if (_searchQuery.isNotEmpty &&
          !material.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Filter by category
      if (_selectedCategory != 'All Categories' &&
          material.category != _selectedCategory) {
        return false;
      }

      // Exclude materials already in the cart
      if (_selectedMaterials.any((item) => item.material.id == material.id)) {
        return false;
      }

      return true;
    }).toList();
  }

  void _handleAddMaterial(MaterialModel material) {
    // Check if user has permission to add materials
    if (!widget.currentUser.canCreateBillOfMaterials) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to add materials.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _showQuantityDialog(material);
  }

  void _showQuantityDialog(MaterialModel material) {
    double quantity = 1.0;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add ${material.name}'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit Price: ${Utils.formatCurrency(material.unitPrice)}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unit: ${material.unitOfMeasure}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    initialValue: '1.0',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      try {
                        final qty = double.parse(value);
                        if (qty <= 0) {
                          return 'Quantity must be greater than zero';
                        }
                      } catch (e) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      try {
                        quantity = double.parse(value);
                      } catch (e) {
                        // Invalid number, ignore
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    setState(() {
                      // Add material to cart
                      final newItem = BomItemModel(
                        id: const Uuid().v4(),
                        material: material,
                        quantity: quantity,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      _selectedMaterials.add(newItem);
                      _calculateTotalCost();
                    });
                  }
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
    );
  }

  void _handleRemoveMaterial(String id) {
    setState(() {
      _selectedMaterials.removeWhere((item) => item.id == id);
      _calculateTotalCost();
    });
  }

  void _handleUpdateQuantity(String id, double quantity) {
    final index = _selectedMaterials.indexWhere((item) => item.id == id);
    if (index >= 0) {
      setState(() {
        _selectedMaterials[index] = _selectedMaterials[index].copyWith(
          quantity: quantity,
          updatedAt: DateTime.now(),
        );
        _calculateTotalCost();
      });
    }
  }

  void _handleSave() {
    // Check if user has permission to create bill of materials
    if (!widget.currentUser.canCreateBillOfMaterials) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You do not have permission to create bill of materials.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedMaterials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one material.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Create or update the BOM
    final bom = BillOfMaterialsModel(
      id: widget.existingBom?.id ?? const Uuid().v4(),
      projectId: widget.projectId,
      items: _selectedMaterials,
      totalCost: _totalCost,
      createdBy: widget.currentUser.id,
      createdAt: widget.existingBom?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // In a real app, this would save the BOM to a backend service
    print('Saving BOM: ${bom.toJson()}');

    // Return to previous screen
    Navigator.pop(context, bom);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleCategoryFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleSourceFilter(String source) {
    setState(() {
      _materialSource = source;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingBom != null
              ? 'Edit Bill of Materials'
              : 'Create Bill of Materials',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCancel,
        ),
        actions: [
          TextButton.icon(
            onPressed: _handleSave,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: LoadingIndicator())
              : ResponsiveLayout(
                mobile: _buildMobileLayout(context),
                tablet: _buildTabletLayout(context),
                desktop: _buildDesktopLayout(context),
              ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildProjectHeader(),
        _buildMaterialFilters(),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Available Materials'),
                    Tab(text: 'Selected Materials'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAvailableMaterialsList(),
                      _buildSelectedMaterialsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildCartSummary(),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        _buildProjectHeader(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildMaterialFilters(),
                    Expanded(child: _buildAvailableMaterialsList()),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SectionHeader(title: 'Selected Materials'),
                    Expanded(child: _buildSelectedMaterialsList()),
                    _buildCartSummary(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return _buildTabletLayout(context);
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project: ${_project.name}', style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(
            'Location: ${_project.location}',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _handleSearch,
          ),
          const SizedBox(height: 16),

          // Filter row
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Category dropdown
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? value) {
                  if (value != null) {
                    _handleCategoryFilter(value);
                  }
                },
                items:
                    [
                      'All Categories',
                      ...AppConstants.materialCategories,
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),

              // Material source filter
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(value: 'all', label: Text('All')),
                  ButtonSegment<String>(value: 'new', label: Text('New')),
                  ButtonSegment<String>(
                    value: 'leftover',
                    label: Text('Leftover'),
                  ),
                ],
                selected: {_materialSource},
                onSelectionChanged: (Set<String> newSelection) {
                  _handleSourceFilter(newSelection.first);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableMaterialsList() {
    if (_filteredMaterials.isEmpty) {
      return const Center(
        child: Text('No materials match your filter criteria.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredMaterials.length,
      itemBuilder: (context, index) {
        final material = _filteredMaterials[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(material.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${material.unitOfMeasure} - ${Utils.formatCurrency(material.unitPrice)}',
                ),
                if (material.isLeftover)
                  Text(
                    'Leftover from another project',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            trailing: ElevatedButton.icon(
              onPressed: () => _handleAddMaterial(material),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedMaterialsList() {
    if (_selectedMaterials.isEmpty) {
      return const Center(
        child: Text(
          'No materials selected. Add materials from the available list.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _selectedMaterials.length,
      itemBuilder: (context, index) {
        final item = _selectedMaterials[index];
        return MaterialCartItem(
          item: item,
          onRemove: _handleRemoveMaterial,
          onUpdateQuantity: _handleUpdateQuantity,
        );
      },
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Items:',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selectedMaterials.length}',
                style: AppTextStyles.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Cost:', style: AppTextStyles.heading4),
              Text(
                Utils.formatCurrency(_totalCost),
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Bill of Materials'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
