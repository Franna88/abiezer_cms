import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bom_provider.dart';
import '../../models/bill_of_materials.dart';
import 'material_movement_screen.dart';

class BomListScreen extends StatelessWidget {
  final String projectId;
  final String userRole;

  const BomListScreen({
    Key? key,
    required this.projectId,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill of Materials'),
        actions: [
          if (userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implement add material functionality
              },
            ),
        ],
      ),
      body: Consumer<BomProvider>(
        builder: (context, bomProvider, child) {
          if (bomProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bomProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${bomProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final bom = bomProvider.currentBom;
          if (bom == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No Bill of Materials found for this project'),
                  const SizedBox(height: 16),
                  if (userRole == 'admin')
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement create BOM functionality
                      },
                      child: const Text('Create Bill of Materials'),
                    ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: bom.materials.length,
                  itemBuilder: (context, index) {
                    final material = bom.materials[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(material.name),
                        subtitle: Text(
                          'Current Stock: ${material.currentStock} ${material.unit}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (userRole == 'project_manager')
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MaterialMovementScreen(
                                        projectId: projectId,
                                        materialId: material.materialId,
                                        materialName: material.name,
                                        currentStock: material.currentStock,
                                        unit: material.unit,
                                        userRole: userRole,
                                      ),
                                    ),
                                  );
                                },
                                tooltip: 'Mark as Used',
                              ),
                            if (userRole == 'admin') ...[
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  // TODO: Implement add stock functionality
                                },
                                tooltip: 'Add Stock',
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  // TODO: Implement remove stock functionality
                                },
                                tooltip: 'Remove Stock',
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (userRole == 'admin' || userRole == 'project_manager')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaterialMovementScreen(
                            projectId: projectId,
                            userRole: userRole,
                          ),
                        ),
                      );
                    },
                    child: const Text('View Movement History'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
