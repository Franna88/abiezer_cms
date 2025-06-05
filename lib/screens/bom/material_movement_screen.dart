import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bom_provider.dart';
import '../../models/material_movement.dart';

class MaterialMovementScreen extends StatefulWidget {
  final String projectId;
  final String userRole;
  final String? materialId;
  final String? materialName;
  final double? currentStock;
  final String? unit;

  const MaterialMovementScreen({
    Key? key,
    required this.projectId,
    required this.userRole,
    this.materialId,
    this.materialName,
    this.currentStock,
    this.unit,
  }) : super(key: key);

  @override
  State<MaterialMovementScreen> createState() => _MaterialMovementScreenState();
}

class _MaterialMovementScreenState extends State<MaterialMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _referenceController = TextEditingController();
  MovementType _selectedActionType = MovementType.use;

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _submitMovement() async {
    if (_formKey.currentState!.validate()) {
      final quantity = double.parse(_quantityController.text);

      await context.read<BomProvider>().recordMaterialMovement(
            projectId: widget.projectId,
            materialId: widget.materialId!,
            actionType: _selectedActionType,
            quantity: quantity,
            performedBy: 'current_user_id', // TODO: Get from auth provider
            performedByRole: widget.userRole,
            notes: _notesController.text,
            location: _locationController.text,
            reference: _referenceController.text,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.materialId != null
            ? Text('Record ${widget.materialName} Movement')
            : const Text('Movement History'),
      ),
      body: widget.materialId != null
          ? _buildMovementForm()
          : _buildMovementHistory(),
    );
  }

  Widget _buildMovementForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.userRole == 'admin')
              DropdownButtonFormField<MovementType>(
                value: _selectedActionType,
                decoration: const InputDecoration(
                  labelText: 'Action Type',
                ),
                items: MovementType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedActionType = value;
                    });
                  }
                },
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                suffixText: widget.unit,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _referenceController,
              decoration: const InputDecoration(
                labelText: 'Reference (Optional)',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitMovement,
              child: const Text('Record Movement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementHistory() {
    return Consumer<BomProvider>(
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

        final movements = bomProvider.movements;
        if (movements.isEmpty) {
          return const Center(
            child: Text('No movement history found'),
          );
        }

        return ListView.builder(
          itemCount: movements.length,
          itemBuilder: (context, index) {
            final movement = movements[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                title: Text(movement.actionType
                    .toString()
                    .split('.')
                    .last
                    .toUpperCase()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${movement.quantity}'),
                    Text('Previous: ${movement.previousQuantity}'),
                    Text('New: ${movement.newQuantity}'),
                    Text('Notes: ${movement.notes}'),
                    if (movement.location != null)
                      Text('Location: ${movement.location}'),
                    if (movement.reference != null)
                      Text('Reference: ${movement.reference}'),
                    Text(
                      'By: ${movement.performedBy} (${movement.performedByRole})',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'Date: ${movement.timestamp.toString()}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
