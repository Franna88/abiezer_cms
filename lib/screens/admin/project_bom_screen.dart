import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/projects_provider.dart';
import '../../utils/responsive.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/info_card.dart';

class ProjectBoMScreen extends StatefulWidget {
  const ProjectBoMScreen({super.key});

  @override
  State<ProjectBoMScreen> createState() => _ProjectBoMScreenState();
}

class _ProjectBoMScreenState extends State<ProjectBoMScreen> {
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill of Materials'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to BoM history
            },
            tooltip: 'View History',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              // TODO: Navigate to BoM analytics
            },
            tooltip: 'View Analytics',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    'Error: $_error',
                    style: const TextStyle(color: AppTheme.errorColor),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(
                    Responsive.getResponsiveValue(
                      context: context,
                      mobile: 16.0,
                      tablet: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchAndFilter(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildMaterialsCatalog(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 3,
                              child: _buildSelectedMaterials(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              // TODO: Implement search
            },
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _selectedCategory,
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All Categories')),
            DropdownMenuItem(
                value: 'Construction', child: Text('Construction')),
            DropdownMenuItem(value: 'Electrical', child: Text('Electrical')),
            DropdownMenuItem(value: 'Plumbing', child: Text('Plumbing')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedCategory = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMaterialsCatalog() {
    return InfoCard(
      title: 'Materials Catalog',
      child: ListView.builder(
        itemCount: 10, // TODO: Replace with actual materials
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text('Material ${index + 1}'),
            subtitle: Text('Category ${index % 3 + 1}'),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                // TODO: Add material to selected
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedMaterials() {
    return InfoCard(
      title: 'Selected Materials',
      actions: [
        TextButton.icon(
          onPressed: () {
            // TODO: Save BoM
          },
          icon: const Icon(Icons.save),
          label: const Text('Save BoM'),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5, // TODO: Replace with actual selected materials
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text('Selected Material ${index + 1}'),
                    subtitle: Text('Quantity: ${(index + 1) * 10}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // TODO: Decrease quantity
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // TODO: Increase quantity
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // TODO: Remove material
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Items:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '5', // TODO: Replace with actual count
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
